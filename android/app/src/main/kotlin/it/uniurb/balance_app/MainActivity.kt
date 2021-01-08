package it.uniurb.balance_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import it.uniurb.balance_app.sensor.SensorMonitor

/**
 *
 * @author Lorenzo Calisti on 09/03/2020
 */
class MainActivity: FlutterActivity() {

    private val sensorMonitor by lazy { SensorMonitor(context) }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        // Setup EventChannel for getting stream of sensors
        EventChannel(binaryMessenger, "uniurb.it/sensors/stream").setStreamHandler(sensorMonitor)
        // Setup MethodChannel for getting sensors information
        MethodChannel(binaryMessenger, "uniurb.it/sensors/presence")
                .setMethodCallHandler { call, result ->
                    when(call.method) {
                        "isAccelerometerPresent" -> result.success(sensorMonitor.isAccelerometerPresent())
                        "isGyroscopePresent" -> result.success(sensorMonitor.isGyroscopePresent())
                        else -> result.notImplemented()
                    }
                }
    }
}