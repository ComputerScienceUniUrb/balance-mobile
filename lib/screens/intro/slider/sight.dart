
import 'package:balance/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance/screens/intro/slider/widgets/custom_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/screens/intro/slider/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/intro/onboarding_bloc.dart';

/// Sixth intro screen
///
/// This Widget represents the sixth of the intro
/// screens, his purpose is to ask the user if he
/// has some sight problem or hearing problem.
/// The user can leave blank this info.
class SightScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;

  SightScreen(this.screenIndex);

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {
  final _formKey = GlobalKey<FormState>();

  final _visionProblems = ['myopia_txt'.tr(), 'presbyopia_txt'.tr(), 'farsightedness_txt'.tr(), 'astigmatism_txt'.tr()];
  final _hearingProblems = ['right_txt'.tr(), 'left_txt'.tr()];

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
      child: BlocBuilder<OnBoardingDataBloc, OnBoardingData>(
      builder: (ctx, state) {
        return SafeArea(
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4
                        .copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "hearing_issues_txt".tr(),
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
                        ),
                        CustomToggleButton(
                          initial: state.hearingLoss,
                          onChanged: (selected) {
                            // Enable/Disable the next button if the text field is empty
                            context
                                .bloc<OnBoardingDataBloc>()
                                .add(acceptSight(hearingLoss: selected));
                            PreferenceManager.updateUserInfo(
                                hearingLoss: selected == 1 ? true : false);

                            if (selected == 0) {
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptSight(hearingProblems: List.filled(2, false)));
                              PreferenceManager.updateUserInfo(hearingProblems: List.filled(2, false));
                            }
                          },
                          leftText: Text('no'.tr()),
                          rightText: Text('yes'.tr()),
                        ),
                      ]
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: state.hearingLoss == 1 ? true : false,
                    child: CheckboxGroupFormField(
                      items: _hearingProblems,
                      value: state.hearingProblems ?? List.filled(2, false),
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptSight(hearingProblems: value));
                      },
                      validator: (value) => null,
                      onSaved: (newValue) =>
                          PreferenceManager.updateUserInfo(
                              hearingProblems: newValue ?? List.filled(3, false)),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'sight_defects_title'.tr(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4
                        .copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "sight_issues_txt".tr(),
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
                        CustomToggleButton(
                          initial: state.visionLoss,
                          onChanged: (selected) {
                            // Enable/Disable the next button if the text field is empty
                            context
                                .bloc<OnBoardingDataBloc>()
                                .add(acceptSight(visionLoss: selected));
                            PreferenceManager.updateUserInfo(
                                visionLoss: selected == 1 ? true : false);

                            if (selected == 0) {
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptSight(visionProblems: List.filled(4, false)));
                              PreferenceManager.updateUserInfo(visionProblems: List.filled(4, false));
                            }
                          },
                          leftText: Text('no'.tr()),
                          rightText: Text('yes'.tr()),
                        ),
                      ]
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: state.visionLoss == 1 ? true : false,
                    child: CheckboxGroupFormField(
                      items: _visionProblems,
                      value: state.visionProblems ?? List.filled(4, false),
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptSight(visionProblems: value));
                      },
                      validator: (value) => null,
                      onSaved: (newValue) =>
                          PreferenceManager.updateUserInfo(
                              visionProblems: newValue ?? List.filled(3, false)),
                    ),
                  ),
                  SizedBox(height: 105),
                ],
              ),
            ),
          ),
        );
      }
    ));
  }
}
