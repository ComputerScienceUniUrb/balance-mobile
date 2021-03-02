package srl.digit.balance.model

/**
 * Class representing the data collected by the sensors
 *
 * This class stores one value retrieved by the accelerometer
 * or gyroscope sensors
 *
 * @param timestamp timestamp of the data
 * @param accuracy the accuracy of the sensors
 * @param x values along x axes
 * @param y values along x axes
 * @param z values along x axes
 *
 * @see srl.digit.balance.sensor.SensorMonitor
 * @see srl.digit.balance.sensor.SensorSharedValues
 * @see srl.digit.balance.sensor.SensorListener
 * @author Lorenzo Calisti on 09/03/2020
 */
data class SensorData(
	val timestamp: Long = 0L,
	val accuracy: Int = 0,
	val x: Float? = null,
	val y: Float? = null,
	val z: Float? = null
) {

	companion object {
		/**
		 * Merge two [SensorData] in a list
		 *
		 * Returns a list given by the combination of two [SensorData];
		 * the list will be then passed to Flutter in the [io.flutter.plugin.common.EventChannel].
		 * The list contains the data in the following order:
		 * 	- timestamp
		 * 	- accuracy
		 * 	- accelerometerX
		 * 	- accelerometerY
		 * 	- accelerometerZ
		 * 	- gyroscopeX
		 * 	- gyroscopeY
		 * 	- gyroscopeZ
		 *
		 * @param acc accelerometer [SensorData]
		 * @param gyr gyroscope [SensorData]
		 * @return List with the combination of the SensorData
		 */
		fun mergeSensorData(acc: SensorData?, gyr: SensorData?): List<Number?>? =
			when {
				// Merge the two data into one
				(acc != null && gyr != null) ->
					listOf(
						maxOf(acc.timestamp, gyr.timestamp),
						maxOf(acc.accuracy, gyr.accuracy),
						acc.x,
						acc.y,
						acc.z,
						gyr.x,
						gyr.y,
						gyr.z
					)
				// The gyroscope data are null
				acc != null -> listOf(acc.timestamp, acc.accuracy, acc.x, acc.y, acc.z, null, null, null)
				// The accelerometer data are null
				gyr != null -> listOf(gyr.timestamp, gyr.accuracy, null, null, null, gyr.x, gyr.y, gyr.z)
				// Both data are null, we cannot merge
				else -> null
			}
	}
}
