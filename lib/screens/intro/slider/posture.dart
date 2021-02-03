
import 'package:balance_app/screens/intro/slider/widgets/about_balance_dialog.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_switch.dart';
import 'package:balance_app/screens/intro/slider/widgets/info_widget.dart';
import 'package:balance_app/screens/res/b_icons.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_checkbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  final ValueChanged<bool> enableNextBtnCallback;

  PostureScreen(this.screenIndex, this.enableNextBtnCallback, {
    this.posture,
    this.problemsInFamily,
  });

  @override
  _PostureScreenState createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _postureProblems = ['scoliosis_txt'.tr(), 'kyphosis_txt'.tr(), 'lordosis_txt'.tr()];
  List<bool> _selectedPosture;
  final _physicalTrauma = ['fractures_txt'.tr(), 'limb_operations_txt'.tr(), 'falls_txt'.tr(), 'distortions_txt'.tr(), 'head_trauma'.tr()];
  List<bool> _selectedTrauma;
  bool _postureVisibility;
  bool _traumaVisibility;
  bool _inheritance;

  @override
  void initState() {
    super.initState();
    _selectedPosture = widget.posture ?? [false, false, false];
    _selectedTrauma = [false, false, false, false, false];
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 64),
                Text(
                  'Condizione fisica',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'postural_problem_title'.tr(),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    CustomToggleButton(
                      onChanged: (selected) {
                        setState(() {
                          _postureVisibility = selected != 0 ? true : false;
                        });
                        PreferenceManager.updateUserInfo(problemsInFamily: selected != 0 ? true : false);
                        if (_postureVisibility != null && _traumaVisibility != null && _inheritance != null) {
                          widget.enableNextBtnCallback(true);
                        } else {
                          widget.enableNextBtnCallback(false);
                        }
                      },
                      leftText: Text('no'.tr()),
                      rightText: Text('yes'.tr()),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: _postureVisibility ?? false,
                  child: CheckboxGroupFormField(
                    items: _postureProblems,
                    validator: (value) => null,
                    onSaved: (newValue) => PreferenceManager.updateUserInfo(posturalProblems: newValue ?? List.filled(3, false)),
                    value: _selectedPosture,
                    onChanged: (value) => setState(() => _selectedPosture = value),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'postural_problem_in_family_title'.tr(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomToggleButton(
                      onChanged: (selected) {
                        setState(() => _inheritance = selected != 0 ? true : false);
                        PreferenceManager.updateUserInfo(problemsInFamily: selected != 0 ? true : false);
                        // Enable/Disable the next button if the text field is empty
                        if (_postureVisibility != null && _traumaVisibility != null && _inheritance != null) {
                          widget.enableNextBtnCallback(true);
                        } else {
                          widget.enableNextBtnCallback(false);
                        }
                      },
                      leftText: Text('no'.tr()),
                      rightText: Text('yes'.tr()),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Hai subito precedenti traumi?',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomToggleButton(
                      onChanged: (selected) {
                        setState(() => _traumaVisibility = selected != 0 ? true : false);
                        // Enable/Disable the next button if the text field is empty
                        if (_postureVisibility != null && _traumaVisibility != null && _inheritance != null) {
                          widget.enableNextBtnCallback(true);
                        } else {
                          widget.enableNextBtnCallback(false);
                        }
                      },
                      leftText: Text('no'.tr()),
                      rightText: Text('yes'.tr()),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: _traumaVisibility ?? false,
                  child: CheckboxGroupFormField(
                    items: _physicalTrauma,
                    value: _selectedTrauma,
                    onChanged: (value) {
                      setState(() =>_selectedTrauma = value);
                    },
                    validator: (value) => null,
                    onSaved: (newValue) => PreferenceManager.updateUserInfo(
                        physicalTrauma: newValue?? List.filled(5, false)
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InfoElement(
                  icon: Icon(BIcons.info_outline),
                  text: 'Informazioni sui dati richiesti',
                  onTap: () => showDataInfoDialog(context),
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
