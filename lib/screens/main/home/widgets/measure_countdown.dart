import 'dart:async';

import 'package:balance/manager/vibration_manager.dart';
import 'package:balance/routes.dart';
import 'package:balance/screens/main/home/widgets/device_not_ready_dialog.dart';
import 'package:balance/screens/main/home/widgets/measuring_condition_dialog.dart';
import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:balance/screens/res/colors.dart';
import 'package:balance/screens/main/home/widgets/circular_countdown.dart';
import 'package:balance/screens/main/home/widgets/custom_toggle_button.dart';
import 'package:balance/manager/preference_manager.dart';

import 'package:balance/screens/main/home/widgets/calibrate_device_dialog.dart';
import 'package:balance/screens/main/home/widgets/leave_confirmation_dialog.dart';
import 'package:balance/screens/main/home/widgets/measuring_tutorial_dialog.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/main/home/countdown_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';

import 'wom_dialog.dart';

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

class _MeasureCountdownState extends State<MeasureCountdown>
    with WidgetsBindingObserver {
  CountdownBloc _bloc;
  bool _measuring = false;
  VibrationManager vibrationManager;
  Battery _battery = Battery();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = context.bloc<CountdownBloc>();
    _bloc.eyesOpen = true;
    _bloc.initCondition = 1;
    vibrationManager = VibrationManager();
  }

  @override
  Future<bool> didPopRoute() async {
    bool handlePop = false;
    if (_measuring)
      handlePop = await showLeaveDialog(context);
    if (!handlePop) _bloc.close();
    return handlePop;
  }

  @override
  void dispose() {
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundLost: () {
        print('Foreground Lost. Do you switched to another app?');
        if (_bloc.state is CountdownPreMeasureState)
          _bloc.add(CountdownEvents.stopPreMeasure);
        if (_bloc.state is CountdownMeasureState)
          _bloc.add(CountdownEvents.stopMeasure);
      },
      child: Center(
        child: BlocConsumer<CountdownBloc, CountdownState>(
            listener: (_, state) {
              state is CountdownMeasureState ? _measuring = true : _measuring =
              false;
              // Start/Stop the vibration and sounds
              if (state is CountdownPreMeasureState) {
                Wakelock.enable();
                vibrationManager.playSingle();
              }
              else if (state is CountdownCompleteState) {
                Wakelock.disable();
                vibrationManager.finish();
                Navigator.of(context).pushNamed(
                    Routes.result,
                    arguments: state.result
                );
              }
              else {
                if (state is CountdownIdleState){
                  Wakelock.disable();
                }
                vibrationManager.cancel ();
              }
            },
            builder: (context, state) {
              // Open the result page passing the measurement as argument
              // if (state is CountdownCompleteState)
              //   SchedulerBinding.instance.addPostFrameCallback((_) {
              //     Navigator.of(context).pushNamed(
              //         Routes.result,
              //         arguments: state.result
              //     );
              //   });
              // Build the ui based on the new state
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildWidgetForState(context, state),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        if (await _battery.batteryLevel < 30)
                          return showDeviceNotReady(context);
                      } on Exception {
                        print("Cannot take battery level from smartphone");
                      }

                      if (state is CountdownIdleState ||
                          state is CountdownCompleteState) {
                        /*
                         * Every time the user presses the start button we need to check
                         * two conditions:
                         * - the device is calibrated? if not ask the user to do it
                         * - we need to show the tutorial?
                         */
                        bool isDeviceCalibrated = await PreferenceManager
                            .isDeviceCalibrated;
                        bool showTutorial = await PreferenceManager
                            .showMeasuringTutorial;

                        if (!isDeviceCalibrated)
                          showCalibrateDeviceDialog(context);
                        else if (showTutorial) {
                          showWomDialog(
                              context,
                                  () async {
                                context.bloc<CountdownBloc>().add(
                                    CountdownEvents.startPreMeasure);
                              }
                          );
                          showMeasuringConditionDialog(
                              context,
                                  () async {
                                context
                                    .bloc<CountdownBloc>()
                                    .initCondition =
                                await PreferenceManager.initialCondition;
                              }
                          );
                          showTutorialDialog(
                              context,
                                  () => null
                          );
                        }
                        else {
                          showMeasuringConditionDialog(
                              context,
                                  () async {
                                context
                                    .bloc<CountdownBloc>()
                                    .initCondition =
                                await PreferenceManager.initialCondition;
                                context.bloc<CountdownBloc>().add(
                                    CountdownEvents.startPreMeasure);
                              }
                          );
                          showTutorialDialog(
                              context,
                                  () => null
                          );
                        }
                      }
                      else if (state is CountdownPreMeasureState) {
                        // Stop the pre measure countdown
                        vibrationManager.cancel();
                        context.bloc<CountdownBloc>().add(
                            CountdownEvents.stopPreMeasure);
                      }
                      else if (state is CountdownMeasureState) {
                        // Stop the measurement
                        vibrationManager.cancel();
                        context.bloc<CountdownBloc>().add(
                            CountdownEvents.stopMeasure);
                      }
                    },
                    color: BColors.colorAccent,
                    child: Text(
                      state is CountdownIdleState ||
                          state is CountdownCompleteState ? 'start_test_btn'
                          .tr() : 'stop_test_btn'.tr(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomToggleButton(
                    onChanged: (selected) =>
                    context
                        .bloc<CountdownBloc>()
                        .eyesOpen = (selected == 0) ? true : false,
                    leftText: Text('eyes_open'.tr()),
                    rightText: Text('eyes_closed').tr(),
                  )
                ],
              );
            }
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