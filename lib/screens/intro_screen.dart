
import 'dart:convert';

import 'package:balance_app/manager/preference_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:balance_app/routes.dart';
import 'package:balance_app/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balance_app/res/colors.dart';
import 'package:balance_app/widgets/dots_indicator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';
import 'package:http/http.dart';

import 'onboarding/welcome.dart';
import 'onboarding/consent.dart';
import 'onboarding/height.dart';
import 'onboarding/general_info.dart';
import 'onboarding/posture.dart';
import 'onboarding/trauma.dart';
import 'onboarding/habits.dart';
import 'onboarding/sight.dart';

/// This class show an introduction when the app is first open.
class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isNextBtnEnable = true;
  List<Color> _pageColors = [
    BColors.colorPrimary,
    Color(0xFF398AA7),
    Color(0xFF36836C),
    Color(0xFB93936C),
    Color(0xffF2BB25),
    Color(0xFFC95E4B),
    Color(0xFB939AA7),
    Color(0xFF398AA7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider<OnBoardingBloc>(
        create: (context) => OnBoardingBloc.create(),
        child: Builder(
          builder: (context) =>
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  // Main page view
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    color: _pageColors[_currentPage],
                    child: BlocListener<OnBoardingBloc, OnBoardingState>(
                      condition: (_, current) => current is ValidationSuccessState,
                      listener: (context, _) async {
                        FocusScope.of(context).unfocus();

                        // If we are in the last page go to home
                        if (_currentPage == 7) {
                          PreferenceManager.firstLaunchDone();
                          _makePostRequest(jsonEncode(await PreferenceManager.userInfo));
                          Navigator.pushReplacementNamed(context, Routes.main);
                        } else {
                          /*
                            * All the required data are stored... mark the
                            * first launch as done so we don't ask this data anymore
                            */
                          // Move to next page
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.ease
                          );
                        }
                      },
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (newPage) =>
                          setState(() {
                            _currentPage = newPage;
                            if (newPage == 1 || newPage == 2)
                              _isNextBtnEnable = false;
                          }),
                        children: [
                          WelcomeScreen(0),
                          ConsentScreen(1, (isEnable) =>
                              setState(() => _isNextBtnEnable = isEnable)),
                          HeightScreen(2, (isEnable) =>
                            setState(() => _isNextBtnEnable = isEnable)),
                          GeneralInfoScreen(3),
                          PostureScreen(4),
                          TraumaScreen(5),
                          HabitsScreen(6),
                          SightScreen(7),
                        ],
                      ),
                    ),
                  ),
                  // Bottom bar with progress, skip and next button
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    color: _pageColors[_currentPage],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DotsIndicator(
                          size: 8,
                          selected: _currentPage,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 270),
                          height: 64,
                          child: Row(children: <Widget>[
                            NextButton(
                              onTap: () =>
                                BlocProvider.of<OnBoardingBloc>(context).add(
                                  NeedToValidateEvent(_currentPage)),
                              isEnable: _isNextBtnEnable,
                              isDone: _currentPage == 7,
                              backgroundColor: (_currentPage == 0) ? BColors.colorAccent : BColors
                                .colorPrimary,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}

_makePostRequest(var data) async {
  // TODO: This stuff here is hardcode. Need changes
  // set up POST request arguments
  String url = 'https://balancemobile.it/api/v1/user/signup';
  //String url = 'http://192.168.1.206:8000/api/v1/user/signup';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = data;
  print(data);
  // make POST request
  Response response = await post(url, headers: headers, body: json);

  // response
  int statusCode = response.statusCode;
  String body = response.body;
  PreferenceManager.updateUserInfo(token: jsonDecode(body)["response"].toString());
}