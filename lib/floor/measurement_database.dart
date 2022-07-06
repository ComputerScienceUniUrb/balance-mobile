
import 'dart:async';
import 'package:balance/dao/wom_dao.dart';
import 'package:balance/model/wom_voucher.dart';
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
  version: 2,
  entities: [
    Measurement,
    RawMeasurementData,
    CogvData,
    WomVoucher,
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
  /// Getter for the [WomDao]
  WomDao get womDao;

  /// Singleton pattern to instantiate the database
  static MeasurementDatabase _dbInstance;

  /// Migration
  static final migration1to2 = Migration(1, 2, (database) async {
    await database.execute('ALTER TABLE measurements ADD COLUMN note TEXT');
    await database.execute('ALTER TABLE measurements ADD COLUMN initCondition INTEGER');
    await database.execute('DROP VIEW IF EXISTS [tests]');
    await database.execute('CREATE VIEW [tests] AS SELECT id, creation_date, eyes_open, invalid, sent, note, initCondition FROM measurements');
    await database.execute('CREATE TABLE IF NOT EXISTS `wom_vouchers` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `token` TEXT NOT NULL, `test` INTEGER NOT NULL, `otc` TEXT, `password` TEXT)');
  });

  static Future<MeasurementDatabase> getDatabase() async {
    if (_dbInstance == null)
      _dbInstance = await $FloorMeasurementDatabase
        .databaseBuilder("measurement_database.db")
        .addMigrations([migration1to2])
        .build();
    return _dbInstance;
  }
}