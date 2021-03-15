import 'dart:async';

import 'package:balance/model/sensor_data.dart';
import 'package:balance/sensors/sensor_monitor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  MockEventChannel mockEventChannel;
  MockMethodChannel mockMethodChannel;
  SensorMonitor sensorMonitor;

  setUp(() {
    mockEventChannel = MockEventChannel();
    mockMethodChannel = MockMethodChannel();
    //sensorMonitor = SensorMonitor.private(mockMethodChannel, mockEventChannel);
  });

  // Group of tests for the method eventToSensorEvent
  group("Parse sensor events", () {

    test("parse good data", () {
      var goodData = [1,2,3.0,4.0,5.0,6.0,7.0,8.0];
      //expect(SensorMonitor.eventToSensorData(goodData), isNotNull);
      //expect(SensorMonitor.eventToSensorData(goodData), SensorData(1,2,3.0,4.0,5.0,6.0,7.0,8.0));
    });

    test("parse bad data", () {
      var badData = ["wrong",2,3.0,4.0,5.0,6.0,7.0,8.0];
      //expect(SensorMonitor.eventToSensorData(badData), isNull);

      var badData2 = [1,2,0.0];
      //expect(SensorMonitor.eventToSensorData(badData2), isNull);
    });
  });

  // Group of tests for retrieving a specific sensor presence
  group("Sensor presence", () {

    test("accelerometer presence", () async {
      when(mockMethodChannel.invokeMethod<bool>("isAccelerometerPresent"))
        .thenAnswer((realInvocation) => Future<bool>.value(true));
      expect(await sensorMonitor.isAccelerometerPresent, true);

      when(mockMethodChannel.invokeMethod<bool>("isAccelerometerPresent"))
        .thenAnswer((realInvocation) => Future<bool>.value(false));
      expect(await sensorMonitor.isAccelerometerPresent, false);
    });

    test("gyroscope presence", () async {
      when(mockMethodChannel.invokeMethod<bool>("isGyroscopePresent"))
        .thenAnswer((realInvocation) => Future<bool>.value(true));
      expect(await sensorMonitor.isGyroscopePresent, true);

      when(mockMethodChannel.invokeMethod<bool>("isGyroscopePresent"))
        .thenAnswer((realInvocation) => Future<bool>.value(false));
      expect(await sensorMonitor.isGyroscopePresent, false);
    });
  });

  // Group of tests for listening a stream of sensor data
  group("Sensor events", () {
    StreamController<List> mockDataController;

    setUp(() {
      mockDataController = StreamController();
      when(mockEventChannel.receiveBroadcastStream())
        .thenAnswer((_) => mockDataController.stream);
    });

    tearDown(() => mockDataController.close());

    test("multiple invocations", () async{
      sensorMonitor.sensorStream.listen((event) {});
      sensorMonitor.sensorStream.listen((event) {});
      sensorMonitor.sensorStream.listen((event) {});

      verify(mockEventChannel.receiveBroadcastStream()).called(1);
    });

    test("cancel timer", () {
      final sub = sensorMonitor.sensorStream.listen((event) { });
      mockDataController.add([0,0,0.0,0.0,0.0,0.0,0.0,0.0]);
      Future.delayed(Duration(seconds: 1), () {
        sub.cancel();
        expect(sensorMonitor.result, isNotEmpty);
      });
    });

    test("receive some data", () async {
      final mockData = [
        SensorData(0,0,0.0,0.0,0.0,0.0,0.0,0.0),
        SensorData(1,1,1.0,1.0,1.0,1.0,1.0,1.0),
        SensorData(2,2,2.0,2.0,2.0,2.0,2.0,2.0),
      ];
      final mockSendData = [
        [0,0,0.0,0.0,0.0,0.0,0.0,0.0],
        [1,1,1.0,1.0,1.0,1.0,1.0,1.0],
        [2,2,2.0,2.0,2.0,2.0,2.0,2.0],
      ];

      mockDataController.add(mockSendData[0]);
      mockDataController.add(mockSendData[1]);
      mockDataController.add(mockSendData[2]);
      await for (var _ in sensorMonitor.sensorStream) {}
      expect(sensorMonitor.result, isNotEmpty);
      expect(sensorMonitor.result, mockData);
    });

    test("receive null data", () async {
      mockDataController.add(null);
      await for (var _ in sensorMonitor.sensorStream) {}
      expect(sensorMonitor.result, isEmpty);
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
class MockEventChannel extends Mock implements EventChannel {}
