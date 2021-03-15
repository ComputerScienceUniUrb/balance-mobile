
import 'package:balance/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance/screens/intro/slider/widgets/about_balance_dialog.dart';
import 'package:balance/screens/intro/slider/widgets/custom_switch.dart';
import 'package:balance/screens/intro/slider/widgets/info_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/screens/intro/slider/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/intro/onboarding_bloc.dart';

/// Fifth intro screen
///
/// This Widget represents the Fifth of the intro
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

  PostureScreen(this.screenIndex, {
    this.posture,
    this.problemsInFamily,
  });

  @override
  _PostureScreenState createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _postureProblems = ['scoliosis_txt'.tr(), 'kyphosis_txt'.tr(), 'lordosis_txt'.tr()];
  final _physicalTrauma = ['fractures_txt'.tr(), 'limb_operations_txt'.tr(), 'falls_txt'.tr(), 'distortions_txt'.tr(), 'head_trauma'.tr()];

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
                    'posture_title'.tr(),
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
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'postural_problem_title'.tr(),
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CustomToggleButton(
                          initial: state.postureCondition,
                          onChanged: (selected) {
                            // Enable/Disable the next button if the text field is empty
                            context
                                .bloc<OnBoardingDataBloc>()
                                .add(acceptPosture(postureCondition: selected));

                            if (selected == 0) {
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptPosture(posturalProblems: List.filled(3, false)));
                              PreferenceManager.updateUserInfo(posturalProblems: List.filled(3, false));
                            }
                          },
                          leftText: Text('no'.tr()),
                          rightText: Text('yes'.tr()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: state.postureCondition == 1 ? true : false,
                    child: CheckboxGroupFormField(
                      items: _postureProblems,
                      validator: (value) => null,
                      onSaved: (newValue) =>
                          PreferenceManager.updateUserInfo(
                              posturalProblems: newValue ??
                                  List.filled(3, false)),
                      value: state.posturalProblems ?? List.filled(3, false),
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptPosture(posturalProblems: value));
                      }
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'postural_problem_in_family_title'.tr(),
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CustomToggleButton(
                          initial: state.problemsInFamily,
                          onChanged: (selected) {
                            // Enable/Disable the next button if the text field is empty
                            context
                                .bloc<OnBoardingDataBloc>()
                                .add(acceptPosture(problemsInFamily: selected));
                            PreferenceManager.updateUserInfo(problemsInFamily: selected != 0 ? true : false);
                          },
                          leftText: Text('no'.tr()),
                          rightText: Text('yes'.tr()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'previous_trauma_title'.tr(),
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CustomToggleButton(
                          initial: state.previousTrauma,
                          onChanged: (selected) {
                            // Enable/Disable the next button if the text field is empty
                            context
                                .bloc<OnBoardingDataBloc>()
                                .add(acceptPosture(previousTrauma: selected));

                            if (selected == 0) {
                              context
                                  .bloc<OnBoardingDataBloc>()
                                  .add(acceptPosture(traumas: List.filled(5, false)));
                              PreferenceManager.updateUserInfo(physicalTrauma: List.filled(5, false));
                            }
                          },
                          leftText: Text('no'.tr()),
                          rightText: Text('yes'.tr()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: state.previousTrauma == 1 ? true : false,
                    child: CheckboxGroupFormField(
                      items: _physicalTrauma,
                      value: state.traumas ?? List.filled(5, false),
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptPosture(traumas: value));
                      },
                      validator: (value) => null,
                      onSaved: (newValue) =>
                          PreferenceManager.updateUserInfo(
                              physicalTrauma: newValue ?? List.filled(5, false)
                          ),
                    ),
                  ),
                  SizedBox(height: 16),
                  InfoElement(
                    icon: Icon(Icons.info_outline_rounded, color: Colors.white),
                    text: 'info_trauma_dialog'.tr(),
                    onTap: () => showDataInfoDialog(context),
                  ),
                  SizedBox(height: 105)
                ],
              ),
            ),
          ),
        );
      }
    ));
  }
}
