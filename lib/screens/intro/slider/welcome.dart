
import 'package:balance_app/manager/preference_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';

/// First intro screen
///
/// This Widget represents the first of the intro
/// screens, his purpose is to display a welcome
/// message to the user and explain the app.
class WelcomeScreen extends StatelessWidget {
  /// Index of the screen
  final int screenIndex;
  WelcomeScreen(this.screenIndex);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) => current is NeedToValidateState && current.index == screenIndex,
      // This page is always valid
      listener: (context, _) => context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent()),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
            ],
          ),
        ),
      ),
    );
  }
}