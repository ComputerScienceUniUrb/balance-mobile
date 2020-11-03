
import 'package:balance_app/model/raw_measurement_data.dart';
import 'package:balance_app/posture_processor/src/gyroscopic_features.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/resource_loader.dart';

void main() {
  List<RawMeasurementData> rawData;

  setUpAll(() {
    final initialData = loadMatrixFromResource("gyro/test_data.txt");
    rawData = List.generate(initialData.rows, (i) =>
      RawMeasurementData(
        gyroscopeX: initialData.get(i, 0),
        gyroscopeY: initialData.get(i, 1),
        gyroscopeZ: initialData.get(i, 2),
      )
    );
  });

  test("compute gyroscopic features from data", () async{
    final res = await gyroscopicFeatures(rawData);

    // Check the range
    expect(res["grX"], within(distance: 0.00001, from: 0.10996));
    expect(res["grY"], within(distance: 0.00001, from: 0.15272));
    expect(res["grZ"], within(distance: 0.00001, from: 0.10263));

    // Check the max
    expect(res["gmX"], within(distance: 0.000001, from: 0.077695));
    expect(res["gmY"], within(distance: 0.000001, from: 0.061033));
    expect(res["gmZ"], within(distance: 0.000001, from: 0.046029));

    // Check the variance
    expect(res["gvX"], within(distance: 0.000000001, from: 0.000089872));
    expect(res["gvY"], within(distance: 0.00000001, from: 0.00021093));
    expect(res["gvZ"], within(distance: 0.000000001, from: 0.000040878));

    // Check the kurtosis
    expect(res["gkX"], within(distance: 0.000038, from: 7.5721));
    expect(res["gkY"], within(distance: 0.000033, from: 6.8486));
    expect(res["gkZ"], within(distance: 0.00036, from: 12.119));

    // Check the skewness
    expect(res["gsX"], within(distance: 0.000004, from: 0.55429));
    expect(res["gsY"], within(distance: 0.000000304, from: -0.082814));
    expect(res["gsZ"], within(distance: 0.000000898, from: -0.53068));
  });

  test("compute null data", () async {
    final data = [
      RawMeasurementData(),
      RawMeasurementData(),
      RawMeasurementData(),
    ];
    final res = await gyroscopicFeatures(data);

    expect(res["grX"], isNaN);
    expect(res["grY"], isNaN);
    expect(res["grZ"], isNaN);
    expect(res["gmX"], isNaN);
    expect(res["gmY"], isNaN);
    expect(res["gmZ"], isNaN);
    expect(res["gvX"], isNaN);
    expect(res["gvY"], isNaN);
    expect(res["gvZ"], isNaN);
    expect(res["gsX"], isNaN);
    expect(res["gsY"], isNaN);
    expect(res["gsZ"], isNaN);
    expect(res["gkX"], isNaN);
    expect(res["gkY"], isNaN);
    expect(res["gkZ"], isNaN);
  });
}