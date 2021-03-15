
import 'package:floor/floor.dart';
import 'package:balance/model/raw_measurement_data.dart';

@dao
abstract class RawMeasurementDataDao {
  /// Insert a new list of [RawMeasurementData] into the database
  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<List<int>> insertRawMeasurements(List<RawMeasurementData> measData);

  /// Return all [RawMeasurementData] for a given [measurementId]
  @Query("SELECT * FROM raw_measurements_data WHERE measurement_id = :measurementId")
  Future<List<RawMeasurementData>> findAllRawMeasDataForId(int measurementId);

  /// Return all [RawMeasurementData] in database
  @Query("SELECT * FROM raw_measurements_data")
  Future<List<RawMeasurementData>> getAllData();
}