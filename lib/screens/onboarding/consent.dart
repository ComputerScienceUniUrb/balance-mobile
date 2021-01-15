
import 'package:balance_app/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';


/// First intro screen
///
/// This Widget represents the first of the intro screens,
/// his purpose is to display and ask for the consent.
class ConsentScreen extends StatefulWidget {
  /// Index of the screen
  final int screenIndex;
  final ValueChanged<bool> enableNextBtnCallback;
  final bool checkbox_1;
  final bool checkbox_2;
  final bool checkbox_3;

  ConsentScreen(this.screenIndex, this.enableNextBtnCallback, {
    this.checkbox_1,
    this.checkbox_2,
    this.checkbox_3,
  });

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _checkbox_1;
  bool _checkbox_2;
  bool _checkbox_3;

  @override
  void initState() {
    super.initState();
    _checkbox_1 = widget.checkbox_1 ?? false;
    _checkbox_2 = widget.checkbox_2 ?? false;
    _checkbox_3 = widget.checkbox_3 ?? false;
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
        print("_ConsentScreenState.build: The consent has been accepted");
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
                  value: _checkbox_1,
                  activeColor: BColors.colorPrimary,
                  onChanged: (value) {
                    setState(() {
                      _checkbox_1 = value; // rebuilds with new value
                    });
                    // Enable/Disable the next button if the text field is empty
                    if (_checkbox_1 && _checkbox_2 && _checkbox_3) {
                      widget.enableNextBtnCallback(true);
                    } else {
                      widget.enableNextBtnCallback(false);
                    }
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
                  value: _checkbox_2,
                  activeColor: BColors.colorPrimary,
                  onChanged: (value) {
                    setState(() {
                      _checkbox_2 = value; // rebuilds with new value
                    });
                    // Enable/Disable the next button if the text field is empty
                    if (_checkbox_1 && _checkbox_2 && _checkbox_3) {
                      widget.enableNextBtnCallback(true);
                    } else {
                      widget.enableNextBtnCallback(false);
                    }
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
                  value: _checkbox_3,
                  activeColor: BColors.colorPrimary,
                  onChanged: (value) {
                    setState(() {
                      _checkbox_3 = value; // rebuilds with new value
                    });
                    // Enable/Disable the next button if the text field is empty
                    if (_checkbox_1 && _checkbox_2 && _checkbox_3) {
                      widget.enableNextBtnCallback(true);
                    } else {
                      widget.enableNextBtnCallback(false);
                    }
                  },
                ),
                SizedBox(height: 128)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
