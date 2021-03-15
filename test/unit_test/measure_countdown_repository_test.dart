
import 'dart:math';

import 'package:balance/floor/measurement_database.dart';
import 'package:balance/repository/measure_countdown_repository.dart';
import 'package:balance/model/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  MeasurementDatabase database;
  MeasureCountdownRepository repository;

  setUp(() async {
    database = await $FloorMeasurementDatabase
      .inMemoryDatabaseBuilder()
      .build();
    repository = MeasureCountdownRepository(database);
  });

  tearDown(() async {
    await database.close();
    database = null;
    repository = null;
  });

  test("create new measurement add the correct data to database", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final rnd = Random();
    final data = List.generate(5, (_) =>
      SensorData(
        rnd.nextInt(1000),
        rnd.nextInt(5),
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextDouble()
      ));

    final result = await repository.createNewMeasurement(data, true);

    expect(result.id, equals(1));
    expect(result.eyesOpen, isTrue);
    expect(result.creationDate, isNotNull);

    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored raw data is the same as the input?
    expect(rawData, isNotEmpty);
    for (var i = 0; i < rawData.length; i++) {
      expect(rawData[i].accelerometerX, equals(data[i].accelerometerX));
      expect(rawData[i].accelerometerY, equals(data[i].accelerometerY));
      expect(rawData[i].accelerometerZ, equals(data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX, equals(data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY, equals(data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ, equals(data[i].gyroscopeZ));
    }
  });

  test("create new measurement with default bias", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final data = [
      SensorData(
        1,
        2,
        0.9,
        9.9,
        -0.7,
        0.009,
        -0.01,
        0.01
      ),
      SensorData(
        1,
        2,
        -0.9,
        9.6,
        -0.6,
        0.02,
        -0.03,
        -0.006
      ),
      SensorData(
        1,
        2,
        -0.9,
        8.9,
        -0.6,
        0.03,
        -0.03,
        0.02
      ),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored data has the default bias applied so it's the same as the input
    for (var i = 0; i < rawData.length; i++) {
      expect(rawData[i].accelerometerX, within(distance: 0.1, from: data[i].accelerometerX));
      expect(rawData[i].accelerometerY, within(distance: 0.1, from: data[i].accelerometerY));
      expect(rawData[i].accelerometerZ, within(distance: 0.1, from: data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX, within(distance: 0.1, from: data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY, within(distance: 0.1, from: data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ, within(distance: 0.1, from: data[i].gyroscopeZ));
    }
  });

  test("create new measurement with default bias", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final data = [
      SensorData(
        1,
        2,
        0.9,
        9.9,
        -0.7,
        0.009,
        -0.01,
        0.01
      ),
      SensorData(
        1,
        2,
        -0.9,
        9.6,
        -0.6,
        0.02,
        -0.03,
        -0.006
      ),
      SensorData(
        1,
        2,
        -0.9,
        8.9,
        -0.6,
        0.03,
        -0.03,
        0.02
      ),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored data has the default bias applied so it's the same as the input
    for (var i = 0; i < rawData.length; i++) {
      expect(rawData[i].accelerometerX, within(distance: 0.1, from: data[i].accelerometerX));
      expect(rawData[i].accelerometerY, within(distance: 0.1, from: data[i].accelerometerY));
      expect(rawData[i].accelerometerZ, within(distance: 0.1, from: data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX, within(distance: 0.1, from: data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY, within(distance: 0.1, from: data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ, within(distance: 0.1, from: data[i].gyroscopeZ));
    }
  });

  test("create new measurement with null bias", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": null,
      "flutter.AccelerometerBiasY": null,
      "flutter.AccelerometerBiasZ": null,
      "flutter.GyroscopeBiasX": null,
      "flutter.GyroscopeBiasY": null,
      "flutter.GyroscopeBiasZ": null,
    });

    final data = [
      SensorData(
        1,
        2,
        0.9792106747627258,
        9.956722259521484,
        -0.7531822323799133,
        0.009277671575546265,
        -0.01471409481018782,
        0.01182072889059782
      ),
      SensorData(
        1,
        2,
        -0.9839503169059753,
        9.690977096557617,
        -0.6310831904411316,
        0.02882534265518188,
        -0.03181831166148186,
        -0.006505212746560574
      ),
      SensorData(
        1,
        2,
        -0.926491916179657,
        8.996687889099121,
        -0.6478418707847595,
        0.03126880154013634,
        -0.03304003551602364,
        0.02525975182652473
      ),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored data has no bias applied so it's the same as the input
    for (var i = 0; i < rawData.length; i++) {
      expect(rawData[i].accelerometerX, equals(data[i].accelerometerX));
      expect(rawData[i].accelerometerY, equals(data[i].accelerometerY));
      expect(rawData[i].accelerometerZ, equals(data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX, equals(data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY, equals(data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ, equals(data[i].gyroscopeZ));
    }
  });

  test("create new measurement with some null accelerometer data", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final data = [
      SensorData(
        1,
        2,
        0.9792106747627258,
        9.956722259521484,
        -0.7531822323799133,
        0.009277671575546265,
        -0.01471409481018782,
        0.01182072889059782
      ),
      SensorData(
        1,
        2,
        null,
        0.1,
        null,
        0.02882534265518188,
        -0.03181831166148186,
        -0.006505212746560574
      ),
      SensorData(
        1,
        2,
        -0.926491916179657,
        8.996687889099121,
        -0.6478418707847595,
        0.03126880154013634,
        -0.03304003551602364,
        0.02525975182652473
      ),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored data has no bias applied so it's the same as the input
    expect(rawData[0].accelerometerX, equals(data[0].accelerometerX));
    expect(rawData[0].accelerometerY, equals(data[0].accelerometerY));
    expect(rawData[0].accelerometerZ, equals(data[0].accelerometerZ));
    expect(rawData[0].gyroscopeX, equals(data[0].gyroscopeX));
    expect(rawData[0].gyroscopeY, equals(data[0].gyroscopeY));
    expect(rawData[0].gyroscopeZ, equals(data[0].gyroscopeZ));

    expect(rawData[1].accelerometerX, isNull);
    expect(rawData[1].accelerometerY, isNull);
    expect(rawData[1].accelerometerZ, isNull);
    expect(rawData[1].gyroscopeX, equals(data[1].gyroscopeX));
    expect(rawData[1].gyroscopeY, equals(data[1].gyroscopeY));
    expect(rawData[1].gyroscopeZ, equals(data[1].gyroscopeZ));

    expect(rawData[2].accelerometerX, equals(data[2].accelerometerX));
    expect(rawData[2].accelerometerY, equals(data[2].accelerometerY));
    expect(rawData[2].accelerometerZ, equals(data[2].accelerometerZ));
    expect(rawData[2].gyroscopeX, equals(data[2].gyroscopeX));
    expect(rawData[2].gyroscopeY, equals(data[2].gyroscopeY));
    expect(rawData[2].gyroscopeZ, equals(data[2].gyroscopeZ));
  });

  test("create new measurement with some null gyroscope data", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final data = [
      SensorData(
        1,
        2,
        0.9792106747627258,
        9.956722259521484,
        -0.7531822323799133,
        0.009277671575546265,
        -0.01471409481018782,
        0.01182072889059782
      ),
      SensorData(
        1,
        2,
        -0.9839503169059753,
        9.690977096557617,
        -0.6310831904411316,
        null,
        -0.03181831166148186,
        null
      ),
      SensorData(
        1,
        2,
        -0.926491916179657,
        8.996687889099121,
        -0.6478418707847595,
        0.03126880154013634,
        -0.03304003551602364,
        0.02525975182652473
      ),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // The stored data has no bias applied so it's the same as the input
    expect(rawData[0].accelerometerX, equals(data[0].accelerometerX));
    expect(rawData[0].accelerometerY, equals(data[0].accelerometerY));
    expect(rawData[0].accelerometerZ, equals(data[0].accelerometerZ));
    expect(rawData[0].gyroscopeX, equals(data[0].gyroscopeX));
    expect(rawData[0].gyroscopeY, equals(data[0].gyroscopeY));
    expect(rawData[0].gyroscopeZ, equals(data[0].gyroscopeZ));

    expect(rawData[1].accelerometerX, equals(data[1].accelerometerX));
    expect(rawData[1].accelerometerY, equals(data[1].accelerometerY));
    expect(rawData[1].accelerometerZ, equals(data[1].accelerometerZ));
    expect(rawData[1].gyroscopeX, isNull);
    expect(rawData[1].gyroscopeY, isNull);
    expect(rawData[1].gyroscopeZ, isNull);

    expect(rawData[2].accelerometerX, equals(data[2].accelerometerX));
    expect(rawData[2].accelerometerY, equals(data[2].accelerometerY));
    expect(rawData[2].accelerometerZ, equals(data[2].accelerometerZ));
    expect(rawData[2].gyroscopeX, equals(data[2].gyroscopeX));
    expect(rawData[2].gyroscopeY, equals(data[2].gyroscopeY));
    expect(rawData[2].gyroscopeZ, equals(data[2].gyroscopeZ));
  });

  test("create new measurement with non default accelerometer bias", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 2.0,
      "flutter.AccelerometerBiasY": -2.0,
      "flutter.AccelerometerBiasZ": 0.194,
      "flutter.GyroscopeBiasX": 0.0,
      "flutter.GyroscopeBiasY": 0.0,
      "flutter.GyroscopeBiasZ": 0.0,
    });

    final data = [
      SensorData(
        1,
        2,
        3.0,
        -3.0,
        11.0,
        0.1,
        0.1,
        0.1),
      SensorData(
        1,
        2,
        0.5,
        -0.5,
        9.9,
        0.1,
        0.1,
        0.1),
      SensorData(
        1,
        2,
        -3.0,
        3,
        8.0,
        0.1,
        0.1,
        0.1),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // Expect the correct values for accelerometer
    expect(rawData[0].accelerometerX, within(distance: 0.01, from: 1.0));
    expect(rawData[0].accelerometerY, within(distance: 0.01, from: -1.0));
    expect(rawData[0].accelerometerZ, within(distance: 0.01, from: 10.8));

    expect(rawData[1].accelerometerX, within(distance: 0.01, from: -1.5));
    expect(rawData[1].accelerometerY, within(distance: 0.01, from: 1.5));
    expect(rawData[1].accelerometerZ, within(distance: 0.01, from: 9.7));

    expect(rawData[2].accelerometerX, within(distance: 0.01, from: -5.0));
    expect(rawData[2].accelerometerY, within(distance: 0.01, from: 5.0));
    expect(rawData[2].accelerometerZ, within(distance: 0.01, from: 7.8));

    // The biases are applied correctly
    for (int i = 0; i < rawData.length; i++) {
      expect(
        rawData[i].accelerometerX + 2.0, within(distance: 0.01, from: data[i].accelerometerX));
      expect(
        rawData[i].accelerometerY - 2.0, within(distance: 0.01, from: data[i].accelerometerY));
      expect(
        rawData[i].accelerometerZ + 0.194, within(distance: 0.01, from: data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX, equals(data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY, equals(data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ, equals(data[i].gyroscopeZ));
    }
  });

  test("create new measurement with non default gyroscope bias", () async {
    SharedPreferences.setMockInitialValues({
      "flutter.AccelerometerBiasX": 0.0,
      "flutter.AccelerometerBiasY": 0.0,
      "flutter.AccelerometerBiasZ": 0.0,
      "flutter.GyroscopeBiasX": 2.0,
      "flutter.GyroscopeBiasY": -2.0,
      "flutter.GyroscopeBiasZ": 0.5,
    });

    final data = [
      SensorData(
        1,
        2,
        0.1,
        0.1,
        0.1,
        3.0,
        -3.0,
        2.0),
      SensorData(
        1,
        2,
        0.1,
        0.1,
        0.1,
        0.5,
        -0.5,
        0.2),
      SensorData(
        1,
        2,
        0.1,
        0.1,
        0.1,
        -3.0,
        3.0,
        -2.0),
    ];

    await repository.createNewMeasurement(data, true);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(1);

    // Expect the correct values for accelerometer
    expect(rawData[0].gyroscopeX, within(distance: 0.01, from: 1.0));
    expect(rawData[0].gyroscopeY, within(distance: 0.01, from: -1.0));
    expect(rawData[0].gyroscopeZ, within(distance: 0.01, from: 1.5));

    expect(rawData[1].gyroscopeX, within(distance: 0.01, from: -1.5));
    expect(rawData[1].gyroscopeY, within(distance: 0.01, from: 1.5));
    expect(rawData[1].gyroscopeZ, within(distance: 0.01, from: -0.3));

    expect(rawData[2].gyroscopeX, within(distance: 0.01, from: -5.0));
    expect(rawData[2].gyroscopeY, within(distance: 0.01, from: 5.0));
    expect(rawData[2].gyroscopeZ, within(distance: 0.01, from: -2.5));

    // The biases are applied correctly
    for (int i = 0; i < rawData.length; i++) {
      expect(rawData[i].accelerometerX, equals(data[i].accelerometerX));
      expect(rawData[i].accelerometerY, equals(data[i].accelerometerY));
      expect(rawData[i].accelerometerZ, equals(data[i].accelerometerZ));
      expect(rawData[i].gyroscopeX + 2.0, within(distance: 0.01, from: data[i].gyroscopeX));
      expect(rawData[i].gyroscopeY - 2.0, within(distance: 0.01, from: data[i].gyroscopeY));
      expect(rawData[i].gyroscopeZ + 0.5, within(distance: 0.01, from: data[i].gyroscopeZ));
    }
  });
}