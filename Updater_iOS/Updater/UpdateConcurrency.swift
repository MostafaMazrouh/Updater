//
//  StockConcurrency.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-18.
//

import Foundation
import AsyncAlgorithms

class UpdateConcurrency {
    
    private let observer1 = AsyncThrowingChannel<String, Never>()
    
    private let observer2 = AsyncThrowingChannel<String, Never>()
    
    let asyncChannel = AsyncThrowingChannel<(String, String), Never>()
    
    let currentValueChannel = CurrentValueChannel<(String, String)>(value: ("", ""))
    
    private let sleepDuration: Double = 0.10 // In seconds
    
    init() {
        Task {
            do {
                try await setup()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func setup() async throws {
        
        try startUpdating()
        
        for try await value in combineLatest(observer1, observer2)
            ._throttle(for: .seconds(3), latest: true) {
            await currentValueChannel.send(value)
        }
    }
    
    private func startUpdating() throws {
        Task {
            while true {
                try await Task.sleep(for: .seconds(sleepDuration))
                
                await observer1.send(newKeyword)
                await observer2.send(newKeyword)
                
                try await Task.sleep(for: .seconds(sleepDuration))
                
                await observer2.send(newKeyword)
            }
        }
    }
}
