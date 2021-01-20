
import 'dart:async';

import 'package:balance_app/manager/vibration_manager.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/routes.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/widgets/circular_countdown.dart';
import 'package:balance_app/widgets/custom_toggle_button.dart';
import 'package:balance_app/floor/measurement_database.dart';
import 'package:flutter/scheduler.dart';
import 'package:balance_app/manager/preference_manager.dart';

import 'package:balance_app/dialog/calibrate_device_dialog.dart';
import 'package:balance_app/dialog/leave_confirmation_dialog.dart';
import 'package:balance_app/dialog/measuring_tutorial_dialog.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/countdown_bloc.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';
import 'package:battery/battery.dart';

/// Widget that manage the entire measuring process
///
/// This widget has the purpose of managing the entirety of the
/// posture test process; it contains an instance of [CountdownBloc]
/// rebuilding the ui on every new state, it intercept [didPopRoute]
/// events asking the user if he wants to abort the test and close
/// the app.
class MeasureCountdown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeasureCountdownState();
}

class _MeasureCountdownState extends State<MeasureCountdown> with WidgetsBindingObserver {
  CountdownBloc _bloc;
  bool _measuring = false;
  VibrationManager vibrationManager;
  var _battery = Battery();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Create a CountdownBloc with an instance of the database
    _bloc = CountdownBloc.create(
      Provider.of<MeasurementDatabase>(context, listen: false)
    );
    _bloc.eyesOpen = true;
    vibrationManager = VibrationManager();
  }

  @override
  Future<bool> didPopRoute() async{
    bool handlePop = false;
    if (_measuring)
      handlePop = await showLeaveDialog(context);
    if (!handlePop) _bloc.close();
    return handlePop;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // Dismiss the bloc
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        print(
          'Focus Lost. Triggered when either [onVisibilityLost] or [onForegroundLost] '
              'is called. Equivalent to onPause() on Android or viewDidDisappear() on iOS.',
        );
      },
      onVisibilityLost: () {
        print('Visibility Lost. Did you move to Test or Settings?.');
      },
      onForegroundLost: () {
        print('Foreground Lost. Do you switched to another app?');
        if (_bloc.state is CountdownPreMeasureState)
          _bloc.add(CountdownEvents.stopPreMeasure);
        if (_bloc.state is CountdownMeasureState)
          _bloc.add(CountdownEvents.stopPreMeasure);
      },
      child: Center(
        child: BlocProvider<CountdownBloc>.value(
          value: _bloc,
          child: BlocConsumer<CountdownBloc, CountdownState>(
              listener: (_, state) {
                state is CountdownMeasureState? _measuring = true: _measuring = false;
                // TODO: This stuff here goes on error in iOS Debug
                // Start/Stop the vibration
                if (state is CountdownPreMeasureState) {
                  Wakelock.enable();
                  vibrationManager.playPattern();
                }
                else if (state is CountdownMeasureState || state is CountdownCompleteState) {
                  Wakelock.enable();
                  vibrationManager.playSingle();
                }
                else {
                  Wakelock.disable();
                  vibrationManager.cancel();
                }
              },
              builder: (context, state) {
                // Open the result page passing the measurement as argument
                if (state is CountdownCompleteState)
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamed(
                        Routes.result,
                        arguments: state.result
                    );
                  });
                // Build the ui based on the new state
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWidgetForState(context, state),
                    SizedBox(height: 0),
                    RaisedButton(
                      onPressed: () async{
                        if (state is CountdownIdleState || state is CountdownCompleteState) {
                          /*
                   * Every time the user presses the start button we need to check
                   * two conditions:
                   * - the device is calibrated? if not ask the user to do it
                   * - we need to show the tutorial?
                   */
                          bool isDeviceCalibrated = await PreferenceManager.isDeviceCalibrated;
                          bool showTutorial = await PreferenceManager.showMeasuringTutorial;
                          if (!isDeviceCalibrated)
                            showCalibrateDeviceDialog(context);
                          else if (showTutorial)
                            showTutorialDialog(
                                context,
                                    () => context.bloc<CountdownBloc>().add(CountdownEvents.startPreMeasure)
                            );
                          else
                            context.bloc<CountdownBloc>().add(CountdownEvents.startPreMeasure);
                        }
                        else if (state is CountdownPreMeasureState) {
                          // Stop the pre measure countdown
                          vibrationManager.cancel();
                          context.bloc<CountdownBloc>().add(CountdownEvents.stopPreMeasure);
                        }
                        else if (state is CountdownMeasureState) {
                          // Stop the measurement
                          vibrationManager.cancel();
                          context.bloc<CountdownBloc>().add(CountdownEvents.stopMeasure);
                        }
                      },
                      color: BColors.colorAccent,
                      child: Text(
                        state is CountdownIdleState || state is CountdownCompleteState? 'start_test_btn'.tr() : 'stop_test_btn'.tr(),
                        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomToggleButton(
                      onChanged: (selected) => context.bloc<CountdownBloc>()
                          .eyesOpen = (selected == 0)? true: false,
                      leftText: Text('eyes_open'.tr()),
                      rightText: Text('eyes_closed').tr(),
                    )
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

  /// Return the correct widget based on the current state
  Widget _buildWidgetForState(BuildContext context, CountdownState state) {
    if (state is CountdownPreMeasureState || state is CountdownMeasureState)
        return CircularCounter(state: state);
    else
        // Circular logo of the app
        return Container(
          margin: const EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: Center(
            child: Image.asset("assets/app_logo_circle.png"),
          ),
        );
  }
}