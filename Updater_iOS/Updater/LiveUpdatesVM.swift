//
//  LiveUpdatesVM.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-17.
//

import Foundation
import Combine


class LiveUpdatesVM: ObservableObject {
    
    @Published var combineKeywords = ""
    @Published var combineCurrent = ""
    
    @Published var concurrencyKeywords = ""
    @Published var concurrencyCurrent = ""
    
    let updateCombine = UpdateCombine()
    let updateConcurrency = UpdateConcurrency()
    
    func updateCombineCurrent() {
        combineCurrent = "(\(updateCombine.currentValueSubject.value.0), \(updateCombine.currentValueSubject.value.1))"
    }
    
    @MainActor
    func updateConcurrencyCurrent() {
        Task {
            concurrencyCurrent = """
(\( await updateConcurrency.currentValueChannel.getCurrentValue().0), \(
    await updateConcurrency.currentValueChannel.getCurrentValue().1))
"""
            
//            updateConcurrency.asyncChannel.value
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        startInsights()
    }
    
    func startInsights() {
        startCombine()
        
        Task {
            try await startConcurrency()
        }
    }
    
    func startCombine() {
        updateCombine.currentValueSubject.sink { [weak self] (keyword1, keyword2) in
            self?.combineKeywords = """
                                1st keyword **\(keyword1)**
                                
                                2nd keyword **\(keyword2)**
                                """
        }
        .store(in: &cancellables)
    }
    
    @MainActor
    func startConcurrency() async throws {
        for try await (keyword1, keyword2) in await updateConcurrency.currentValueChannel.channel {
            concurrencyKeywords = """
                                1st keyword **\(keyword1)**
                                
                                2nd keyword **\(keyword2)**
                                """
        }
    }
}
