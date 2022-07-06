
import 'dart:async';
import 'package:balance/repository/wom_repository.dart';
import 'package:quiver/async.dart';
import 'package:balance/floor/measurement_database.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/repository/measure_countdown_repository.dart';
import 'package:balance/bloc/main/home/events/countdown_events.dart';
import 'package:balance/bloc/main/home/states/countdown_state.dart';
import 'package:balance/sensors/sensor_monitor.dart';

/// Class implementing the bloc pattern for the measure countdown
class CountdownBloc extends Bloc<CountdownEvents, CountdownState> {
  CountdownTimer _countdownTimer;
  bool _isCountdownCancelled;
  SensorMonitor _sensorMonitor;
  StreamSubscription<Duration> _monitorSub;
  MeasureCountdownRepository _repository;
  WomRepository _repositoryWom;
  bool _eyesOpen;
  int _initCondition;

  /// Setter for the [_eyesOpen] and [_initCondition] parameter
  void set eyesOpen(bool value) => _eyesOpen = value;
  void set initCondition(int value) => _initCondition = value;

  /// Private constructor of [CountdownBloc]
  CountdownBloc._(MeasurementDatabase db):
    _repository = MeasureCountdownRepository(db),
    _repositoryWom = WomRepository(db),
    _isCountdownCancelled = false,
    _sensorMonitor = SensorMonitor(Duration(milliseconds: 30000));

  /// Factory method for creating an instance of [CountdownBloc]
  factory CountdownBloc.create(MeasurementDatabase db) => CountdownBloc._(db);

  @override
  CountdownState get initialState => CountdownIdleState();

  @override
  Stream<CountdownState> mapEventToState(CountdownEvents event) async* {
    switch (event) {
      // Start the pre measuring countdown
      case CountdownEvents.startPreMeasure:
        print("CountdownBloc.mapEventToState: startPreMeasure");
        _isCountdownCancelled = false;
        _countdownTimer = CountdownTimer(
          Duration(milliseconds: 10000),
          Duration(milliseconds: 1000)
        )..listen((event) { /*No-Op*/ },
            onDone: () {
              if (!_isCountdownCancelled)
                add(CountdownEvents.startMeasure);
            }
          );
        yield CountdownPreMeasureState();
        break;
      // Start the measuring
      case CountdownEvents.startMeasure:
        print("CountdownBloc.mapEventToState: startMeasure");
        _monitorSub = _sensorMonitor.sensorStream.listen((event) { /*No-op*/ },
          onDone: () {
            _monitorSub = null;
            add(CountdownEvents.measureComplete);
          }
        );
        yield CountdownMeasureState();
        break;
      // Stop the pre measuring countdown
      case CountdownEvents.stopPreMeasure:
        print("CountdownBloc.mapEventToState: stopPreMeasure");
        _isCountdownCancelled = true;
        _countdownTimer.cancel();
        _countdownTimer = null;
        yield CountdownIdleState();
        break;
      // Stop the measuring
      case CountdownEvents.stopMeasure:
        print("CountdownBloc.mapEventToState: stopMeasure");
        _monitorSub.cancel();
        _monitorSub = null;
        yield CountdownIdleState();
        break;
      // Reset the widget
      case CountdownEvents.setToIdle:
        print("CountdownBloc.mapEventToState: setToIdle");
        yield CountdownIdleState();
        break;
      // Save the new test into the database
      case CountdownEvents.measureComplete:
        try {
          final newTest = await _repository.createNewMeasurement(_sensorMonitor.result, _eyesOpen, _initCondition);
          print("CountdownBloc.mapEventToState: Test $newTest created with ${_sensorMonitor.result.length} raw data");
          yield CountdownCompleteState.success(newTest);
        } catch(e) {
          print("CountdownBloc.mapEventToState: Error saving the new Measurement: $e");
          yield CountdownCompleteState.error(e);
        } finally {
        }
        break;
    }
  }

  @override
  Future<void> close() {
    // Stop the countdown timer
    _isCountdownCancelled = true;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    // Stop the sensor monitor
    _monitorSub?.cancel();
    _monitorSub = null;
    return super.close();
  }
}