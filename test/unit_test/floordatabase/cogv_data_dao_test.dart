
import 'package:balance_app/dao/cogv_data_dao.dart';
import 'package:balance_app/model/cogv_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';
import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/dao/measurement_dao.dart';
import 'package:balance_app/model/measurement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  group("Database Tests", () {
    MeasurementDatabase database;
    CogvDataDao cogvDataDao;
    MeasurementDao measurementDao;
    List<Measurement> measurements = [
      Measurement(id: 1, creationDate: 1, eyesOpen: false),
      Measurement(id: 2, creationDate: 1, eyesOpen: false),
      Measurement(id: 3, creationDate: 1, eyesOpen: false),
    ];
    List<CogvData> cogvList = [
      CogvData(measurementId: 1, ap: 1.0, ml: 2.0),
      CogvData(measurementId: 1, ap: 1.0, ml: 2.0),
      CogvData(measurementId: 1, ap: 1.0, ml: 2.0),
      CogvData(measurementId: 2, ap: 1.0, ml: 2.0),
      CogvData(measurementId: 2, ap: 1.0, ml: 2.0),
      CogvData(measurementId: 3, ap: 1.0, ml: 2.0),
    ];

    setUp(() async {
      database = await $FloorMeasurementDatabase
        .inMemoryDatabaseBuilder()
        .build();
      measurementDao = database.measurementDao;
      cogvDataDao = database.cogvDataDao;

      // Pre-insert the measurements in the db
      for (var meas in measurements)
        await measurementDao.insertMeasurement(meas);
    });

    tearDown(() async {
      await database.close();
      database = null;
      cogvDataDao = null;
    });

    test("insert new cogv data", () async {
      final newIds = await cogvDataDao.insertCogvData(cogvList);

      // All the items are inserted?
      expect(newIds, hasLength(6));

      final allData = await cogvDataDao.getAllData();
      expect(allData, hasLength(6));
    });

    test("inserting cogv data with null measurementId will fail", () async{
      final wrongData = [
        CogvData(ml: 1, ap: 4),
        CogvData(ml: 2, ap: 5),
        CogvData(ml: 3, ap: 6),
      ];

      cogvDataDao.insertCogvData(wrongData);
      expect(await cogvDataDao.getAllData(), isEmpty);
    });
    
    test("read cogv data for a given measurement", () async{
      await cogvDataDao.insertCogvData(cogvList);

      // Find the all the data related to a measurement
      final firstData = await cogvDataDao.findAllCogvDataForId(1);
      expect(firstData, hasLength(3));
      final secondData = await cogvDataDao.findAllCogvDataForId(2);
      expect(secondData, hasLength(2));
      final thirdData = await cogvDataDao.findAllCogvDataForId(3);
      expect(thirdData, hasLength(1));
    });

    test("read all cogv data", () async {
      await cogvDataDao.insertCogvData(cogvList);

      // Find the all the data
      final allData = await cogvDataDao.getAllData();
      expect(allData, hasLength(6));
    });

    test("ignore duplicate data", () async{
      await cogvDataDao.insertCogvData(cogvList);

      // Insert a duplicate CogvData
      await cogvDataDao.insertCogvData([CogvData(id: 1, measurementId: 3)]);

      // If the insertion is ignored the CogvData will not be present in db
      expect(
        (await cogvDataDao.getAllData())
          .where((element) => element.id == 1 && element.measurementId == 3),
        isEmpty
      );
    });
  });
}