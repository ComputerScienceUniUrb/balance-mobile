package srl.digit.balance.sensor

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import srl.digit.balance.model.SensorData
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

/**
 * Class implementing a Sensor specific [EventChannel.StreamHandler]
 *
 * During [onListen] the sensors are listened to by [SensorListener] and
 * a [SensorPollingRunnable] is executed in a separate thread; every time
 * a new sensor value is emitted by the thread it is automatically added to
 * the [EventChannel.EventSink].
 * The thread pool and the [SensorListener] are all teardown during [onCancel].
 *
 * @param context Context of the application
 * @see SensorSharedValues
 * @see SensorListener
 * @see SensorPollingRunnable
 * @author Lorenzo Calisti on 09/03/2020
 */
class SensorMonitor(context: Context): EventChannel.StreamHandler {
	private val mSharedValues = SensorSharedValues.instance
	private val mSensorListener = SensorListener(context)
	private val mUiThreadHandler: Handler = Handler(Looper.getMainLooper())
	private var mThreadPool: ExecutorService? = null

	/** Returns true if the accelerometer sensor is present */
	fun isAccelerometerPresent(): Boolean = mSensorListener.isAccelerometerPresent()
	/** Returns true if the gyroscope sensor is present */
	fun isGyroscopePresent(): Boolean = mSensorListener.isGyroscopePresent()

	override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
		mSharedValues.reset()
		mSensorListener.startListening()
		mThreadPool = Executors.newSingleThreadExecutor()
		mThreadPool?.execute(SensorPollingRunnable(
			mUiThreadHandler,
			Runnable {
				events?.success(SensorData.mergeSensorData(
					mSharedValues.currentAccelerometerValue,
					mSharedValues.currentGyroscopeValue
				))
			})
		)
	}

	override fun onCancel(arguments: Any?) {
		mThreadPool?.shutdownNow()
		try {
			mThreadPool?.awaitTermination(0L, TimeUnit.SECONDS)
		} catch (ex: InterruptedException) {
			ex.printStackTrace()
		} finally {
			mSensorListener.stopListening()
			mThreadPool = null
		}
	}
}