
import 'package:balance_app/floor/test_database_view.dart';
import 'package:balance_app/model/measurement.dart';
import 'package:floor/floor.dart';

/// DAO class declaring the database operations for [Measurement]
@dao
abstract class MeasurementDao {
  /// Insert a new [Measurement] into the database
  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertMeasurement(Measurement measurement);

  /// Updates an already existing [Measurement]
  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateMeasurement(Measurement measurement);

  /// Returns a [Future] with a [List] of all the [Measurement]s inside the database
  @Query("SELECT * FROM measurements")
  Future<List<Measurement>> getAllMeasurements();

  /// Returns a specific [Measurement] based on the given [id]
  @Query("SELECT * FROM measurements WHERE id = :id")
  Future<Measurement> findMeasurementById(int id);

  /// Return a [Test] with the given [id]
  @Query("SELECT * FROM tests WHERE id = :id")
  Future<Test> findTestById(int id);

  /// Return all the [Test] inside the database
  @Query("SELECT * FROM tests")
  Future<List<Test>> getAllTests();
}