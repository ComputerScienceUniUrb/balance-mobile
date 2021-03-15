
import 'dart:async';
import 'package:balance/model/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';
import 'package:quiver/iterables.dart';
import 'package:sensors/sensors.dart';

/// Class for monitor device's sensors
///
/// This class is able to listen to the sensors present in the device
/// through specific methods.
class SensorMonitor {
  static const MethodChannel _defaultSensorsMethodChannel = const MethodChannel("uniurb.it/sensors/presence");
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  final Duration duration;
  final MethodChannel _sensorsMethodChannel;
  final List<SensorData> _sensorsData;
  StreamController<Duration> _streamController;
  CountdownTimer _countdownTimer;

  /// Returns all the retrieved [SensorData]
  List<SensorData> get result => _sensorsData;

  /// Default constructor
  SensorMonitor([this.duration = const Duration(milliseconds: 5000)]):
    _sensorsMethodChannel = _defaultSensorsMethodChannel,
    _sensorsData = [];

  /// This constructor is only used for testing and
  /// shouldn't be accessed from outside this class
  @visibleForTesting
  SensorMonitor.private(this._sensorsMethodChannel):
    duration = const Duration(milliseconds: 5000),
    _sensorsData = [];

  /// Returns true if the accelerometer sensor is present
  Future<bool> get isAccelerometerPresent =>
    _sensorsMethodChannel.invokeMethod("isAccelerometerPresent")
      .then<bool>((value) => value);
  /// Returns true if the gyroscope sensor is present
  Future<bool> get isGyroscopePresent =>
    _sensorsMethodChannel.invokeMethod("isGyroscopePresent")
      .then<bool>((value) => value);

  /// Listens to sensor data for a given [duration]
  ///
  /// This method will return a [Stream] of [Duration] with
  /// the elapsed time from the start.
  /// Creates a new broadcast [StreamController] for each
  /// new listening, this controller is responsible of starting
  /// and stopping a senors [EventChannel] and a [CountdownTimer].
  ///
  /// Calling this method during the listening will return the
  /// previously created [StreamController], so to start a new one
  /// the current active must be cancelled by unregister all the
  /// listeners or waiting the timer completion.
  Stream<Duration> get sensorStream {
    List<AccelerometerEvent> accelerometerList = new List<AccelerometerEvent>();
    List<GyroscopeEvent> gyroscopeList = new List<GyroscopeEvent>();
    // Create a new Broadcast StreamController if not already present
    _streamController ??= StreamController.broadcast(
      onListen: () {
        /*
         * When the stream if first listened to the old
         * retrieved data is cleared, a new stream form
         * EventChannel is listened and a new CountdownTimer
         * is started
         */
        print("SensorMonitor.sensorStream: Start listening to sensor data!");
        _sensorsData.clear();
        _streamSubscriptions.add(
            accelerometerEvents(delay: 10000).listen((AccelerometerEvent event) {
                accelerometerList.add(event);
            }));
        _streamSubscriptions.add(
            gyroscopeEvents(delay: 10000).listen((GyroscopeEvent event) {
              gyroscopeList.add(event);
            }));
        _countdownTimer = CountdownTimer(duration, Duration(milliseconds: 1000))
          ..listen((event) => _streamController.add(event.elapsed),
            onDone: () {
              _sensorsData.addAll(eventToSensorData(accelerometerList, gyroscopeList));
              // If the StreamController is not null close it
              _streamController?.close();
            }
          );
      },
      onCancel: () {
        /*
         * When the stream is cancelled the EventChannel is closed,
         * the StreamController instance is set to null and if the
         * timer is running (meaning the StreamController is cancelled
         * by the last listener leaving) it's cancelled.
         */
        print("SensorMonitor.sensorStream: Stop listening to sensor data!");
        if (_countdownTimer.isRunning)
          _countdownTimer.cancel();
        for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
          subscription.cancel();
          clearAccelerometerEventsStream();
          clearGyroscopeEventsStream();
        }
        _streamController = null;
      },
    );
    return _streamController?.stream;
  }

  /// Map any received event to a [SensorData]
  ///
  /// This method maps any event received from [EventChannel]
  /// to a [SensorData] or null if the data is incorrect.
  @visibleForTesting
  static List<SensorData> eventToSensorData(List<AccelerometerEvent> accEvents, List<GyroscopeEvent> gyrEvents) {
    List<SensorData> l = new List();

    for (var pair in zip([accEvents, gyrEvents]).toList()) {
      AccelerometerEvent accEvent = pair[0];
      GyroscopeEvent gyrEvent = pair[1];

      int timestamp = accEvent.timestamp;
      int accuracy = (accEvent.accuracy > gyrEvent.accuracy) ? accEvent.accuracy : gyrEvent.accuracy;
      double accX = accEvent.x;
      double accY = accEvent.y;
      double accZ = accEvent.z;
      double gyroX = gyrEvent.x;
      double gyroY = gyrEvent.y;
      double gyroZ = gyrEvent.z;

      l.add(SensorData(timestamp,accuracy,accX,accY,accZ,gyroX,gyroY,gyroZ));
    }

    return l;
  }
}

