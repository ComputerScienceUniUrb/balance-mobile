
import 'package:balance_app/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_switch.dart';
import 'package:balance_app/screens/intro/slider/widgets/lite_rolling_switch.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';

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
  final bool useOfDrugs;
  final int alcoholIntake;
  final int alcoholIndex;
  final int sportsActivity;
  final ValueChanged<bool> enableNextBtnCallback;

  HabitsScreen(this.screenIndex, this.enableNextBtnCallback, {
    this.useOfDrugs,
    this.alcoholIntake,
    this.alcoholIndex,
    this.sportsActivity,
  });

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _alcoholIntake = ['abstemious_txt'.tr(), 'occasional_txt'.tr(), 'at_meals_txt'.tr(), 'outside_meals_txt'.tr()];
  String _alcoholSelected;
  final _sportsActivity = ['Affatto', 'Occasionale', 'Settimanale', 'Quotidiano'];
  double _sportsSliderValue = 0;
  String _sportsActivitySelected;
  int _alcoholIndex;
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _alcoholIndex = widget.alcoholIndex ?? 0;
    _alcoholSelected = _alcoholIntake.elementAt(0);
  }

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
                SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    Text(
                      'Astemio',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Occasionale',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Ai Pasti',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Fuori Pasto',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: BColors.colorPrimary,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                      value: _currentSliderValue,
                      min: 0,
                      max: 100,
                      divisions: 3,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          _alcoholSelected = _alcoholIntake.elementAt(
                              ((value * 3 / 100).round()));
                        });
                      },
                      onChangeEnd: (newValue) {
                        PreferenceManager.updateUserInfo(
                            alcoholIntake: ((newValue * 3 / 100).round())
                                .toInt());
                      }
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
                SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    Text(
                      'Affatto',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Occasionale',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Settimanale',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Quotidiana',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: BColors.colorPrimary,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                      value: _sportsSliderValue,
                      min: 0,
                      max: 100,
                      divisions: 3,
                      onChanged: (double value) {
                        setState(() {
                          _sportsSliderValue = value;
                          _sportsActivitySelected = _sportsActivity.elementAt(
                              ((value * 3 / 100).round()));
                        });
                      },
                      onChangeEnd: (newValue) {
                        PreferenceManager.updateUserInfo(
                            sportsActivity: ((newValue * 3 / 100).round())
                                .toInt());
                      }
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
