
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/res/colors.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:balance_app/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Sixth intro screen
///
/// This Widget represents the sixth of the intro
/// screens, his purpose is to ask the user if he
/// has some sight problem or hearing problem.
/// The user can leave blank this info.
class SightScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final List<bool> sight;
  final int hearing;

  SightScreen(this.screenIndex, {
    this.sight,
    this.hearing,
  });

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sightDefects = ['myopia_txt'.tr(), 'presbyopia_txt'.tr(), 'farsightedness_txt'.tr()];
  final _hearDefects = ['none'.tr(), 'light_txt'.tr(), 'moderate_txt'.tr(), 'severe_txt'.tr(), 'deep_txt'.tr()];
  List<bool> _selectedSightProblem;
  int _hearIndex;

  @override
  void initState() {
    super.initState();
    _selectedSightProblem = widget.sight;
    _hearIndex = widget.hearing ?? 0;
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 64),
                Text(
                  'sight_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                CheckboxGroupFormField(
                  items: _sightDefects,
                  value: _selectedSightProblem,
                  onChanged: (value) => setState(() => _selectedSightProblem = value),
                  validator: (value) => null,
                  onSaved: (newValue) => PreferenceManager.updateUserInfo(
                    sightProblems: newValue?? List.filled(3, false)
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'intro_hearing_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                CustomDropdownFormField(
                  hint: 'hearing_loss_hint'.tr(),
                  value: _hearIndex,
                  onChanged: (newValue) {
                    setState(() => _hearIndex = newValue);
                  },
                  items: _hearDefects.map((e) => CustomDropdownItem(text: e.toString())).toList(),
                  openColor: Color(0xFFF4F6F9),
                  enabledColor: Colors.white,
                  enableTextColor: Color(0xFFBFBFBF),
                  elementTextColor: Color(0xFF666666),
                  enabledIconColor: BColors.colorPrimary,
                  validator: (_) => null,
                  onSaved: (newValue) => PreferenceManager.updateUserInfo(hearingProblems: newValue ?? 0),
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
