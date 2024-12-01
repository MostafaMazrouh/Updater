package com.updater.updater

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow


class LiveUpdatesVM: ViewModel()  {

    val updateConcurrency = UpdateConcurrency()

    private val _concurrencyKeywords = MutableStateFlow("...")
    val concurrencyKeywords = _concurrencyKeywords.asStateFlow()

    private val _currentValue = MutableStateFlow("...")
    val currentValue = _currentValue.asStateFlow()

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

        updateConcurrency.currentValueChannel.flow.collect { value ->
            _concurrencyKeywords.value = value // Propagate data to the StateFlow
        }
    }

    fun saveValue() {
        _currentValue.value = updateConcurrency.currentValueChannel.getCurrentValue()
    }

    fun startUpdating() {
        viewModelScope.launch {
        }
    }
}