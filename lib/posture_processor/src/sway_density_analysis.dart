
import 'dart:math' as math;

import 'package:iirjdart/butterworth.dart';
import 'package:balance/posture_processor/src/list_extension.dart';

/// Sway Density Analysis
///
/// This function compute the sway density analysis for the given pairs of
/// ap and ml values.
/// First it computes the sway density curve (SDC), defined
/// as the time-dependent curve that counts, for each time instant, the number
/// of consecutive samples of the statokinesigram that fall inside a circle of
/// [radius] radius; the sample count is divided by the sampling rate yielding a
/// time-vs-time curve, then this curve is filtered with a fourth-order Butterworth
/// low-pass filter with a cutoff frequency of 2.5Hz.
/// Once computed the SDC the time instants where the curve reaches a peak are extracted
/// and the indicators are computed.
/// Those indicators are:
/// - NP mean number of SDC peaks per second (unit)
/// - MT mean time interval between successive peaks (seconds)
/// - ST standard deviation of MT (seconds)
/// - MP mean value of peaks (seconds)
/// - SP standard deviation of MP (seconds)
/// - MD mean distance between successive peaks (millimeters)
/// - SD standard deviation of MD (millimeters)
Future<Map<String, double>> swayDensityAnalysis(List<double> ap, List<double> ml, double radius) {
  assert(ml.length == ap.length, "ml and ap lists must have same size!");
  assert(radius > 0.0, "radius must be gather than zero!");

  /*
   * For each point create a circle center in that point
   * with the given radius and count how many other points
   * are inside the circle
   */
  List<int> sampleCount = List(ml.length);
  for(var j= 0; j < ml.length; j++) {
    int dotsInsideCircle = 0;
    for(var i= 0; i < ml.length; i++) {
      if (math.pow(ml[i] - ml[j], 2) + math.pow(ap[i] - ap[j], 2) <= math.pow(radius, 2))
        dotsInsideCircle++;
    }
    sampleCount[j] = dotsInsideCircle;
  }

  // Divide sample count by the sampling rate
  final sdc = sampleCount.map((e) => e / 50.0);

  // Filter the samples with a 4° order Butterworth low-pass filter with a cutoff frequency of 2.5Hz
  final filter = Butterworth();
  filter.lowPass(4, 50.0, 2.5);
  final filteredSDC = sdc.map((e) => filter.filter(e)).toList();

  /*
   * Find all peaks larger than the threshold
   * NOTE: Changing the threshold will change the numbers of peaks
   */
  final threshold = 0.00001;
  List<int> peaksArr = [];
  for (var i = 1; i < filteredSDC.length - 1; i++) {
    if (filteredSDC[i] - filteredSDC[i - 1] >= threshold &&
      filteredSDC[i] - filteredSDC[i + 1] >= threshold)
      peaksArr.add(i);
  }

  // Compute the nummax feature
  double numMax = peaksArr.length / 30.0;

  // Compute the indicators for every peak
  final timeIntervals = List<double>.filled(peaksArr.length, 0.0);
  final valueOfPeaks = List<double>.filled(peaksArr.length, 0.0);
  final distances = List<double>.filled(peaksArr.length, 0.0);
  for (var i = 0; i < peaksArr.length - 1; i++) {
    timeIntervals[i] = (peaksArr[i + 1] - peaksArr[i]) / 50.0;
    valueOfPeaks[i] = filteredSDC[peaksArr[i]];
    distances[i] = math.sqrt(math.pow(ml[peaksArr[i+1]] - ml[peaksArr[i]], 2) + math.pow(ap[peaksArr[i+1]] - ap[peaksArr[i]], 2));
  }

  // Average the indicators to obtain the SDC Parameters
  double mt = timeIntervals.average();
  double mp = valueOfPeaks.average();
  double md = distances.average();

  // Compute the standard deviation of the indicators
  double st = timeIntervals.std();
  double sp = valueOfPeaks.std();
  double sd = distances.std();

  return Future.value({
    "numMax": numMax,
    "meanDistance": md,
    "stdDistance": sd,
    "meanTime": mt,
    "stdTime": st,
    "meanPeaks": mp,
    "stdPeaks": sp,
  });
}