
import 'package:balance_app/model/statokinesigram.dart';

/// Base State of the result page
abstract class ResultState {
  const ResultState();
}

/// State for when the data is loading
class ResultLoading extends ResultState {}

/// State for when the data is retrieved successfully
class ResultSuccess extends ResultState {
  final Statokinesigram statokinesigram;

  const ResultSuccess(this.statokinesigram);
}

/// State for when there is an error
class ResultError extends ResultState {
  final String exceptionMsg;
  const ResultError(this.exceptionMsg);
}

/// State for when the export is completed successfully
class ResultExportSuccess extends ResultState {}