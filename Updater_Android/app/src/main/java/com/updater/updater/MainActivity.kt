package com.updater.updater

import android.os.Bundle
import androidx.activity.*
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.*
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModelProvider
import com.updater.updater.ui.theme.UpdaterTheme


class MainActivity : ComponentActivity() {
    private lateinit var viewModel: LiveUpdatesVM

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        viewModel = ViewModelProvider(this)[LiveUpdatesVM::class.java]

        enableEdgeToEdge()
        setContent {
            UpdaterTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Greeting(
                        viewModel = viewModel,
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun Greeting(viewModel: LiveUpdatesVM, modifier: Modifier = Modifier) {

    val concurrencyInsight: String = viewModel.concurrencyKeywords.collectAsState().value
    val currentValue: String = viewModel.currentValue.collectAsState().value

    Box(
        modifier = Modifier
            .padding()
            .fillMaxSize()
            .background(Color.White, shape = RoundedCornerShape(10.dp))
            .padding(vertical = 200.dp, horizontal = 30.dp) // Inner padding for content
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .shadow(
                    elevation = 30.dp, // Shadow elevation
                    shape = RoundedCornerShape(8.dp), // Shape of the shadow
                    clip = false // Controls whether the shadow affects clipping
                )
                .background(
                    color = Color.Blue, // Background color
                    shape = RoundedCornerShape(8.dp) // Shape of the column
                )
                .clickable {
                    viewModel.saveValue()
                    println("onClick:: viewModel.saveValue()")
                }
                .padding(16.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.weight(1f))

            Text(
                text = concurrencyInsight,
                modifier = modifier,
                color = Color.White,
                fontWeight = FontWeight.Bold
            )

            Text(
                text = currentValue,
                modifier = modifier,
                color = Color.White,
            )

            Spacer(modifier = Modifier.weight(1f))
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    UpdaterTheme {
        Greeting(LiveUpdatesVM())
    }
}