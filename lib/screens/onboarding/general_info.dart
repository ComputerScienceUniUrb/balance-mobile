
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/res/colors.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/widgets/custom_number_form_field.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Fourth intro screen
///
/// This Widget represents the fourth of the intro
/// screens, his purpose is to ask the user his age,
/// his gender and is weight.
/// The user can leave blank this info.
class GeneralInfoScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final String age;
  final int gender;
  final String weight;

  GeneralInfoScreen(this.screenIndex, {
    this.age,
    this.gender,
    this.weight
  });

  @override
  _GeneralInfoScreenState createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _genders = ['unknown_txt'.tr(), 'male_txt'.tr(), 'female_txt'.tr()];
  int _genderIndex;

  @override
  void initState() {
    super.initState();
    _genderIndex = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) =>  current is NeedToValidateState && current.index == widget.screenIndex,
      listener: (context, state) {
        final isValid = _formKey.currentState.validate();
        if (isValid) {
          _formKey.currentState.save();
          context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent());
        }
        print("_GeneralInfoScreenState.build: General info are ${isValid? "valid": "invalid"}");
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          reverse: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Image.asset(
                  "assets/images/eta.png",
                )
              ),
              Text(
                'intro_general_title'.tr(),
                style: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomNumberFormField(
                        labelText: 'age_txt'.tr(),
                        initialValue: widget.age,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            try {
                              int age = int.parse(value);
                              if (age <= 0)
                                return 'invalid_age_txt'.tr();
                              else if (age > 130)
                                return 'too_old_error_txt'.tr();
                            } on FormatException catch(_) {
                              return 'invalid_age_txt'.tr();
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue.isNotEmpty)
                            try {
                              PreferenceManager.updateUserInfo(age: int.parse(newValue));
                            } on FormatException catch(e) {
                              print("Some error occurred saving age data: ${e.message}");
                            }
                        },
                      ),
                      SizedBox(height: 8),
                      CustomDropdownFormField(
                        hint: 'gender_txt'.tr(),
                        value: _genderIndex,
                        onChanged: (newValue) {
                          setState(() => _genderIndex = newValue);
                        },
                        items: _genders.map((e) => CustomDropdownItem(text: e)).toList(),
                        openColor: Color(0xFFF4F6F9),
                        enabledColor: Colors.white,
                        enableTextColor: Color(0xFFBFBFBF),
                        elementTextColor: Color(0xFF666666),
                        enabledIconColor: BColors.colorPrimary,
                        validator: (_) => null,
                        onSaved: (newValue) => PreferenceManager.updateUserInfo(gender: newValue ?? 0),
                      ),
                      SizedBox(height: 8),
                      CustomNumberFormField(
                        labelText: 'weight_txt'.tr(),
                        initialValue: widget.weight,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            try {
                              int weight = int.parse(value);
                              if (weight < 25.0)
                                return 'too_light_error_txt'.tr();
                              else if (weight > 580.0)
                                return 'too_heavy_error_txt'.tr();
                            } on FormatException catch(_) {
                              return 'invalid_weight_txt'.tr();
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue.isNotEmpty)
                            try {
                              PreferenceManager.updateUserInfo(weight: int.parse(newValue));
                            } on FormatException catch(e) {
                              print("Some error occurred saving weight data: ${e.message}");
                            }
                        },
                      ),
                      SizedBox(height: 75),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}