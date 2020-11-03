
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Fourth intro screen
///
/// This Widget represents the Fourth of the intro
/// screens, his purpose is to ask the user if he has
/// some postural problems and if there are in his family
/// or if he use some drugs that can interfere with the
/// posture.
/// The user can leave blank this info.
class PostureScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final List<bool> posture;
  final bool problemsInFamily;
  final bool useOfDrugs;

  PostureScreen(this.screenIndex, {
    this.posture,
    this.problemsInFamily,
    this.useOfDrugs,
  });

  @override
  _PostureScreenState createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _postureProblems = ['scoliosis_txt'.tr(), 'kyphosis_txt'.tr(), 'lordosis_txt'.tr()];
  List<bool> _selectedPosture;
  bool _problemsInFamily = false;
  bool _useOfDrugs = false;

  @override
  void initState() {
    super.initState();
    _selectedPosture = widget.posture;
    _problemsInFamily = widget.problemsInFamily ?? false;
    _useOfDrugs = widget.useOfDrugs ?? false;
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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'postural_problem_title'.tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                CheckboxGroupFormField(
                  items: _postureProblems,
                  validator: (value) => null,
                  onSaved: (newValue) => PreferenceManager.updateUserInfo(
                    posturalProblems: newValue ?? List.filled(3, false)
                  ),
                  value: _selectedPosture,
                  onChanged: (value) => setState(() {
                    _selectedPosture = value;
                  }),
                ),
                SizedBox(height: 24),
                PlainCheckboxFormField(
                  child: Text(
                    'postural_problem_in_family_title'.tr(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  value: _problemsInFamily,
                  onChanged: (value) => setState(() => _problemsInFamily = value),
                  validator: (value) => null,
                  onSaved: (newValue) => PreferenceManager.updateUserInfo(problemsInFamily: newValue),
                ),
                SizedBox(height: 20),
                PlainCheckboxFormField(
                  child: Text(
                    'use_of_drugs_title'.tr(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  value: _useOfDrugs,
                  onChanged: (value) => setState(() => _useOfDrugs = value),
                  validator: (value) => null,
                  onSaved: (newValue) => PreferenceManager.updateUserInfo(useOfDrugs: newValue),
                ),
                SizedBox(height: 105)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
