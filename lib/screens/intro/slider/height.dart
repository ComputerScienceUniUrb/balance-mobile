
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_number_form_field.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/screens/intro/bloc/onboarding_bloc.dart';

/// Third intro screen
///
/// This Widget represents the third of the intro
/// screens, his purpose is to ask the user his
/// height letting him know why ke need such
/// information; the user cannot skip this step.
class HeightScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final ValueChanged<bool> enableNextBtnCallback;
  final String height;

  HeightScreen(this.screenIndex, this.enableNextBtnCallback, {this.height});

  @override
  _HeightScreenState createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _canGoNext = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) => current is NeedToValidateState && current.index == widget.screenIndex,
      listener: (context, state) {
        // Validate and save height data
        bool isValid = _formKey.currentState.validate();
        if (isValid) {
          _formKey.currentState.save();
          context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent());
        }
        print("_HeightScreenState.build: Height data is ${isValid? 'valid': 'invalid'}");
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(
                  child: Image.asset("assets/images/height.png"),
                ),
              ),
              Text(
                'intro_height_title'.tr(),
                style: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize:28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'intro_height_msg'.tr(),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formKey,
                  child: CustomNumberFormField(
                    labelText: 'height_txt'.tr(),
                    suffix: "cm",
                    initialValue: widget.height,
                    onChanged: (isNotEmpty) {
                      // Enable/Disable the next button if the text field is empty
                      if (isNotEmpty && !_canGoNext) {
                        _canGoNext = true;
                        widget.enableNextBtnCallback(true);
                      } else if (!isNotEmpty && _canGoNext) {
                        _canGoNext = false;
                        widget.enableNextBtnCallback(false);
                      }
                    },
                    validator: (value) {
                      try {
                        double height = double.parse(value);
                        if (height < 50)
                          return 'too_short_error_txt'.tr();
                        else if (height > 240)
                          return 'too_tall_error_txt'.tr();
                        else
                          return null;
                      } on FormatException catch(_) {
                        return 'invalid_height_error_txt'.tr();
                      }
                    },
                    onSaved: (newValue) {
                      try {
                        PreferenceManager.updateUserInfo(height: int.parse(newValue));
                      } on FormatException catch(e) {
                        print("Some error occurred saving height data: ${e.message}");
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
