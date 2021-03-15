
import 'package:balance/model/cogv_data.dart';
import 'package:floor/floor.dart';

@dao
abstract class CogvDataDao {
  /// Insert a new list of [CogvData] into the database
  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<List<int>> insertCogvData(List<CogvData> cogvs);

  /// Return all [CogvData] for a given [measurementId]
  @Query("SELECT * FROM cogv_data WHERE measurement_id = :measurementId")
  Future<List<CogvData>> findAllCogvDataForId(int measurementId);

  /// Return all [CogvData] in the database
  @Query("SELECT * FROM cogv_data")
  Future<List<CogvData>> getAllData();
}