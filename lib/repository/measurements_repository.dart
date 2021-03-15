
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/floor/test_database_view.dart';
import 'package:balance/model/measurement.dart';

/// Repository class for retrieving all the old measurements
///
/// This class implements a Repository in the Design Pattern Bloc
/// and has the purpose of returning all the [Measurement] objects
/// wherever they are needed
class MeasurementsRepository {
  final MeasurementDatabase database;

  MeasurementsRepository(this.database);

  /// Return all the old measurements
  Future<List<Test>> getMeasurements() {
    return database.measurementDao.getAllTests();
  }
}