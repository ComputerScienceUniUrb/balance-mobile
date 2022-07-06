
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/repository/wom_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/settings_events.dart';
import 'states/settings_state.dart';


/// Class representing the Bloc for Measurements page
///
/// This class is the core of the Bloc pattern, it converts from [MeasurementsEvents]
/// to [MeasurementsState]
class SettingsBloc extends Bloc<SettingsEvents,SettingsState> {
  final WomRepository repository;

  SettingsBloc._(MeasurementDatabase db): repository = WomRepository(db);
  factory SettingsBloc.create(MeasurementDatabase db) =>
      SettingsBloc._(db)..add(SettingsEvents.fetch);

  @override
  SettingsState get initialState => SettingsLoading();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvents event) async* {
    if (event == SettingsEvents.fetch) {
      // fetch the data from the repository
      try {
        final woms = await repository.getAllWom();
        final archived = await PreferenceManager.archivedWom;
        if (woms.isEmpty)
          yield SettingsEmpty();
        else
          yield SettingsSuccess(woms,archived);
      } on Exception catch (e) {
        print("MeasurementsBloc.mapEventToState: Unknown Exception: [$e]");
        yield SettingsError(e.toString());
      } catch (e) {
        print("MeasurementsBloc.mapEventToState: Undefined Error: [$e]");
        yield SettingsError(e.toString());
      }
    }
  }
}