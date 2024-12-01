package com.updater.updater
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlin.time.Duration
import kotlin.time.Duration.Companion.milliseconds


class UpdateConcurrency {
    private val observer1 = Channel<String>(Channel.CONFLATED) // Channel.BUFFERED
    private val observer2 = Channel<String>(Channel.CONFLATED)

    val currentValueChannel = CurrentValueChannel("Initial Value")

    init {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                setup()

            } catch (e: Exception) {
                println("Error: ${e.message}")
            }
        }
    }

    private suspend fun setup() {
        startUpdating()

        // Combine latest values with throttling
        combineLatest(
            observer1.receiveAsFlow(),
            observer2.receiveAsFlow()
        )
            .throttle(3000.milliseconds)
            .collect { value ->
                val newValue = " 1st keyword: ${value.first} \n 2nd keyword: ${value.second}"
                currentValueChannel.send(newValue)
            }
    }

    fun startUpdating() {
        CoroutineScope(Dispatchers.Default).launch {
            while (isActive) { // Ensures the loop stops when the ViewModel is cleared

                observer1.send(newKeyword)
                observer2.send(newKeyword)

                delay(sleepDuration)

                observer2.send(newKeyword)
            }
        }
    }

    fun <T> combineLatest(
        flow1: Flow<T>,
        flow2: Flow<T>
    ): Flow<Pair<T, T>> {
        return flow1.combine(flow2) { value1: T, value2: T ->
            value1 to value2
        }
    }

    fun <T> Flow<T>.throttle(duration: Duration): Flow<T> = flow {
        var lastTime = 0L
        this@throttle.collect { value ->
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastTime > duration.inWholeMilliseconds) {
                emit(value)
                lastTime = currentTime
            }
        }
    }.flowOn(Dispatchers.Default)
}