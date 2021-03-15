
import 'package:balance/bloc/main/measurements/states/measurements_state.dart';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/repository/measurements_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/measurements_events.dart';

/// Class representing the Bloc for Measurements page
///
/// This class is the core of the Bloc pattern, it converts from [MeasurementsEvents]
/// to [MeasurementsState]
class MeasurementsBloc extends Bloc<MeasurementsEvents, MeasurementsState> {
  final MeasurementsRepository repository;

  MeasurementsBloc._(MeasurementDatabase db): repository = MeasurementsRepository(db);
  factory MeasurementsBloc.create(MeasurementDatabase db) =>
    MeasurementsBloc._(db)..add(MeasurementsEvents.fetch);

  @override
  MeasurementsState get initialState => MeasurementsLoading();

  @override
  Stream<MeasurementsState> mapEventToState(MeasurementsEvents event) async* {
    if (event == MeasurementsEvents.fetch) {
      // fetch the data from the repository
      try {
        final tests = await repository.getMeasurements();
        if (tests.isEmpty)
          yield MeasurementsEmpty();
        else
          yield MeasurementsSuccess(tests);
      } on Exception catch (e) {
        print("MeasurementsBloc.mapEventToState: Unknown Exception: [$e]");
        yield MeasurementsError(e.toString());
      } catch (e) {
        print("MeasurementsBloc.mapEventToState: Undefined Error: [$e]");
        yield MeasurementsError(e.toString());
      }
    }
  }
}