
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/dao/measurement_dao.dart';
import 'package:balance/dao/raw_measurement_data_dao.dart';
import 'package:balance/model/measurement.dart';
import 'package:balance/model/raw_measurement_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  group("Database Tests", () {
    MeasurementDatabase database;
    RawMeasurementDataDao rawMeasurementDataDao;
    MeasurementDao measurementDao;
    List<Measurement> measurements = [
      Measurement(id: 1, creationDate: 1, eyesOpen: false),
      Measurement(id: 2, creationDate: 1, eyesOpen: false),
      Measurement(id: 3, creationDate: 1, eyesOpen: false),
    ];
    List<RawMeasurementData> rawMeasurementsList = [
      RawMeasurementData(measurementId: 1),
      RawMeasurementData(measurementId: 1),
      RawMeasurementData(measurementId: 1),
      RawMeasurementData(measurementId: 2),
      RawMeasurementData(measurementId: 2),
      RawMeasurementData(measurementId: 3),
    ];

    setUp(() async {
      database = await $FloorMeasurementDatabase
        .inMemoryDatabaseBuilder()
        .build();
      measurementDao = database.measurementDao;
      rawMeasurementDataDao = database.rawMeasurementDataDao;

      // Pre-insert the measurements in the db
      for (var meas in measurements)
        await measurementDao.insertMeasurement(meas);
    });

    tearDown(() async {
      await database.close();
      database = null;
      rawMeasurementDataDao = null;
    });

    test("insert new raw measurement data", () async {
      final newIds = await rawMeasurementDataDao
        .insertRawMeasurements(rawMeasurementsList);

      // All the items are inserted?
      expect(newIds, hasLength(6));

      final allData = await rawMeasurementDataDao.getAllData();
      expect(allData, hasLength(6));
    });
    
    test("read data for a given measurement", () async {
      await rawMeasurementDataDao.insertRawMeasurements(rawMeasurementsList);

      // Find the all the data related to a measurement
      final firstData = await rawMeasurementDataDao.findAllRawMeasDataForId(1);
      expect(firstData, hasLength(3));
      final secondData = await rawMeasurementDataDao.findAllRawMeasDataForId(2);
      expect(secondData, hasLength(2));
      final thirdData = await rawMeasurementDataDao.findAllRawMeasDataForId(3);
      expect(thirdData, hasLength(1));
    });

    test("read all raw measurements", () async {
      await rawMeasurementDataDao.insertRawMeasurements(rawMeasurementsList);

      // Find the all the data
      final allData = await rawMeasurementDataDao.getAllData();
      expect(allData, hasLength(6));
    });

    test("ignore duplicate data", () async{
      await rawMeasurementDataDao.insertRawMeasurements(rawMeasurementsList);

      // Insert a duplicate RawMeasurement
      await rawMeasurementDataDao
        .insertRawMeasurements([RawMeasurementData(id: 1, measurementId: 3)]);

      // If the insertion is ignored the RawMeasurement will not be present in db
      expect(
        (await rawMeasurementDataDao.getAllData())
          .where((element) => element.id == 1 && element.measurementId == 3),
        isEmpty
      );
    });
  });
}