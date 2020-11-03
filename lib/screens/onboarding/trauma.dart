
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Fifth intro screen
///
/// This Widget represents the fifth of the intro
/// screens, his purpose is to ask the user if he
/// had some trauma like broken bones, head trauma
/// or other.
/// The user can leave blank this info.
class TraumaScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final List<bool> trauma;

  TraumaScreen(this.screenIndex, {
    this.trauma,
  });

  @override
  _TraumaScreenState createState() => _TraumaScreenState();
}

class _TraumaScreenState extends State<TraumaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otherTrauma = ['fractures_txt'.tr(), 'limb_operations_txt'.tr(), 'falls_txt'.tr(), 'distortions_txt'.tr(), 'head_trauma'.tr()];
  List<bool> _selectedTrauma;

  @override
  void initState() {
    super.initState();
    _selectedTrauma = widget.trauma;
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
        print("_TraumaScreenState.build: Trauma info are ${isValid? "valid": "invalid"}");
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              'other_trauma_title'.tr(),
              style: Theme.of(context).textTheme.headline4.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Form(
              key: _formKey,
              child: CheckboxGroupFormField(
                items: _otherTrauma,
                value: _selectedTrauma,
                onChanged: (value) {
                  setState(() =>_selectedTrauma = value);
                },
                validator: (value) => null,
                onSaved: (newValue) => PreferenceManager.updateUserInfo(
                  otherTrauma: newValue?? List.filled(5, false)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
