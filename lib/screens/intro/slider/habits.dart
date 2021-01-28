
import 'package:balance_app/screens/intro/slider/widgets/lite_rolling_switch.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_checkbox.dart';

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
  final List<bool> posture;
  final bool problemsInFamily;
  final bool useOfDrugs;
  final String medicines;
  final int alcoholIntake;
  final int alcoholIndex;
  final int sportsActivity;
  final ValueChanged<bool> enableNextBtnCallback;

  HabitsScreen(this.screenIndex, this.enableNextBtnCallback, {
    this.posture,
    this.problemsInFamily,
    this.useOfDrugs,
    this.medicines,
    this.alcoholIntake,
    this.alcoholIndex,
    this.sportsActivity,
  });

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _alcoholIntake = ['Astemio', 'Occasionale', 'Ai Pasti', 'Fuori Pasto'];
  String _alcoholSelected;
  final _sportsActivity = ['Affatto', 'Occasionale', 'Settimanale', 'Quotidiano'];
  double _sportsSliderValue = 0;
  String _sportsActivitySelected;
  List<bool> _selectedPosture;
  bool _useOfDrugs;
  int _alcoholIndex;
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _selectedPosture = widget.posture;
    _useOfDrugs = widget.useOfDrugs ?? false;
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 64),
              Text(
                'habits_title'.tr(),
                style: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        text: 'use_of_drugs_txt'.tr(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  LiteRollingSwitch(
                      value: false,
                      textOn: 'Si',
                      textOff: 'No',
                      colorOn: Colors.indigoAccent,
                      colorOff: Colors.white70,
                      iconOn: Icons.done,
                      iconOff: Icons.remove_circle_outline,
                      textSize: 16.0,
                      onChanged: (bool state) {
                        PreferenceManager.updateUserInfo(useOfDrugs: state);
                        _useOfDrugs = state;
                      }
                  ),
                ],
              ),
              SizedBox(height: 36),
              Text(
                'use_of_alcohol'.tr(),
                style: Theme.of(context).textTheme.headline4.copyWith(
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
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Occasionale',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Ai Pasti',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Fuori Pasto',
                    style: Theme.of(context).textTheme.headline4.copyWith(
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
                      _alcoholSelected = _alcoholIntake.elementAt(((value*3/100).round()));
                    });
                  },
                  onChangeEnd: (newValue) {
                    PreferenceManager.updateUserInfo(alcoholIntake: ((newValue*3/100).round()).toInt());
                  }
                ),
              ),
              SizedBox(height: 36),
              Text(
                'Svolgi attività motoria?',
                style: Theme.of(context).textTheme.headline4.copyWith(
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
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Occasionale',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Settimanale',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Quotidiana',
                    style: Theme.of(context).textTheme.headline4.copyWith(
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
                        _sportsActivitySelected = _sportsActivity.elementAt(((value*3/100).round()));
                      });
                    },
                    onChangeEnd: (newValue) {
                      PreferenceManager.updateUserInfo(sportsActivity: ((newValue*3/100).round()).toInt());
                    }
                ),
              ),
              SizedBox(height: 105)
            ],
          ),
        ),
      ),
    );
  }
}
