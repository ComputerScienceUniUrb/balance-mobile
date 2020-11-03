import 'dart:async';

import 'package:balance_app/model/sensor_data.dart';
import 'package:balance_app/sensors/sensor_monitor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget that makes listening to sensors more easy
/// 
/// This Widget implements a [ChangeNotifierProvider] 
/// of [SensorController] to manage the listening of 
/// sensor events; the Widget will respond to changes
/// in the listening state by calling the [builder] 
/// method with the new state and let his child Widgets
/// rebuild accordingly.
/// 
/// This Widget will stop the listening automatically
/// when the back button is pressed or the Widget is
/// disposed. 
class SensorWidget extends StatefulWidget {
  final Duration duration;
  final Widget Function(BuildContext context, SensorController controller) builder;

  SensorWidget({
    Key key,
    this.duration: const Duration(seconds: 5),
    @required this.builder
  }): assert(builder != null),
    super(key: key);

  @override
  _SensorWidgetState createState() => _SensorWidgetState();
}

class _SensorWidgetState extends State<SensorWidget> with WidgetsBindingObserver {
  SensorController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = SensorController(widget.duration);
    super.initState();
  }

  @override
  Future<bool> didPopRoute() {
    // Cancel the SensorController when the back button is pressed
    _controller.cancel();
    return Future.value(false);
  }

  @override
  void dispose() {
    // Cancel the SensorController when the widget is disposed
    _controller.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SensorController>.value(
      value: _controller,
      child: Consumer<SensorController>(
        // Every time the Consumer has new values re-build the child widgets
        builder: (context, value, _) => widget.builder(context, value),
      ),
    );
  }
}

/// Wrapper class for [SensorMonitor]
/// 
/// This class implements a [ChangeNotifier]
/// to update his listeners every time the 
/// monitor is started or stopped; SensorController
/// can have four states: none, listening, cancelled, 
/// complete.
class SensorController extends ChangeNotifier {
  /// The controller is freshly created
  static const int none = 0;
  /// The controller is listening to [SensorMonitor]
  static const int listening = 1;
  /// The controller is cancelled
  static const int cancelled = 2;
  /// The controller has finished the listening
  static const int complete = 3;

  final Duration duration;
  final SensorMonitor _monitor;
  StreamSubscription _sub;
  int _state;

  SensorController(this.duration):
    _monitor = SensorMonitor(duration),
    _state = SensorController.none;

  @visibleForTesting
  SensorController.private(this._monitor, this.duration):
      _state = SensorController.none;

  /// Returns the state of [SensorController]
  int get state => _state;

  /// Returns [SensorMonitor.result]
  List<SensorData> get result => _monitor.result;

  /// Start listening to [SensorMonitor.sensorStream]
  /// 
  /// This method is called every time we want to start listening
  /// to sensor data in [SensorMonitor], it emits [listening] and
  /// [complete] states for [SensorController]'s listeners.
  /// 
  /// This method can be called only once per listening, so calling
  /// this multiple times will throw and [Exception].
  void listen() {
    if (_sub != null) throw Exception("SensorController.listen called multiple times! You are already listening.");
    _sub = _monitor.sensorStream.listen((event) { /*NoOp*/ },
      onDone: () {
        _sub = null;
        _state = SensorController.complete;
        notifyListeners();
      }
    );
    _state = SensorController.listening;
    notifyListeners();
  }

  /// Stop listening to [SensorMonitor.sensorStream]
  /// 
  /// This method will cancel the [Stream] of [SensorMonitor.sensorStream]
  /// cancelling the listening process.
  /// 
  /// This method will emit a [cancelled] state every time it's called. 
  void cancel() {
    _sub?.cancel();
    _sub = null;
    _state = SensorController.cancelled;
    notifyListeners();
  }
}