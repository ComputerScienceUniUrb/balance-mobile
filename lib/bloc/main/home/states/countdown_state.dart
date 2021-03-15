
import 'package:balance/floor/test_database_view.dart';

/// Abstract class representing the state of the countdown
abstract class CountdownState {
  const CountdownState();
}

/// The countdown is idle
///
/// This state tells that the countdown is idle, the ui
/// will draw the start button and the idle icon
class CountdownIdleState extends CountdownState {}

/// The countdown is pre measure
///
/// This state tells that the countdown is in pre measure,
/// the pre measure countdown will be drawn and a vibration/
/// sound will be played on every tick.
class CountdownTargetingState extends CountdownState {}

/// The countdown is pre measure
///
/// This state tells that the countdown is in pre measure,
/// the pre measure countdown will be drawn and a vibration/
/// sound will be played on every tick.
class CountdownPreMeasureState extends CountdownState {}

/// The countdown is measuring
///
/// This state tells that the countdown is in measure,
/// the measure countdown will be drawn and a vibration/
/// sound will be played at the start and at the end.
class CountdownMeasureState extends CountdownState {}

/// The countdown is complete
///
/// This state tells that the countdown is completed,
/// the ui will be drawn as idle, but the app will navigate
/// to the result screen passing [result] as argument.
/// If [error] is non-null it means that an exception was
/// thrown saving the data in the database.
class CountdownCompleteState extends CountdownState {
  final Test result;
  final Exception error;

  const CountdownCompleteState._(this.result, this.error);

  /// Creates an instance of [CountdownCompleteState] with the result
  factory CountdownCompleteState.success(Test result) => CountdownCompleteState._(result, null);

  /// Creates an instance of [CountdownCompleteState] with an [Exception]
  factory CountdownCompleteState.error(Exception ex) => CountdownCompleteState._(null, ex);

  /// Returns true if the error is non-null
  bool get hasError => error != null;

  @override
  String toString() => "CountdownCompleteState("
    "result=$result, "
    "error=$error"
    ")";
}
