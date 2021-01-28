
import 'package:floor/floor.dart';
import 'package:balance_app/model/measurement.dart';
import 'package:balance_app/model/sensor_data.dart';

@Entity(
  tableName: "raw_measurements_data",
  foreignKeys: [
    ForeignKey(
      entity: Measurement,
      parentColumns: ["id"],
      childColumns: ["measurement_id"],
      onDelete: ForeignKeyAction.CASCADE,
      onUpdate: ForeignKeyAction.CASCADE,
    )
  ]
)
class RawMeasurementData {
  @PrimaryKey(autoGenerate: true) final int id;
  @ColumnInfo() final String token;
  @ColumnInfo(name: "measurement_id", nullable: false) final int measurementId;
  @ColumnInfo() final int timestamp;
  @ColumnInfo() final int accuracy;
  @ColumnInfo(name: "accelerometer_x") final double accelerometerX;
  @ColumnInfo(name: "accelerometer_y") final double accelerometerY;
  @ColumnInfo(name: "accelerometer_z") final double accelerometerZ;
  @ColumnInfo(name: "gyroscope_x") final double gyroscopeX;
  @ColumnInfo(name: "gyroscope_y") final double gyroscopeY;
  @ColumnInfo(name: "gyroscope_z") final double gyroscopeZ;

  RawMeasurementData({
    this.id,
    this.token,
    this.measurementId,
    this.timestamp,
    this.accuracy,
    this.accelerometerX,
    this.accelerometerY,
    this.accelerometerZ,
    this.gyroscopeX,
    this.gyroscopeY,
    this.gyroscopeZ,
  });

  factory RawMeasurementData.fromSensorData(int measurementId, String token, SensorData sensorData) {
    return RawMeasurementData(
      measurementId: measurementId,
      token: token,
      timestamp: sensorData.timestamp,
      accuracy: sensorData.accuracy,
      accelerometerX: sensorData.accelerometerX,
      accelerometerY: sensorData.accelerometerY,
      accelerometerZ: sensorData.accelerometerZ,
      gyroscopeX: sensorData.gyroscopeX,
      gyroscopeY: sensorData.gyroscopeY,
      gyroscopeZ: sensorData.gyroscopeZ,
    );
  }

  /// Maps this object to json
  Map toJson() => {
      "id": this.id,
      "token": this.token,
      "measurementId": this.measurementId,
      "timestamp": this.timestamp,
      "accuracy": this.accuracy,
      "accelerometerX": this.accelerometerX,
      "accelerometerY": this.accelerometerY,
      "accelerometerZ": this.accelerometerZ,
      "gyroscopeX": this.gyroscopeX,
      "gyroscopeY": this.gyroscopeY,
      "gyroscopeZ": this.gyroscopeZ,
    };

  @override
  String toString() => "RawMeasurement("
    "id=$id, "
    "measurementId=$measurementId, "
    "timestamp=$timestamp, "
    "accuracy=$accuracy, "
    "accelerometerX=$accelerometerX, "
    "accelerometerY=$accelerometerY, "
    "accelerometerZ=$accelerometerZ, "
    "gyroscopeX=$gyroscopeX, "
    "gyroscopeY=$gyroscopeY, "
    "gyroscopeZ=$gyroscopeZ)";

  String toCSV() {
      return '$id;$measurementId;$timestamp;$accuracy;$accelerometerX;$accelerometerY;'
             '$accelerometerZ;$gyroscopeX;$gyroscopeY;$gyroscopeZ\n';
  }

  @override
  int get hashCode {
    final int prime = 31;
    int result = 1;
    result = prime * result + id.hashCode;
    result = prime * result + measurementId.hashCode;
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

  @override
  bool operator ==(other) =>
    other is RawMeasurementData &&
      other.id == this.id &&
      other.measurementId == this.measurementId &&
      other.timestamp == this.timestamp &&
      other.accuracy == this.accuracy &&
      other.accelerometerX == this.accelerometerX &&
      other.accelerometerY == this.accelerometerY &&
      other.accelerometerZ == this.accelerometerZ &&
      other.gyroscopeX == this.gyroscopeX &&
      other.gyroscopeY == this.gyroscopeY &&
      other.gyroscopeZ == this.gyroscopeZ;

}