
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:balance/floor/measurement_database.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/model/measurement.dart';
import 'package:balance/model/raw_measurement_data.dart';
import 'package:balance/model/statokinesigram.dart';
import 'package:balance/posture_processor/posture_processor.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

/// Repository of the result screen
class ResultRepository {
  final MeasurementDatabase database;

  ResultRepository(this.database);

  /// Return a [Statokinesigram] from the stored data
  ///
  /// If the stored [Measurement] doesn't have any features
  /// we compute them using [PostureProcessor], store them
  /// and return those.
  Future<Statokinesigram> getResult(int measurementId) async {
    assert (measurementId != null, "measurementId must be non null");

    // 1. Get the Measurement with the given id
    final measurement = await database.measurementDao.findMeasurementById(measurementId);
    final cogv = await database.cogvDataDao.findAllCogvDataForId(measurementId);
    final token = (await PreferenceManager.userInfo).token;
    final condition = await PreferenceManager.initialCondition;
    // 2. Check if the features and the cogv data are present and compute them if not
    if (!measurement.hasFeatures && cogv.isEmpty) {
      print("ResultRepository.getResult: Computing Features...");
      final rawMeasurementData = await database.rawMeasurementDataDao
        .findAllRawMeasDataForId(measurementId);

      // Compute the statokinesigram
      final computed = await PostureProcessor.computeFromData(measurementId, rawMeasurementData);

      // Update the measurement with the computed features
      var created_measurement = Measurement.from(measurement, token, condition, computed, true);
      print(jsonEncode(created_measurement));
      bool result = await _makePostRequest(created_measurement);
      if (result)
        database.measurementDao.updateMeasurement(created_measurement);
      else {
        database.measurementDao.updateMeasurement(Measurement.from(measurement, token, condition, computed, false));
        print("_SendingData.Measurement: BAD DELIVERY STATUS for test $measurementId");
      }

      // Store the computed CogvData
      database.cogvDataDao.insertCogvData(computed.cogv);
      return computed;
    }
    // 3. Return a Statokinesigram with the features
    return Statokinesigram.from(measurement, cogv);
  }

  Future<bool> _makePostRequest(var data) async {
    // set up POST request argumentsq
    String url = 'https://www.balancemobile.it/api/v1/db/measurement';
    //String url = 'http://192.168.1.206:8000/api/v1/db/measurement';
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Response response = await post(url, headers: headers, body: jsonEncode(data)).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return true;
      } else {
        print("_SendingData.Measurement: The server answered with: "+response.statusCode.toString());
        return false;
      }
    } on TimeoutException catch (_) {
      print("_SendingData.Measurement: The connection dropped, maybe the server is congested");
      return false;
    } on SocketException catch (_) {
      print("_SendingData.Measurement: Communication failed. The server was not reachable");
      return false;
    }
  }

  /// Save all the measurement in a .json file
  ///
  /// This method will export all the data related to
  /// the given measurement in a json file.
  /// If the device is android the file will be stored in:
  ///   /Android/data/srl.digit.balance/files/Documents/
  /// If the device is IOS the file will be stored in app documents
  /// Otherwise it will throw an exception.
  Future<void> exportMeasurement(int measurementId) async {
    if (measurementId == null)
      throw Exception("Measurement id must not be null!");

    File file1;
    File file2;
    // Create the file based on the platform
    if (Platform.isAndroid) {
      final baseDirectory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      file1 = File('${baseDirectory[0].path}/test${measurementId}_measurements.csv');
      file2 = File('${baseDirectory[0].path}/test${measurementId}_rawmeasurements.csv');
    } else if (Platform.isIOS) {
      final baseDirectory = await getApplicationDocumentsDirectory();
      file1 = File('${baseDirectory.path}/test${measurementId}_measurements.csv');
      file2 = File('${baseDirectory.path}/test${measurementId}_rawmeasurements.csv');
    } else
      throw Exception("This Platform [${Platform.operatingSystem}] is not supported!");

    print("Export test in: ${file1.path}");
    print("Export test in: ${file2.path}");

    final meas = await database.measurementDao.findMeasurementById(measurementId);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(measurementId);

    await file1.writeAsString(meas.toCSV());

    file2.writeAsStringSync('id;measurementId;timestamp;accuracy;accelerometerX;accelerometerY;accelerometerZ;gyroscopeX;gyroscopeY;gyroscopeZ\n');
    for(RawMeasurementData raw in rawData) {
      file2.writeAsStringSync(raw.toCSV(), mode: FileMode.append);
    }
  }
}