
import 'package:balance/posture_processor/src/math/matrix.dart';
import 'package:balance/posture_processor/src/sway_density_analysis.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/resource_loader.dart';

void main() {
  Matrix testData;

  setUpAll(() {
    testData = loadMatrixFromResource("cogv/dropped_data.txt").transpose();
  });

  test("compute sda", () async{
    expect(testData, isNotNull);
    final rows = testData.extractRows();
    Map param = await swayDensityAnalysis(rows[0], rows[1], 0.02);

    expect(param["numMax"], within(distance: 0.000034, from: 1.5667));

    expect(param["meanDistance"], within(distance: 0.0004, from: 29.107));
    expect(param["stdDistance"], within(distance: 0.0004, from: 12.137));

    expect(param["meanTime"], within(distance: 0.0004, from: 29.106));
    expect(param["stdTime"], within(distance: 0.0004, from: 12.137));

    expect(param["meanPeaks"], within(distance: 6e-7, from: 0.12219));
    expect(param["stdPeaks"], within(distance: 1.1e-7, from: 0.094242));
  });

  test("throws error when passed wrong args", (){
    // Throws an exception when the radius is 0?
    expect(() => swayDensityAnalysis([1.0, 2.0, 3.0], [4.0, 5.0, 6.0], 0.0), throwsAssertionError);

    // Throws an exception when the lists have different size?
    expect(() => swayDensityAnalysis([1.0, 2.0], [3.0, 4.0, 5.0], 0.2), throwsAssertionError);
  });

  test("sda of null data returns all nan", () async{
    final res = await swayDensityAnalysis([], [], 0.5);

    expect(res["numMax"], equals(0.0));
    expect(res["meanDistance"], isNaN);
    expect(res["stdDistance"], isNaN);
    expect(res["meanTime"], isNaN);
    expect(res["stdTime"], isNaN);
    expect(res["meanPeaks"], isNaN);
    expect(res["stdPeaks"], isNaN);
  });
}