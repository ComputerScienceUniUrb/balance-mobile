
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';
import 'package:balance_app/screens/intro/slider/widgets/lite_rolling_switch.dart';

/// Sixth intro screen
///
/// This Widget represents the sixth of the intro
/// screens, his purpose is to ask the user if he
/// has some sight problem or hearing problem.
/// The user can leave blank this info.
class SightScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  /// Data of the Screen
  final bool visionLoss;
  final List<bool> visionProblems;
  final bool hearingLoss;
  final List<bool> hearingProblems;
  final hearingVisibility;
  final visionVisibility;

  SightScreen(this.screenIndex, {
    this.visionLoss,
    this.visionProblems,
    this.hearingLoss,
    this.hearingProblems,
    this.hearingVisibility,
    this.visionVisibility,
  });

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _visionLoss = false;
  final _visionProblems = ['myopia_txt'.tr(), 'presbyopia_txt'.tr(), 'farsightedness_txt'.tr(), 'astigmatism_txt'.tr()];
  List<bool> _selectedVisionProblems;
  bool _hearingLoss;
  final _hearingProblems = ["Destro", "Sinistro"];
  List<bool> _selectedHearingProblems;
  bool _hearingVisibility;
  bool _visionVisibility;
  bool builded1 = false;
  bool builded2 = false;

  @override
  void initState() {
    super.initState();
    _visionLoss = widget.visionLoss ?? false;
    _selectedVisionProblems = widget.visionProblems ?? [false, false, false, false];
    _hearingLoss = widget.hearingLoss ?? false;
    _selectedHearingProblems = widget.hearingProblems ?? [false, false];
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
        print("_SightScreenState.build: Sight and Hearing info are ${isValid? "valid": "invalid"}");
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 64),
                Text(
                  'intro_hearing_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize:32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                    children: <Widget>[
                      Text(
                        "Hai problemi d'udito?",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize:18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      LiteRollingSwitch(
                        //initial value
                        value: false,
                        textOn: 'Si',
                        textOff: 'No',
                        colorOn: Colors.indigoAccent,
                        colorOff: Colors.white70,
                        iconOn: Icons.done,
                        iconOff: Icons.remove_circle_outline,
                        textSize: 16.0,
                        onChanged: (bool state) {
                          PreferenceManager.updateUserInfo(hearingLoss: state);
                          if (_hearingVisibility != null || builded1)
                            setState(() => _hearingVisibility = state);
                          else
                            builded1 = true;
                        }
                      ),
                    ]
                ),
                SizedBox(height: 24),
                Visibility(
                  visible: _hearingVisibility ?? false,
                  child: CheckboxGroupFormField(
                    items: _hearingProblems,
                    value: _selectedHearingProblems,
                    onChanged: (value) => setState(() =>  _selectedHearingProblems = value),
                    validator: (value) => null,
                    onSaved: (newValue) => PreferenceManager.updateUserInfo(hearingProblems: newValue?? List.filled(3, false)),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'sight_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    Text(
                      "Indossi Occhiali?",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    LiteRollingSwitch(
                      //initial value
                      value: false,
                      textOn: 'Si',
                      textOff: 'No',
                      colorOn: Colors.indigoAccent,
                      colorOff: Colors.white70,
                      iconOn: Icons.done,
                      iconOff: Icons.remove_circle_outline,
                      textSize: 16.0,
                      onChanged: (bool state) {
                        PreferenceManager.updateUserInfo(visionLoss: state);
                        if (_visionVisibility != null || builded2)
                          setState(() => _visionVisibility = state);
                        else
                          builded2 = true;
                      }
                    ),
                  ]
                ),
                SizedBox(height: 24),
                Visibility(
                  visible: _visionVisibility ?? false,
                  child: CheckboxGroupFormField(
                      items: _visionProblems,
                      value: _selectedVisionProblems,
                      onChanged: (value) => setState(() => _selectedVisionProblems = value),
                      validator: (value) => null,
                      onSaved: (newValue) => PreferenceManager.updateUserInfo(visionProblems: newValue?? List.filled(3, false)),
                    ),
                ),
                SizedBox(height: 105),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
