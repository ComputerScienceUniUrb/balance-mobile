
import '../../../../model/measurement.dart';

/// Base State of the measurements page
abstract class ChartsState {
  const ChartsState();
}

/// State for when there is no data
class ChartsEmpty extends ChartsState {}

/// State for when the loading
class ChartsLoading extends ChartsState {}

/// State for when the data is retrieved successfully
class ChartsSuccess extends ChartsState {
  final List<Measurement> measurements;
  const ChartsSuccess(this.measurements);
}

/// State for when there is an error
class ChartsError extends ChartsState {
  final String exceptionMsg;
  const ChartsError(this.exceptionMsg);
}