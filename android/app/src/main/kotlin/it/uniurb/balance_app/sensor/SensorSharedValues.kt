package it.uniurb.balance_app.sensor

import it.uniurb.balance_app.model.SensorData

/**
 * Singleton class used to share sensor data between threads
 *
 * @see SensorMonitor
 * @see SensorListener
 * @see SensorPollingRunnable
 * @author Lorenzo Calisti on 09/03/2020
 */
class SensorSharedValues {

	companion object {
		private var mInstance: SensorSharedValues? = null

		/** Return a single instance of [SensorSharedValues] */
		val instance: SensorSharedValues
			get() {
				if (mInstance == null)
					mInstance = SensorSharedValues()
				return mInstance!!
			}
	}

	/** Reset all the values to null */
	fun reset() {
		currentAccelerometerValue = null
		currentGyroscopeValue = null
	}

	/** Current accelerometer [SensorData] */
	@Volatile var currentAccelerometerValue: SensorData? = null
	/** Current gyroscope [SensorData] */
	@Volatile var currentGyroscopeValue: SensorData? = null
}