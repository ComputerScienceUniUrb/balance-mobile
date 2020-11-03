
/// Class representing the single raw data captured from sensors
///
/// This class contains the data obtained from all the sensors
/// during a single event, so a list of [SensorData] will represent
/// all the sensors data collected during a test.
/// The data collected are:
/// - timestamp
/// - accuracy
/// - accelerometer x,y,z
/// - gyroscope x,y,z
class SensorData {
  final int timestamp;
  final int accuracy;
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;
  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;

  SensorData(
    this.timestamp,
    this.accuracy,
    this.accelerometerX,
    this.accelerometerY,
    this.accelerometerZ,
    this.gyroscopeX,
    this.gyroscopeY,
    this.gyroscopeZ,
  );

  @override
  String toString() => "SensorData(timestamp=$timestamp, "
    "accuracy=$accuracy, "
    "accelerometerX=$accelerometerX, "
    "accelerometerY=$accelerometerY, "
    "accelerometerZ=$accelerometerZ, "
    "gyroscopeX=$gyroscopeX, "
    "gyroscopeY=$gyroscopeY, "
    "gyroscopeZ=$gyroscopeZ)";

  @override
  bool operator ==(other) =>
    other is SensorData &&
      other.timestamp == this.timestamp &&
      other.accuracy == this.accuracy &&
      other.accelerometerX == this.accelerometerX &&
      other.accelerometerY == this.accelerometerY &&
      other.accelerometerZ == this.accelerometerZ &&
      other.gyroscopeX == this.gyroscopeX &&
      other.gyroscopeY == this.gyroscopeY &&
      other.gyroscopeZ == this.gyroscopeZ;

  @override
  int get hashCode {
    final int prime = 31;
    int result = 1;
    result = prime * result + timestamp.hashCode;
    result = prime * result + accuracy.hashCode;
    result = prime * result + accelerometerX.hashCode;
    result = prime * result + accelerometerY.hashCode;
    result = prime * result + accelerometerZ.hashCode;
    result = prime * result + gyroscopeX.hashCode;
    result = prime * result + gyroscopeY.hashCode;
    result = prime * result + gyroscopeZ.hashCode;
    return result;
  }
}