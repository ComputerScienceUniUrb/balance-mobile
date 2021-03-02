package srl.digit.balance.sensor

import android.os.Handler

/**
 * Listen to the sensor data at a fix rate
 *
 * This class is a thread that listen the current value of
 * accelerometer and gyroscope from [srl.digit.balance.sensor.SensorSharedValues],
 * sends it to the [io.flutter.plugin.common.EventChannel.EventSink] and then sleeps.
 * The desired sample rate is 100Hz so this thread needs to sleeps for 10ms.
 *
 * @see SensorMonitor
 * @author Lorenzo Calisti on 09/03/2020
 */
class SensorPollingRunnable(
	private val handler: Handler,
	private val runnable: Runnable
): Runnable {

	override fun run() {
		while (!Thread.currentThread().isInterrupted) {
			try {
				Thread.sleep(10)
				handler.post(runnable)
			} catch (ex: InterruptedException) {
				Thread.currentThread().interrupt()
			}
		}
	}
}