import 'dart:async';

import 'package:balance_app/sensors/sensor_monitor.dart';
import 'package:balance_app/sensors/sensor_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {

  MockMonitor mockMonitor;
  SensorController sensorController;

  setUp(() {
    mockMonitor = MockMonitor();
    sensorController = SensorController.private(mockMonitor, Duration(seconds: 1));
  });

  test("Init state is none", () => expect(sensorController.state, equals(SensorController.none)));

  group("Listen", () {
    StreamController<Duration> mockDataController;

    setUp(() {
      mockDataController = StreamController();
      when(mockMonitor.sensorStream).thenAnswer((realInvocation) => mockDataController.stream);
    });

    tearDown(() => mockDataController.close());

    test("throws on multiple listen", () {
      sensorController.listen();
      expect(() => sensorController.listen(), throwsException);
    });

    test("listen sets state", () {
      sensorController.listen();
      expect(sensorController.state, equals(SensorController.listening));
    });

    test("cancel sets state", () {
      sensorController.listen();
      sensorController.cancel();
      expect(sensorController.state, equals(SensorController.cancelled));
    });

    test("complete sets state", () {
      sensorController.listen();
      sensorController.addListener(() {
        if (sensorController.state != SensorController.listening)
          expect(sensorController.state, equals(SensorController.complete));
      });
    });
  });
}

class MockMonitor extends Mock implements SensorMonitor {}