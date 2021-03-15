
import 'package:balance/model/raw_measurement_data.dart';
import 'package:balance/posture_processor/posture_processor.dart';
import 'package:balance/posture_processor/src/math/matrix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/resource_loader.dart';

void main() {
  Matrix accInputMatrix;
  Matrix gyroInputMatrix;

  setUpAll(() async {
    accInputMatrix = loadMatrixFromResource("cogv/test_data.txt");
    gyroInputMatrix = loadMatrixFromResource("gyro/test_data.txt");
  });

  tearDownAll(() async {
    accInputMatrix = null;
    gyroInputMatrix = null;
  });


  test("compute from all data", () async {
    expect(accInputMatrix.size, gyroInputMatrix.size);
    expect(accInputMatrix.rows, gyroInputMatrix.rows);

    final inputData = List.generate(accInputMatrix.rows, (i) => RawMeasurementData(
      measurementId: 1,
      timestamp: 123,
      accuracy: 2,
      accelerometerX: accInputMatrix.get(i, 0),
      accelerometerY: accInputMatrix.get(i, 1),
      accelerometerZ: accInputMatrix.get(i, 2),
      gyroscopeX: gyroInputMatrix.get(i, 0),
      gyroscopeY: gyroInputMatrix.get(i, 1),
      gyroscopeZ: gyroInputMatrix.get(i, 2),
    ));

    SharedPreferences.setMockInitialValues({"userHeight": 180.0});
    final statokinesigram = await PostureProcessor.computeFromData(1, inputData);

    expect(statokinesigram, isNotNull);
    expect(statokinesigram.cogv, isNotEmpty);
    expect(statokinesigram.swayPath, isNotNaN);
    expect(statokinesigram.meanDisplacement, isNotNaN);
    expect(statokinesigram.stdDisplacement, isNotNaN);
    expect(statokinesigram.maxDist, isNotNaN);
    expect(statokinesigram.minDist, isNotNaN);
    expect(statokinesigram.frequencyPeakML, isNotNaN);
    expect(statokinesigram.frequencyPeakAP, isNotNaN);
    expect(statokinesigram.meanFrequencyML, isNotNaN);
    expect(statokinesigram.meanFrequencyAP, isNotNaN);
    expect(statokinesigram.f80ML, isNotNaN);
    expect(statokinesigram.f80AP, isNotNaN);
    expect(statokinesigram.numMax, isNotNaN);
    expect(statokinesigram.meanTime, isNotNaN);
    expect(statokinesigram.stdTime, isNotNaN);
    expect(statokinesigram.meanPeaks, isNotNaN);
    expect(statokinesigram.stdPeaks, isNotNaN);
    expect(statokinesigram.meanDistance, isNotNaN);
    expect(statokinesigram.stdDistance, isNotNaN);
    expect(statokinesigram.gmX, isNotNaN);
    expect(statokinesigram.gmY, isNotNaN);
    expect(statokinesigram.gmZ, isNotNaN);
    expect(statokinesigram.grX, isNotNaN);
    expect(statokinesigram.grY, isNotNaN);
    expect(statokinesigram.grZ, isNotNaN);
    expect(statokinesigram.gvX, isNotNaN);
    expect(statokinesigram.gvY, isNotNaN);
    expect(statokinesigram.gvZ, isNotNaN);
    expect(statokinesigram.gkX, isNotNaN);
    expect(statokinesigram.gvY, isNotNaN);
    expect(statokinesigram.gkZ, isNotNaN);
    expect(statokinesigram.gsX, isNotNaN);
    expect(statokinesigram.gsY, isNotNaN);
    expect(statokinesigram.gsZ, isNotNaN);
  });

  test("compute from only accelerometer data", () async {
    final inputData = List.generate(accInputMatrix.rows, (i) => RawMeasurementData(
      measurementId: 1,
      timestamp: 123,
      accuracy: 2,
      accelerometerX: accInputMatrix.get(i, 0),
      accelerometerY: accInputMatrix.get(i, 1),
      accelerometerZ: accInputMatrix.get(i, 2),
      gyroscopeX: null,
      gyroscopeY: null,
      gyroscopeZ: null,
    ));

    SharedPreferences.setMockInitialValues({"userHeight": 180.0});
    final statokinesigram = await PostureProcessor.computeFromData(1, inputData);

    expect(statokinesigram, isNotNull);
    expect(statokinesigram.cogv, isNotEmpty);
    expect(statokinesigram.swayPath, isNotNaN);
    expect(statokinesigram.meanDisplacement, isNotNaN);
    expect(statokinesigram.stdDisplacement, isNotNaN);
    expect(statokinesigram.maxDist, isNotNaN);
    expect(statokinesigram.minDist, isNotNaN);
    expect(statokinesigram.frequencyPeakML, isNotNaN);
    expect(statokinesigram.frequencyPeakAP, isNotNaN);
    expect(statokinesigram.meanFrequencyML, isNotNaN);
    expect(statokinesigram.meanFrequencyAP, isNotNaN);
    expect(statokinesigram.f80ML, isNotNaN);
    expect(statokinesigram.f80AP, isNotNaN);
    expect(statokinesigram.numMax, isNotNaN);
    expect(statokinesigram.meanTime, isNotNaN);
    expect(statokinesigram.stdTime, isNotNaN);
    expect(statokinesigram.meanPeaks, isNotNaN);
    expect(statokinesigram.stdPeaks, isNotNaN);
    expect(statokinesigram.meanDistance, isNotNaN);
    expect(statokinesigram.stdDistance, isNotNaN);
    expect(statokinesigram.gmX, isNaN);
    expect(statokinesigram.gmY, isNaN);
    expect(statokinesigram.gmZ, isNaN);
    expect(statokinesigram.grX, isNaN);
    expect(statokinesigram.grY, isNaN);
    expect(statokinesigram.grZ, isNaN);
    expect(statokinesigram.gvX, isNaN);
    expect(statokinesigram.gvY, isNaN);
    expect(statokinesigram.gvZ, isNaN);
    expect(statokinesigram.gkX, isNaN);
    expect(statokinesigram.gvY, isNaN);
    expect(statokinesigram.gkZ, isNaN);
    expect(statokinesigram.gsX, isNaN);
    expect(statokinesigram.gsY, isNaN);
    expect(statokinesigram.gsZ, isNaN);
  });

  test("compute from only gyroscope data", () async {
    final inputData = List.generate(accInputMatrix.rows, (i) => RawMeasurementData(
      measurementId: 1,
      timestamp: 123,
      accuracy: 2,
      accelerometerX: null,
      accelerometerY: null,
      accelerometerZ: null,
      gyroscopeX: gyroInputMatrix.get(i, 0),
      gyroscopeY: gyroInputMatrix.get(i, 1),
      gyroscopeZ: gyroInputMatrix.get(i, 2),
    ));

    SharedPreferences.setMockInitialValues({"userHeight": 180.0});
    final statokinesigram = await PostureProcessor.computeFromData(1, inputData);

    expect(statokinesigram, isNotNull);
    expect(statokinesigram.cogv, isEmpty);
    expect(statokinesigram.swayPath, isNaN);
    expect(statokinesigram.meanDisplacement, isNaN);
    expect(statokinesigram.stdDisplacement, isNaN);
    expect(statokinesigram.maxDist, isNaN);
    expect(statokinesigram.minDist, isNaN);
    expect(statokinesigram.frequencyPeakML, isNaN);
    expect(statokinesigram.frequencyPeakAP, isNaN);
    expect(statokinesigram.meanFrequencyML, isNaN);
    expect(statokinesigram.meanFrequencyAP, isNaN);
    expect(statokinesigram.f80ML, isNaN);
    expect(statokinesigram.f80AP, isNaN);
    expect(statokinesigram.numMax, isZero);
    expect(statokinesigram.meanTime, isNaN);
    expect(statokinesigram.stdTime, isNaN);
    expect(statokinesigram.meanPeaks, isNaN);
    expect(statokinesigram.stdPeaks, isNaN);
    expect(statokinesigram.meanDistance, isNaN);
    expect(statokinesigram.stdDistance, isNaN);
    expect(statokinesigram.gmX, isNotNaN);
    expect(statokinesigram.gmY, isNotNaN);
    expect(statokinesigram.gmZ, isNotNaN);
    expect(statokinesigram.grX, isNotNaN);
    expect(statokinesigram.grY, isNotNaN);
    expect(statokinesigram.grZ, isNotNaN);
    expect(statokinesigram.gvX, isNotNaN);
    expect(statokinesigram.gvY, isNotNaN);
    expect(statokinesigram.gvZ, isNotNaN);
    expect(statokinesigram.gkX, isNotNaN);
    expect(statokinesigram.gvY, isNotNaN);
    expect(statokinesigram.gkZ, isNotNaN);
    expect(statokinesigram.gsX, isNotNaN);
    expect(statokinesigram.gsY, isNotNaN);
    expect(statokinesigram.gsZ, isNotNaN);
  });

  test("compute from no data", () async {
    final inputData = List.generate(accInputMatrix.rows, (i) => RawMeasurementData(
      measurementId: 1,
      timestamp: 123,
      accuracy: 2,
      accelerometerX: null,
      accelerometerY: null,
      accelerometerZ: null,
      gyroscopeX: null,
      gyroscopeY: null,
      gyroscopeZ: null,
    ));

    SharedPreferences.setMockInitialValues({"userHeight": 180.0});
    final statokinesigram = await PostureProcessor.computeFromData(1, inputData);

    expect(statokinesigram, isNotNull);
    expect(statokinesigram.cogv, isEmpty);
    expect(statokinesigram.swayPath, isNaN);
    expect(statokinesigram.meanDisplacement, isNaN);
    expect(statokinesigram.stdDisplacement, isNaN);
    expect(statokinesigram.maxDist, isNaN);
    expect(statokinesigram.minDist, isNaN);
    expect(statokinesigram.frequencyPeakML, isNaN);
    expect(statokinesigram.frequencyPeakAP, isNaN);
    expect(statokinesigram.meanFrequencyML, isNaN);
    expect(statokinesigram.meanFrequencyAP, isNaN);
    expect(statokinesigram.f80ML, isNaN);
    expect(statokinesigram.f80AP, isNaN);
    expect(statokinesigram.numMax, isZero);
    expect(statokinesigram.meanTime, isNaN);
    expect(statokinesigram.stdTime, isNaN);
    expect(statokinesigram.meanPeaks, isNaN);
    expect(statokinesigram.stdPeaks, isNaN);
    expect(statokinesigram.meanDistance, isNaN);
    expect(statokinesigram.stdDistance, isNaN);
    expect(statokinesigram.gmX, isNaN);
    expect(statokinesigram.gmY, isNaN);
    expect(statokinesigram.gmZ, isNaN);
    expect(statokinesigram.grX, isNaN);
    expect(statokinesigram.grY, isNaN);
    expect(statokinesigram.grZ, isNaN);
    expect(statokinesigram.gvX, isNaN);
    expect(statokinesigram.gvY, isNaN);
    expect(statokinesigram.gvZ, isNaN);
    expect(statokinesigram.gkX, isNaN);
    expect(statokinesigram.gvY, isNaN);
    expect(statokinesigram.gkZ, isNaN);
    expect(statokinesigram.gsX, isNaN);
    expect(statokinesigram.gsY, isNaN);
    expect(statokinesigram.gsZ, isNaN);
  });
}