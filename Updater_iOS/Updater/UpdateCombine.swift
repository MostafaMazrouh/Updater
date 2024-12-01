//
//  StockCombine.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-18.
//

import Foundation
import Combine

class UpdateCombine {
    
    private let observer1 = CurrentValueSubject<String, Never>("")
    private let observer2 = CurrentValueSubject<String, Never>("")
    
    var currentValueSubject = CurrentValueSubject<(String, String), Never>(("", ""))
    
    private var cancellables = Set<AnyCancellable>()
    
    private let sleepDuration: Double = 0.10 // In seconds
    
    
    init() {
        setup()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: startUpdating)
    }
    
    func setup() {
        Publishers.CombineLatest(observer1, observer2)
            .throttle(for: .seconds(3), scheduler: RunLoop.current, latest: true)
            .sink(receiveValue: { [weak self] (appleStock, googleStock) in
                self?.currentValueSubject.send((appleStock, googleStock))
            })
            .store(in: &cancellables)
    }
    
    func startUpdating() {
        
        while true {
            Thread.sleep(forTimeInterval: sleepDuration)
            
            observer1.send(newKeyword)
            observer2.send(newKeyword)
            
            Thread.sleep(forTimeInterval: sleepDuration)
            
            observer2.send(newKeyword)
        }
    }
}
