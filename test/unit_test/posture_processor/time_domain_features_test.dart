
import 'package:balance_app/posture_processor/src/math/matrix.dart';
import 'package:balance_app/posture_processor/src/time_domain_features.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/resource_loader.dart';

void main() {
  Matrix testData;

  setUpAll(() {
    testData = loadMatrixFromResource("cogv/dropped_data.txt").transpose();
  });

  tearDownAll(() {
    testData = null;
  });

  test("time domain features computation", () async{
    expect(testData, isNotNull);
    List<List<double>> rows = testData.extractRows();
    Map<String, double> timeFeat = await timeDomainFeatures(rows[0], rows[1]);

    expect(timeFeat["swayPath"], within(distance: 3e-7, from: 0.74081));
    expect(timeFeat["meanDisplacement"], within(distance: 0.0004, from: 0.70124));
    expect(timeFeat["stdDisplacement"], within(distance: 0.000016, from: 0.41026));

    expect(timeFeat["minDist"], within(distance: 0.000005, from: 0.050359));
    expect(timeFeat["maxDist"], within(distance: 3e-6, from: 2.596297));
    expect(timeFeat["minDist"], lessThan(timeFeat["maxDist"]));
  });

  test("ml and ap with different sizes throws an error", () {
    expect(() => timeDomainFeatures([1.0], [1.0, 2.0]), throwsAssertionError);
  });

  test("time domain features of null data returns all nan", () async{
    final res = await timeDomainFeatures([], []);

    expect(res["swayPath"], isNaN);
    expect(res["meanDisplacement"], isNaN);
    expect(res["stdDisplacement"], isNaN);
    expect(res["minDist"], isNaN);
    expect(res["maxDist"], isNaN);
  });
}