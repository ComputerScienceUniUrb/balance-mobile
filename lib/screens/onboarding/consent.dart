
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Second intro screen
///
/// This Widget represents the first of the intro
/// screens, his purpose is to display a welcome
/// message to the user and explain the app.
class ConsentScreen extends StatelessWidget {
  /// Index of the screen
  final int screenIndex;
  bool checkedValue = false;

  ConsentScreen(this.screenIndex);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) => current is NeedToValidateState && current.index == screenIndex,
      // This page is always valid
      listener: (context, _) => context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent()),
      child: Center(
        child: SingleChildScrollView(
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'privacy_declaration_title'.tr(),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'privacy_declaration_first_txt'.tr(),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('privacy_declaration_second_txt'.tr(),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('privacy_declaration_third_txt'.tr()),
              ),
              SizedBox(height: 128)
            ],
          ),
        ),
      ),
    );
  }
}