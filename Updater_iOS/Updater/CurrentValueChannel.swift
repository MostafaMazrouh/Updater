//
//  AsyncChannelCurrent.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-18.
//

import Foundation
import AsyncAlgorithms

/// A simple wrapper to mimic CurrentValueSubject with AsyncChannel
actor CurrentValueChannel<Value> {
    
    private var currentValue: Value
    let channel = AsyncChannel<Value>() // pass through subject

    init(value: Value) {
        self.currentValue = value
    }

    /// Get the current cached value
    func getCurrentValue() -> Value {
        currentValue
    }

    /// Update the current value and notify observers
    func send(_ newValue: Value) async {
        currentValue = newValue
        await channel.send(newValue)
    }

    /// Observe the value as it changes
    func observe() -> AsyncChannel<Value>.AsyncIterator {
        channel.makeAsyncIterator()
    }
}
