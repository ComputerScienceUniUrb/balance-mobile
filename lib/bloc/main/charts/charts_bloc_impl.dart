
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/model/measurement.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/result_repository.dart';
import 'events/charts_events.dart';
import 'states/charts_state.dart';

/// Class representing the Bloc for Measurements page
///
/// This class is the core of the Bloc pattern, it converts from [ChartsEvents]
/// to [ChartsState]
class ChartsBloc extends Bloc<ChartsEvents, ChartsState> {
  final ResultRepository repository;

  ChartsBloc._(MeasurementDatabase db): repository = ResultRepository((db));
  factory ChartsBloc.create(MeasurementDatabase db) =>
    ChartsBloc._(db)..add(ChartsEvents.fetch);

  @override
  ChartsState get initialState => ChartsLoading();

  @override
  Stream<ChartsState> mapEventToState(ChartsEvents event) async* {
    if (event == ChartsEvents.fetch) {
      // fetch the data from the repository
      try {
        final measurements = await repository.getAllResults();
        if (_isDataEnough(measurements))
          yield ChartsSuccess(measurements);
        else
          yield ChartsEmpty();
      } on Exception catch (e) {
        print("MeasurementsBloc.mapEventToState: Unknown Exception: [$e]");
        yield ChartsError(e.toString());
      } catch (e) {
        print("MeasurementsBloc.mapEventToState: Undefined Error: [$e]");
        yield ChartsError(e.toString());
      }
    }
  }

  // Check if there are at least two measurements per condition
  static bool _isDataEnough(List<Measurement> tests) {
    int eyesOpenTests = 0;
    int eyesCloseTests = 0;

    for(var i = 0; i < tests.length; i++) {
      if (tests[i].eyesOpen == true)
        eyesOpenTests+=1;
      if (tests[i].eyesOpen == false)
        eyesCloseTests+=1;
    }

    return eyesOpenTests > 1 || eyesCloseTests > 1 ? true:false;
  }
}