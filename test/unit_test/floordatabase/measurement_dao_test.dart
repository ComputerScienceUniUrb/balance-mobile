import 'package:balance_app/dao/measurement_dao.dart';
import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/model/measurement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  group("Database Tests", () {
    MeasurementDatabase database;
    MeasurementDao measurementDao;

    setUp(() async {
      database = await $FloorMeasurementDatabase
        .inMemoryDatabaseBuilder()
        .build();
      measurementDao = database.measurementDao;
    });

    tearDown(() async {
      await database.close();
      database = null;
      measurementDao = null;
    });

    test("insert new measurement", () async {
      final newMeas = Measurement(
        id: 1,
        creationDate: DateTime.now().millisecondsSinceEpoch,
        eyesOpen: true
      );
      final int newId = await measurementDao.insertMeasurement(newMeas);

      // The inserted id is the same?
      expect(newId, equals(1));

      // The only item inserted in an empty database is this?
      final allMeas = await measurementDao.getAllMeasurements();
      expect(allMeas, hasLength(1));
      expect(allMeas[0], equals(newMeas));
    });

    test("read one measurement", () async {
      final newMeas = Measurement(
        id: 2,
        creationDate: DateTime.now().millisecondsSinceEpoch,
        eyesOpen: false
      );
      await measurementDao.insertMeasurement(newMeas);

      // Return a specific measurement
      final meas = await measurementDao.findMeasurementById(2);
      expect(meas, equals(newMeas));
    });

    test("read all measurement", () async {
      final allMeas = await measurementDao.getAllMeasurements();
      expect(allMeas, isNotNull);
    });

    test("ignore duplicate data", () async{
      await measurementDao.insertMeasurement(Measurement.simple(
        creationDate: DateTime.now().millisecondsSinceEpoch,
        eyesOpen: true,
      ));

      // Insert a duplicate Measurement
      await measurementDao.insertMeasurement(
        Measurement(
          id: 1,
          creationDate: DateTime.now().millisecondsSinceEpoch,
          eyesOpen: false
        )
      );

      // If the insertion is ignored the Measurement will have eyesOpen true
      expect((await measurementDao.findMeasurementById(1)).eyesOpen, isTrue);
    });

    test("update existing measurement", () async{
      int id = await measurementDao.insertMeasurement(Measurement(
        id: 1,
        creationDate: DateTime.now().millisecondsSinceEpoch,
        eyesOpen: true,
      ));

      final meas = await measurementDao.findMeasurementById(id);
      expect(meas.eyesOpen, isTrue);
      expect(meas.swayPath, isNull);
      expect(meas.f80AP, isNull);

      // Update the measurement
      int updateId = await measurementDao.updateMeasurement(Measurement(
        id: id,
        creationDate: DateTime.now().millisecondsSinceEpoch,
        eyesOpen: false,
        swayPath: 12.0,
        f80AP: 5.0,
      ));
      expect(updateId, equals(id));
      final updateMeas = await measurementDao.findMeasurementById(updateId);
      expect(updateMeas.eyesOpen, isFalse);
      expect(updateMeas.swayPath, isNotNull);
      expect(updateMeas.f80AP, isNotNull);
    });
  });

  group("DatabaseView Tests", () {
    MeasurementDatabase database;
    MeasurementDao measurementDao;
    List<Measurement> prePopulatedData = [
      Measurement(creationDate: 1, eyesOpen: true),
      Measurement(creationDate: 2, eyesOpen: false),
    ];

    setUp(() async{
      database = await $FloorMeasurementDatabase
        .inMemoryDatabaseBuilder()
        .build();
      measurementDao = database.measurementDao;

      for(var m in prePopulatedData)
        await measurementDao.insertMeasurement(m);
    });

    tearDown(() async{
      await database.close();
      database = null;
      measurementDao = null;
    });

    test("find test by id", () async{
      final originalMeas = await measurementDao.findMeasurementById(1);
      final test = await measurementDao.findTestById(1);
      expect(originalMeas.id, equals(test.id));
      expect(originalMeas.creationDate, equals(test.creationDate));
      expect(originalMeas.eyesOpen, equals(test.eyesOpen));

      final originalMeas2 = await measurementDao.findMeasurementById(2);
      final test2 = await measurementDao.findTestById(2);
      expect(originalMeas2.id, equals(test2.id));
      expect(originalMeas2.creationDate, equals(test2.creationDate));
      expect(originalMeas2.eyesOpen, equals(test2.eyesOpen));
    });

    test("get all tests", () async{
      final allTest = await measurementDao.getAllTests();

      expect(allTest, hasLength(2));
      expect(allTest[0].id, equals(1));
      expect(allTest[0].creationDate, equals(prePopulatedData[0].creationDate));
      expect(allTest[0].eyesOpen, equals(prePopulatedData[0].eyesOpen));
      expect(allTest[1].id, equals(2));
      expect(allTest[1].creationDate, equals(prePopulatedData[1].creationDate));
      expect(allTest[1].eyesOpen, equals(prePopulatedData[1].eyesOpen));

    });
  });

  group("Measurement Tests", () {
    test("hasFeatures returns false", () {
      final noFeatMeas = Measurement.simple(
        creationDate: 2,
        eyesOpen: true,
      );
      expect(noFeatMeas.hasFeatures, isFalse);
    });

    test("hasFeatures returns true", () {
      final featMeas = Measurement(
        id: 1,
        creationDate: 2,
        eyesOpen: true,
        hasFeatures: true,
        swayPath: 1.0,
        stdTime: 1.0,
        stdPeaks: 1.0,
        stdDistance: 1.0,
        stdDisplacement: 1.0,
        numMax: 1.0,
        minDist: 1.0,
        meanTime: 1.0,
        meanPeaks: 1.0,
        meanFrequencyML: 1.0,
        meanFrequencyAP: 1.0,
        meanDistance: 1.0,
        meanDisplacement: 1.0,
        maxDist: 1.0,
        gvZ: 1.0,
        gvY: 1.0,
        gvX: 1.0,
        gsZ: 1.0,
        gsY: 1.0,
        gsX: 1.0,
        grZ: 1.0,
        grY: 1.0,
        grX: 1.0,
        gmZ: 1.0,
        gmY: 1.0,
        gmX: 1.0,
        gkZ: 1.0,
        gkY: 1.0,
        gkX: 1.0,
        frequencyPeakML: 1.0,
        frequencyPeakAP: 1.0,
        f80ML: 1.0,
        f80AP: 1.0,
      );
      expect(featMeas.hasFeatures, isTrue);
    });
  });
}