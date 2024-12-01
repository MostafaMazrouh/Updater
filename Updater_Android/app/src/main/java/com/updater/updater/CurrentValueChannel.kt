package com.updater.updater

import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.receiveAsFlow

/**
 * A Kotlin implementation of AsyncChannelCurrent using Channel.
 * Mimics Swift's AsyncChannelCurrent.
 */
class CurrentValueChannel<Value>(initialValue: Value) {

    // The current cached value
    private var currentValue: Value = initialValue

    // The pass-through subject
    private val channel = Channel<Value>(Channel.BUFFERED)

    /**
     * Get the current cached value.
     */
    fun getCurrentValue(): Value = currentValue

    /**
     * Update the current value and notify observers.
     */
    suspend fun send(newValue: Value) {
        currentValue = newValue
        channel.send(newValue)
    }

    val flow = channel.receiveAsFlow()

    /**
     * Observe the value as it changes. Returns a ReceiveChannel for subscription.
     */
//    fun observe(): ReceiveChannel<Value> = channel

    // Observe as a Flow
    fun observe(): Flow<Value> = channel.receiveAsFlow()
}