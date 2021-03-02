
import 'package:balance_app/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';


/// First intro screen
///
/// This Widget represents the first of the intro screens,
/// his purpose is to display and ask for the consent.
class WelcomeScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;

  WelcomeScreen(this.screenIndex);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
        print("_WelcomeScreenState.build: The welcome screen has passed");
      },
      child: BlocBuilder<OnBoardingDataBloc, OnBoardingData>(
        builder: (ctx, state) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Form(
            key: _formKey,
            child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 64),
                    Center(
                      child: Image.asset(
                        "assets/app_logo_circle.png",
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'welcome_to_balance_title'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'welcome_to_balance_msg'.tr(),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 128),
                  ],
                )
              ),
            ),
          );
        },
      ),
    );
  }
}
