
/// Enum representing the events on the countdown
enum CountdownEvents {
  /// Tells the bloc to start the pre measure countdown
  startPreMeasure,

  /// Tells the bloc to start the measure countdown
  startMeasure,

  /// Tells the bloc to stop the pre measure countdown
  stopPreMeasure,

  /// Tells the bloc to stop the measure countdown
  stopMeasure,

  /// Tells the bloc that the test is complete
  measureComplete,

  /// Tells the bloc that the widget is in idle
  setToIdle,
}