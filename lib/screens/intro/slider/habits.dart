
import 'package:balance/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance/screens/intro/slider/widgets/custom_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance/manager/preference_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/intro/onboarding_bloc.dart';

/// Seventh intro screen
///
/// This Widget represents the Fourth of the intro
/// screens, his purpose is to ask the user if he has
/// some postural problems and if there are in his family
/// or if he use some drugs that can interfere with the
/// posture.
/// The user can leave blank this info.
class HabitsScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;

  HabitsScreen(this.screenIndex);

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _alcoholIntake = ['move_cursor_txt'.tr(), 'abstemious_txt'.tr(), 'occasional_txt'.tr(), 'at_meals_txt'.tr(), 'outside_meals_txt'.tr()];
  final _sportsActivity = ['move_cursor_txt'.tr(), 'no'.tr(), 'occasional_txt'.tr(), 'weekly_txt'.tr(), 'daily_txt'.tr()];

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) => current is NeedToValidateState && current.index == widget.screenIndex,
      listener: (context, state) {
        final isValid = _formKey.currentState.validate();
        if (isValid) {
          _formKey.currentState.save();
          context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent());
        }
        print("_PostureScreenState.build: Posture info are ${isValid? "valid": "invalid"}");
      },
      child: BlocBuilder<OnBoardingDataBloc, OnBoardingData>(
      builder: (ctx, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 64),
                Text(
                  'habits_title'.tr(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4
                      .copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'use_of_drugs_txt'.tr(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6
                              .copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    CustomToggleButton(
                      initial: state.useOfDrugs,
                      onChanged: (selected) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptHabits(useOfDrugs: selected));
                        PreferenceManager.updateUserInfo(useOfDrugs: selected == 1 ? true : false);
                      },
                      leftText: Text('no'.tr()),
                      rightText: Text('yes'.tr()),
                    ),
                  ],
                ),
                SizedBox(height: 36),
                Text(
                  'use_of_alcohol'.tr(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4
                      .copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Material(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Container(
                    width: 350.0,
                    height: 100.0,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Slider(
                            min: 0.0,
                            max: 100.0,
                            divisions: 4,
                            value: state.alcoholSliderValue ?? 0,
                            activeColor: Color(0xff512ea8),
                            inactiveColor: Color(0xffac9bcc),
                            onChanged: (newValue) {
                              // Enable/Disable the next button if the text field is empty
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptHabits(alcoholSliderValue: newValue));
                            },
                            onChangeEnd: (newValue) {
                              PreferenceManager.updateUserInfo(
                                  alcoholIntake: ((newValue * 4 / 100).round())
                                      .toInt());
                            }
                          ),
                        ),
                      ),
                      Text(_alcoholIntake.elementAt((state.alcoholSliderValue == null) ? 0 : (state.alcoholSliderValue * 4 / 100).round()),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline4
                            .copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],),
                  ),
                ),
                SizedBox(height: 36),
                Text(
                  'Svolgi attività motoria?',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4
                      .copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Material(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Container(
                    width: 350.0,
                    height: 100.0,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Slider(
                            min: 0.0,
                            max: 100.0,
                            divisions: 4,
                            value: state.sportsSliderValue ?? 0,
                            activeColor: Color(0xff512ea8),
                            inactiveColor: Color(0xffac9bcc),
                            onChanged: (newValue) {
                              // Enable/Disable the next button if the text field is empty
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptHabits(sportsSliderValue: newValue));
                            },
                            onChangeEnd: (newValue) {
                              PreferenceManager.updateUserInfo(
                                  sportsActivity: ((newValue * 4 / 100).round())
                                      .toInt());
                            }
                          ),
                        ),
                      ),
                      Text(_sportsActivity.elementAt((state.sportsSliderValue == null) ? 0 : (state.sportsSliderValue * 4 / 100).round()),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline4
                            .copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],),
                  ),
                ),
                SizedBox(height: 105)
              ],
            ),
          ),
        );
      }
    ));
  }
}
