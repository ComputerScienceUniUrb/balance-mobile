
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:balance/dao/measurement_dao.dart';
import 'package:balance/dao/raw_measurement_data_dao.dart';
import 'package:balance/dao/cogv_data_dao.dart';

import 'package:balance/model/measurement.dart';
import 'package:balance/model/raw_measurement_data.dart';
import 'package:balance/model/cogv_data.dart';

import 'package:balance/floor/test_database_view.dart';

part 'measurement_database.g.dart';

/// Measurement Floor Database implementation
@Database(
  version: 1,
  entities: [
    Measurement,
    RawMeasurementData,
    CogvData,
  ],
  views: [
    Test
  ]
)
abstract class MeasurementDatabase extends FloorDatabase {
  /// Getter for the [MeasurementDao]
  MeasurementDao get measurementDao;
  /// Getter for the [RawMeasurementDataDao]
  RawMeasurementDataDao get rawMeasurementDataDao;
  /// Getter for the [CogvDataDao]
  CogvDataDao get cogvDataDao;

  /// Singleton pattern to instantiate the database
  static MeasurementDatabase _dbInstance;
  static Future<MeasurementDatabase> getDatabase() async {
    if (_dbInstance == null)
      _dbInstance = await $FloorMeasurementDatabase
        .databaseBuilder("measurement_database.db")
        .build();
    return _dbInstance;
  }
}