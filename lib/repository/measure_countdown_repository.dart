import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:balance/floor/measurement_database.dart';
import 'package:balance/floor/test_database_view.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/model/measurement.dart';
import 'package:balance/model/raw_measurement_data.dart';
import 'package:balance/model/sensor_data.dart';
import 'package:http/http.dart';


class MeasureCountdownRepository {
  final MeasurementDatabase database;

  MeasureCountdownRepository(this.database);

  /// Creates a new [Measurement] with his own [RawMeasurementData]
  Future<Test> createNewMeasurement(List<SensorData> rawSensorData, bool eyesOpen, int initCondition) async {
    final measurementDao = database.measurementDao;
    final rawMeasDataDao = database.rawMeasurementDataDao;

    try {
      // Add a new Measurement
      final newMeasId = await measurementDao.insertMeasurement(
        Measurement.simple(
          creationDate: DateTime.now().millisecondsSinceEpoch,
          eyesOpen: eyesOpen,
          initCondition: initCondition
        ),
      );

      // Generate data as RawMeasurementData
      var rawData = _generateRawData(rawSensorData, newMeasId).toList();
      // Store the SensorData in database as RawMeasurementData
      await rawMeasDataDao.insertRawMeasurements(await rawData);
      // Send data to server
      _makePostRequest(await rawData);

      // return the newly added Test
      return await measurementDao.findTestById(newMeasId);
    } catch(e) {
      print("MeasureCountdownRepository.createNewMeasurement: Error $e");
      return Future.error(e);
    }
  }

  Future<bool> _makePostRequest(var data) async {
    // set up POST request arguments
    String url = 'https://www.balancemobile.it/api/v1/db/sway';
    //String url = 'https://dev.balancemobile.it/api/v1/db/sway';
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Response response = await post(url, headers: headers, body: jsonEncode(data)).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return true;
      } else {
        print("_SendingData.RawMeasurement: The server answered with: "+response.statusCode.toString());
        return false;
      }
    } on TimeoutException catch (_) {
      print("_SendingData.RawMeasurement: The connection dropped, maybe the server is congested");
      return false;
    } on SocketException catch (_) {
      print("_SendingData.RawMeasurement: Communication failed. The server was not reachable");
      return false;
    }
  }

  /// Asynchronously generate the [RawMeasurementData] from the [SensorData]
  ///
  /// This method will generate one-by-one each [RawMeasurementData] that will be then
  /// stored in the database; this means that the biases are automatically applied to
  /// every item.
  /// [data]: list of [SensorData] to convert
  /// [measId]: the id of the measurement each data belongs to
  Stream<RawMeasurementData> _generateRawData(List<SensorData> data, int measId) async*{
    final accBias = await PreferenceManager.accelerometerBias;
    final gyroBias = await PreferenceManager.gyroscopeBias;
    final token = (await PreferenceManager.userInfo).token;

    for(var sd in data) {
      double aX, aY, aZ, gX, gY, gZ;
      // Compute only non null accelerometers and gyroscopes
      if (sd.accelerometerX != null && sd.accelerometerY != null && sd.accelerometerZ != null) {
        aX = sd.accelerometerX - accBias.x;
        aY = sd.accelerometerY - accBias.y;
        aZ = sd.accelerometerZ - accBias.z;
      }
      if (sd.gyroscopeX != null && sd.gyroscopeY != null && sd.gyroscopeZ != null) {
        gX = sd.gyroscopeX - gyroBias.x;
        gY = sd.gyroscopeY - gyroBias.y;
        gZ = sd.gyroscopeZ - gyroBias.z;
      }
      yield RawMeasurementData(
        measurementId: measId,
        token: token,
        timestamp: sd.timestamp,
        accuracy: sd.accuracy,
        accelerometerX: aX,
        accelerometerY: aY,
        accelerometerZ: aZ,
        gyroscopeX: gX,
        gyroscopeY: gY,
        gyroscopeZ: gZ,
      );
    }
  }
}