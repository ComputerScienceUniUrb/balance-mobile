package it.uniurb.balance_app.sensor

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.Log
import it.uniurb.balance_app.model.SensorData

/**
 * Listen Accelerometer and Gyroscope events from the device and
 * store their values in a [SensorSharedValues] instance
 *
 * @param context Context of the application used to retrieve the sensors
 * @see SensorMonitor
 * @author Lorenzo Calisti on 09/03/2020
 */
class SensorListener(context: Context): SensorEventListener {

	companion object {
		private const val TAG = "SensorListener"
	}

	private val mSensorManager = context.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
	private val mRawAccelerometerSensor: Sensor? = mSensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
	private val mRawGyroscopeSensor: Sensor? = mSensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
	private val mSharedValues = SensorSharedValues.instance

	private var mListening: Boolean = false

	/** Returns true if the accelerometer sensor is present */
	fun isAccelerometerPresent(): Boolean = mRawAccelerometerSensor != null
	/** Returns true if the gyroscope sensor is present */
	fun isGyroscopePresent(): Boolean = mRawGyroscopeSensor != null

	/**
	 * Start listening to sensor data
	 *
	 * If we are not already listening start to listen
	 * the sensors, if their are present.
	 */
	fun startListening() {
		if (!mListening) {
			mListening = true
			if (isAccelerometerPresent())
				mSensorManager?.registerListener(this, mRawAccelerometerSensor,
					SensorManager.SENSOR_DELAY_FASTEST)
			if (isGyroscopePresent())
				mSensorManager?.registerListener(this, mRawGyroscopeSensor,
					SensorManager.SENSOR_DELAY_FASTEST)
		}
	}

	/**
	 * Stop listening to sensor data
	 */
	fun stopListening() {
		if (mListening) {
			mListening = false
			mSensorManager?.unregisterListener(this)
		}
	}

	override fun onSensorChanged(event: SensorEvent?) {
		when (event?.sensor?.type) {
			// Build a SensorData with accelerometer values
			Sensor.TYPE_ACCELEROMETER -> mSharedValues.currentAccelerometerValue = SensorData(
				event.timestamp,
				event.accuracy,
				event.values[0],
				event.values[1],
				event.values[2]
			)
			// Build a SensorData with gyroscope values
			Sensor.TYPE_GYROSCOPE -> mSharedValues.currentGyroscopeValue = SensorData(
				event.timestamp,
				event.accuracy,
				event.values[0],
				event.values[1],
				event.values[2]
			)
		}
	}

	override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
		Log.w(TAG, "onAccuracyChanged: The accuracy of sensor ${sensor?.name} is now $accuracy")
	}
}