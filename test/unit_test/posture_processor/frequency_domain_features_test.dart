
import 'dart:math';

import 'package:balance/posture_processor/src/frequency_domain_features.dart';
import 'package:balance/posture_processor/src/math/matrix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:powerdart/powerdart.dart';

import '../../utils/resource_loader.dart';

void main() {
  test("compute PSD with real data", () async {
    Matrix testData = loadMatrixFromResource("cogv/dropped_data.txt").transpose();

    expect(testData, isNotNull);
    List<List<double>> rows = testData.extractRows();
    Map<String, double> freqFeat = await frequencyDomainFeatures(rows[0], rows[1]);

    print(freqFeat);
  });

  test("compute PSD of sinewave", () async{
    // Generate the sine-wave
    final t = linspace(0, 1, num: 100, endpoint: false);
    final x = t.map((e) => cos(2*pi*40*e)).toList();

    final res = await frequencyDomainFeatures(x, x, 100);

    expect(res["meanFrequencyAP"], within(distance: 0.83, from: 39.978));
    expect(res["frequencyPeakAP"], within(distance: 0.8, from: 40.0));
    expect(res["f80AP"], within(distance: 1.79, from: 41.0));

    expect(res["meanFrequencyAP"], equals(res["meanFrequencyML"]));
    expect(res["frequencyPeakAP"], equals(res["frequencyPeakML"]));
    expect(res["f80AP"], equals(res["f80ML"]));
  });

  test("compute PSD of multiple sinewaves", () async{
    // Generate the sine-wave
    final t = linspace(0, 1, num: 200, endpoint: false);
    final x = t.map((e) => cos(2*pi*40*e) + cos(2*pi*86*e)).toList();

    final res = await frequencyDomainFeatures(x, x, 100);

    expect(res["meanFrequencyAP"], within(distance: 0.1, from: 31.142));
    expect(res["frequencyPeakAP"], within(distance: 0.2, from: 20.0));
    expect(res["f80AP"], within(distance: 1.0, from: 43.5));

    expect(res["meanFrequencyAP"], equals(res["meanFrequencyML"]));
    expect(res["frequencyPeakAP"], equals(res["frequencyPeakML"]));
    expect(res["f80AP"], equals(res["f80ML"]));
  });

  test("negative fs throws an error", () {
    expect(() => frequencyDomainFeatures([1.0], [1.0], -20), throwsAssertionError);
  });

  test("frequency domain features of null data returns all nan", () async{
    final res = await frequencyDomainFeatures([], [], 50);

    expect(res["meanFrequencyAP"], isNaN);
    expect(res["meanFrequencyML"], isNaN);
    expect(res["frequencyPeakAP"], isNaN);
    expect(res["frequencyPeakML"], isNaN);
    expect(res["f80AP"], isNaN);
    expect(res["f80ML"], isNaN);
  });
}