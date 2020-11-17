
<<<<<<< HEAD
=======
import 'dart:convert';

>>>>>>> dev
import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/floor/test_database_view.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/model/measurement.dart';
import 'package:balance_app/model/raw_measurement_data.dart';
import 'package:balance_app/model/sensor_data.dart';
<<<<<<< HEAD
=======
import 'package:http/http.dart';
>>>>>>> dev

class MeasureCountdownRepository {
  final MeasurementDatabase database;

  MeasureCountdownRepository(this.database);

  /// Creates a new [Measurement] with his own [RawMeasurementData]
  Future<Test> createNewMeasurement(List<SensorData> rawSensorData, bool eyesOpen) async {
    final measurementDao = database.measurementDao;
    final rawMeasDataDao = database.rawMeasurementDataDao;

    try {
      // Add a new Measurement
      final newMeasId = await measurementDao.insertMeasurement(
        Measurement.simple(
          creationDate: DateTime.now().millisecondsSinceEpoch,
          eyesOpen: eyesOpen,
        ),
      );

      // Store the SensorData in database as RawMeasurementData
      await rawMeasDataDao.insertRawMeasurements(
        await _generateRawData(rawSensorData, newMeasId).toList()
      );

<<<<<<< HEAD
=======
      // send data to server
      _makePostRequest(await _generateRawData(rawSensorData, newMeasId).toList());

>>>>>>> dev
      // return the newly added Test
      return await measurementDao.findTestById(newMeasId);
    } catch(e) {
      print("MeasureCountdownRepository.createNewMeasurement: Error $e");
      return Future.error(e);
    }
  }

<<<<<<< HEAD
=======
  _makePostRequest(var data) async {
    // TODO: This stuff here is hardcode. Need changes
    // set up POST request arguments
    String url = 'http://80.211.137.75/api/v1/db/sway';
    //String url = 'http://192.168.1.206/api/v1/db/sway';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(data);

    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // response
    int statusCode = response.statusCode;
    String body = response.body;
    print("RawMeasurement Sent to the Backend");
  }

>>>>>>> dev
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