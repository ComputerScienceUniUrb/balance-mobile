
import 'package:balance_app/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';


/// First intro screen
///
/// This Widget represents the first of the intro screens,
/// his purpose is to display and ask for the consent.
class ConsentScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final ValueChanged<bool> enableNextBtnCallback;

  ConsentScreen(this.screenIndex, this.enableNextBtnCallback);

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _formKey = GlobalKey<FormState>();

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
        print("_ConsentScreenState.build: The consent has been accepted");
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_title'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_finality_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_finality_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_jury_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                            'privacy_jury_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_data_handling_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                            'privacy_data_handling_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_data_nature_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                            'privacy_data_nature_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_data_abroad_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_data_abroad_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_data_spread_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                            'privacy_data_spread_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_rights_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                            'privacy_rights_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_first_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_first_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_second_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_second_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_third_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_third_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_fourth_title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'privacy_collection_fourth_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text('privacy_declaration_first_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),),
                      value: state.consent_1 ?? false,
                      activeColor: BColors.colorPrimary,
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptConsent(consent_1: value));
                      },
                    ),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text('privacy_declaration_second_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),),
                      value: state.consent_2 ?? false,
                      activeColor: BColors.colorPrimary,
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptConsent(consent_2: value));
                      },
                    ),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text('privacy_declaration_third_txt'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),),
                      value: state.consent_3 ?? false,
                      activeColor: BColors.colorPrimary,
                      onChanged: (value) {
                        // Enable/Disable the next button if the text field is empty
                        context
                            .bloc<OnBoardingDataBloc>()
                            .add(acceptConsent(consent_3: value));
                      },
                    ),
                    SizedBox(height: 128)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
