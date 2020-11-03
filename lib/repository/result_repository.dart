
import 'dart:convert';
import 'dart:io';

import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/model/measurement.dart';
import 'package:balance_app/model/statokinesigram.dart';
import 'package:balance_app/posture_processor/posture_processor.dart';
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
    // 2. Check if the features and the cogv data are present and compute them if not
    if (!measurement.hasFeatures && cogv.isEmpty) {
      print("ResultRepository.getResult: Computing Features...");
      final rawMeasurementData = await database.rawMeasurementDataDao
        .findAllRawMeasDataForId(measurementId);

      // Compute the statokinesigram
      final computed = await PostureProcessor.computeFromData(measurementId, rawMeasurementData);

      // Update the measurement with the computed features
      database.measurementDao.updateMeasurement(Measurement.from(measurement, computed));
      // Store the computed CogvData
      database.cogvDataDao.insertCogvData(computed.cogv);
      return computed;
    }
    // 3. Return a Statokinesigram with the features
    return Statokinesigram.from(measurement, cogv);
  }

  /// Save all the measurement in a .json file
  ///
  /// This method will export all the data related to
  /// the given measurement in a json file.
  /// If the device is android the file will be stored in:
  ///   /Android/data/it.uniurb.balance_app/files/Documents/
  /// If the device is IOS the file will be stored in app documents
  /// Otherwise it will throw an exception.
  Future<void> exportMeasurement(int measurementId) async {
    if (measurementId == null)
      throw Exception("Measurement id must not be null!");

    File file;
    // Create the file based on the platform
    if (Platform.isAndroid) {
      final baseDirectory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      file = File('${baseDirectory[0].path}/test$measurementId.json');
    } else if (Platform.isIOS) {
      final baseDirectory = await getApplicationDocumentsDirectory();
      file = File('$baseDirectory/test$measurementId.json');
    } else
      throw Exception("This Platform [${Platform.operatingSystem}] is not supported!");

    print("Export test in: ${file.path}");

    final meas = await database.measurementDao.findMeasurementById(measurementId);
    final rawData = await database.rawMeasurementDataDao.findAllRawMeasDataForId(measurementId);
    final cogvData = await database.cogvDataDao.findAllCogvDataForId(measurementId);

    await file.writeAsString(
      jsonEncode({
        "measurement": meas?.toJson(),
        "cogv": cogvData?.map((e) => e.toJson())?.toList(),
        "rawMeasurement": rawData?.map((e) => e.toJson())?.toList(),
      })
    );
  }
}