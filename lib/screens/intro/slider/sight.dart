
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';
import 'package:group_button/group_button.dart';

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
  final bool wearGlasses;
  final int hearingProblems;
  final int hearingLoss;


  SightScreen(this.screenIndex, {
    this.sight,
    this.wearGlasses,
    this.hearingProblems,
    this.hearingLoss,
  });

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sightDefects = ['myopia_txt'.tr(), 'presbyopia_txt'.tr(), 'farsightedness_txt'.tr(), 'astigmatism_txt'.tr()];
  bool _wearGlasses = false;
  List<bool> _selectedSightProblem;
  final _whichHear = ['none'.tr(), "Destro", "Sinistro", "Entrambi"];
  final _hearDefects = ['none'.tr(), 'light_txt'.tr(), 'moderate_txt'.tr(), 'severe_txt'.tr(), 'deep_txt'.tr()];
  int _hearProblemsIndex;
  int _hearLossIndex;

  @override
  void initState() {
    super.initState();
    _selectedSightProblem = widget.sight;
    _wearGlasses = widget.wearGlasses ?? false;
    _hearProblemsIndex = widget.hearingProblems ?? 0;
    _hearLossIndex = widget.hearingLoss ?? 0;
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
                  'sight_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Indossi Occhiali?",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 18,
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
                SizedBox(height: 32),
                Text(
                  'intro_hearing_defects_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize:32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Hai problemi d'udito?",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: GroupButton(
                      isRadio: false,
                      spacing: 10,
                      onSelected: (index, isSelected) {
                        print('$index button is selected');
                      },
                      buttons: ["Orecchio Dx", "Orecchio Sx"],
                      selectedColor: BColors.colorPrimary,

                    ),
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
