
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:balance_app/posture_processor/src/list_extension.dart';

void main() {
  test("average computed correctly", () {
    final intList = [1, 2, 3, 4, 5, 6];
    expect(intList.average(), equals(3.5));

    final doubleList = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
    expect(doubleList.average(), equals(3.5));

    final rnd = Random();
    final randomList = List.generate(20, (index) => rnd.nextDouble());
    double avg = 0;
    double sum = 0;
    for (var i in randomList) {
      sum += i;
    }
    avg = sum / randomList.length;
    expect(randomList.average(), equals(avg));
  });

  test("average of a list with the same items is that item", () {
    expect([1,1,1,1,1,1].average(), equals(1));
  });

  test("average of empty list return NaN", () {
    List<int> list = [];
    expect(list.average(), isNaN);
  });

  test("standard deviation computed correctly", () {
    final intList = [1, 2, 3, 4, 5, 6];
    expect(intList.std(), within(distance: 0.000000000001, from: 1.870828693387));

    final doubleList = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
    expect(doubleList.std(), within(distance: 0.000000000001, from: 1.870828693387));

    final rnd = Random();
    final randomList = List.generate(20, (index) => rnd.nextDouble());
    double avg = randomList.average();
    double sum = 0;
    for (var i in randomList) {
      sum += pow(i - avg, 2);
    }
    final std = sqrt(sum / (randomList.length - 1));
    expect(randomList.std(), equals(std));
  });

  test("std of a list with the same items is 0", () {
    expect([1,1,1,1,1,1].std(), equals(0.0));
  });

  test("std of empty list return NaN", () {
    List<int> list = [];
    expect(list.std(), isNaN);
  });

  test("std of one-element list return 0", () {
    List<int> list = [12];
    expect(list.std(), equals(0.0));
  });

  test("variance computed correctly", () {
    final intList = [1, 2, 3, 4, 5, 6];
    expect(intList.variance(), within(distance: 0.000000000001, from: 3.5));

    final doubleList = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
    expect(doubleList.variance(), within(distance: 0.000000000001, from: 3.5));

    final rnd = Random();
    final randomList = List.generate(20, (index) => rnd.nextDouble());
    double avg = randomList.average();
    double sum = 0;
    for (var i in randomList) {
      sum += pow(i - avg, 2);
    }
    final variance = sum / (randomList.length - 1);
    expect(randomList.variance(), equals(variance));
  });

  test("variance of a list with the same items is 0", () {
    expect([1,1,1,1,1,1].variance(), equals(0.0));
  });

  test("variance of empty list return NaN", () {
    List<int> list = [];
    expect(list.variance(), isNaN);
  });

  test("variance of one-element list return 0", () {
    List<int> list = [12];
    expect(list.variance(), equals(0.0));
  });

  test("kurtosis computed correctly", () {
    final data = [
      0.0000014867,
      0.0000159837,
      0.0001338302,
      0.0008726827,
      0.0044318484,
      0.0175283005,
      0.0539909665,
      0.1295175957,
      0.2419707245,
      0.3520653268,
      0.3989422804,
      0.3520653268,
      0.2419707245,
      0.1295175957,
      0.0539909665,
      0.0175283005,
      0.0044318484,
      0.0008726827,
      0.0001338302,
      0.0000159837,
      0.0000014867,
    ];

    expect(data.kurtosis(), within(distance: 0.64, from: 3.4976));
  });

  test("kurtosis of normal distribution is 3", () {
    final normal = [
      0.62,
      -0.36,
      0.05,
      -0.29,
      -0.66,
      0.57,
      1.79,
      0.38,
      0.81,
      0.05,
      0.4,
      -0.64,
      1.4,
      -0.78,
      -0.02,
      0.28,
      1.45,
      -0.65,
      -0.94,
      -1.07,
      -0.44,
      1.15,
      -3.28,
      0.39,
      1.03,
      -0.3,
      0.63,
      -0.61,
      -0.6,
      -0.23,
      0.09,
      -0.37,
      0.76,
      1.01,
      0.49,
      2.33,
      0.14,
      0.12,
      0.74,
      -1.88,
      0.7,
      1.51,
      -2.54,
      -0.27,
      1.4,
      -1.35,
      -0.66,
      -0.98,
      0.31,
      -0.89,
      1.54,
      -1.09,
      -1.29,
      0.06,
      -0.56,
      -0.14,
      1.5,
      -0.41,
      -1.77,
      -0.4,
      -0.82,
      0.62,
      0.8,
      0.4,
      -2.11,
      1.16,
      -0.4,
      -0.59,
      0.37,
      1.21,
      1.27,
      0.36,
      -0.91,
      -1.39,
      -1.08,
      -1.6,
      -1.47,
      2.44,
      -1.68,
      -1.38,
      0.64,
      -0.01,
      0.15,
      -0.44,
      -0.7,
      -0.91,
      0.47,
      -0.1,
      1.29,
      -0.96,
      1.1,
      0.67,
      0.89,
      -1.47,
      -1.85,
      -0.53,
      -0.44,
      0.38,
      1.19,
      -0.63,
    ];

    expect(normal.kurtosis(), within(distance: 0.001, from: 3.0));
  });

  test("kurtosis of empty list return NaN", () {
    List<int> list = [];
    expect(list.kurtosis(), isNaN);
  });

  test("skwness index computed correctly", () {
    final data = [
      0.0000014867,
      0.0000159837,
      0.0001338302,
      0.0008726827,
      0.0044318484,
      0.0175283005,
      0.0539909665,
      0.1295175957,
      0.2419707245,
      0.3520653268,
      0.3989422804,
      0.3520653268,
      0.2419707245,
      0.1295175957,
      0.0539909665,
      0.0175283005,
      0.0044318484,
      0.0008726827,
      0.0001338302,
      0.0000159837,
      0.0000014867,
    ];

    expect(data.skewness(), within(distance: 0.072, from: 1.1087));
  });

  test("skewness of normal distribution is 0", () {
    final normal = [
      0.62,
      -0.36,
      0.05,
      -0.29,
      -0.66,
      0.57,
      1.79,
      0.38,
      0.81,
      0.05,
      0.4,
      -0.64,
      1.4,
      -0.78,
      -0.02,
      0.28,
      1.45,
      -0.65,
      -0.94,
      -1.07,
      -0.44,
      1.15,
      -3.28,
      0.39,
      1.03,
      -0.3,
      0.63,
      -0.61,
      -0.6,
      -0.23,
      0.09,
      -0.37,
      0.76,
      1.01,
      0.49,
      2.33,
      0.14,
      0.12,
      0.74,
      -1.88,
      0.7,
      1.51,
      -2.54,
      -0.27,
      1.4,
      -1.35,
      -0.66,
      -0.98,
      0.31,
      -0.89,
      1.54,
      -1.09,
      -1.29,
      0.06,
      -0.56,
      -0.14,
      1.5,
      -0.41,
      -1.77,
      -0.4,
      -0.82,
      0.62,
      0.8,
      0.4,
      -2.11,
      1.16,
      -0.4,
      -0.59,
      0.37,
      1.21,
      1.27,
      0.36,
      -0.91,
      -1.39,
      -1.08,
      -1.6,
      -1.47,
      2.44,
      -1.68,
      -1.38,
      0.64,
      -0.01,
      0.15,
      -0.44,
      -0.7,
      -0.91,
      0.47,
      -0.1,
      1.29,
      -0.96,
      1.1,
      0.67,
      0.89,
      -1.47,
      -1.85,
      -0.53,
      -0.44,
      0.38,
      1.19,
      -0.63,
    ];

    expect(normal.skewness(), within(distance: 0.173, from: 0.0));
  });

  test("skewness of empty list return NaN", () {
    List<int> list = [];
    expect(list.skewness(), isNaN);
  });
}