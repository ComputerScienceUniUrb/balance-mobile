
import 'dart:math';

import 'package:balance_app/model/raw_measurement_data.dart';
import 'package:balance_app/posture_processor/src/list_extension.dart';

Future<Map<String, double>> gyroscopicFeatures(List<RawMeasurementData> data) {
  // Extract x,y,z from RawMeasurementData
  final List<RawMeasurementData> gyroscopeData = List.from(data);
  gyroscopeData.removeWhere((e) => e.gyroscopeX == null || e.gyroscopeY == null || e.gyroscopeZ == null);

  final x = gyroscopeData.map((e) => e.gyroscopeX).toList();
  final y = gyroscopeData.map((e) => e.gyroscopeY).toList();
  final z = gyroscopeData.map((e) => e.gyroscopeZ).toList();

  // Get max value of x,y,z
  final gmX = x.isNotEmpty? x.reduce(max): double.nan;
  final gmY = y.isNotEmpty? y.reduce(max): double.nan;
  final gmZ = z.isNotEmpty? z.reduce(max): double.nan;

  // Get range value of x,y,z
  final grX = x.isNotEmpty? gmX - x.reduce(min): double.nan;
  final grY = y.isNotEmpty? gmY - y.reduce(min): double.nan;
  final grZ = z.isNotEmpty? gmZ - z.reduce(min): double.nan;

  // Get variance of x,y,z
  final gvX = x.variance();
  final gvY = y.variance();
  final gvZ = z.variance();

  // Get kurtosis index of x,y,z
  final gkX = x.kurtosis();
  final gkY = y.kurtosis();
  final gkZ = z.kurtosis();

  // Get skewness index of x,y,z
  final gsX = x.skewness();
  final gsY = y.skewness();
  final gsZ = z.skewness();

  return Future.value({
    "grX": grX,
    "grY": grY,
    "grZ": grZ,
    "gmX": gmX,
    "gmY": gmY,
    "gmZ": gmZ,
    "gvX": gvX,
    "gvY": gvY,
    "gvZ": gvZ,
    "gsX": gsX,
    "gsY": gsY,
    "gsZ": gsZ,
    "gkX": gkX,
    "gkY": gkY,
    "gkZ": gkZ,
  });
}