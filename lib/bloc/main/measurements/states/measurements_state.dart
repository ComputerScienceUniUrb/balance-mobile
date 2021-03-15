
import 'package:balance/floor/test_database_view.dart';

/// Base State of the measurements page
abstract class MeasurementsState {
  const MeasurementsState();
}

/// State for when there is no data
class MeasurementsEmpty extends MeasurementsState {}

/// State for when the loading
class MeasurementsLoading extends MeasurementsState {}

/// State for when the data is retrieved successfully
class MeasurementsSuccess extends MeasurementsState {
  final List<Test> tests;
  const MeasurementsSuccess(this.tests);
}

/// State for when there is an error
class MeasurementsError extends MeasurementsState {
  final String exceptionMsg;
  const MeasurementsError(this.exceptionMsg);
}