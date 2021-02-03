
import 'dart:convert';

import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/model/system_info.dart';
import 'package:balance_app/routes.dart';
import 'package:balance_app/screens/intro/widgets/next_button.dart';
import 'package:balance_app/screens/intro/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/screens/intro/widgets/dots_indicator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';
import 'package:http/http.dart';

import 'slider/welcome.dart';
import 'slider/consent.dart';
import 'slider/height.dart';
import 'slider/general_info.dart';
import 'slider/posture.dart';
import 'slider/trauma.dart';
import 'slider/habits.dart';
import 'slider/sight.dart';

/// This class show an introduction when the app is first open.
class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0, keepPage: false);
  int _currentPage = 0;
  bool _isNextBtnEnable = true;
  List<Color> _pageColors = [
    BColors.colorPrimary,
    Color(0xFF398AA7),
    Color(0xFF36836C),
    Color(0xFF739AA7),
    Color(0xFF798CA7),
    Color(0xFF8F8CA7),
    Color(0xFF897AA7),
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
                          if (_currentPage == 6) {
                            PreferenceManager.firstLaunchDone();
                            _makePostRequest(jsonEncode(await PreferenceManager.userInfo));
                            Navigator.pushReplacementNamed(context, Routes.main);
                          } else {
                            /*
                            * All the required data are stored... mark the
                            * first launch as done so we don't ask this data anymore
                            */
                            print(await PreferenceManager.userInfo);
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
                                if (newPage == 1 || newPage == 2 || newPage == 3 || newPage == 4)
                                  _isNextBtnEnable = false;
                              }),
                          children: [
                            WelcomeScreen(0),
                            ConsentScreen(1, (isEnable) =>
                                setState(() => _isNextBtnEnable = isEnable),),
                            HeightScreen(2, (isEnable) =>
                                setState(() => _isNextBtnEnable = isEnable),),
                            GeneralInfoScreen(3, (isEnable) =>
                                setState(() => _isNextBtnEnable = isEnable)),
                            PostureScreen(4, (isEnable) =>
                                setState(() => _isNextBtnEnable = isEnable)),
                            HabitsScreen(5, (isEnable) =>
                                setState(() => _isNextBtnEnable = isEnable)),
                            SightScreen(6),
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
                          AnimatedContainer(
                            duration: Duration(milliseconds: 270),
                            height: 48,
                            child: Row(children: <Widget>[
                              BackCustomButton(
                                onTap: () => [_pageController.previousPage(
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.ease
                                ),
                                  _isNextBtnEnable = true],
                                isEnable: (_currentPage == 0) ? false : true,
                                backgroundColor: (_currentPage == 0) ? BColors.colorAccent : BColors.colorPrimary,
                              ),
                            ]),
                          ),
                          DotsIndicator(
                            size: 7,
                            selected: _currentPage,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 270),
                            height: 48,
                            child: Row(children: <Widget>[
                              NextButton(
                                onTap: () =>
                                    BlocProvider.of<OnBoardingBloc>(context).add(
                                        NeedToValidateEvent(_currentPage)),
                                isEnable: _isNextBtnEnable,
                                isDone: _currentPage == 6,
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
  print("_SendingData.signup: "+data);
  // make POST request
  Response response = await post(url, headers: headers, body: json);

  // response
  //int statusCode = response.statusCode;
  String body = response.body;
  PreferenceManager.updateUserInfo(token: jsonDecode(body)["response"].toString());

  // Send System Info
  //String url = 'https://balancemobile.it/api/v1/user/signup';
  //url = 'http://192.168.1.206:8000/api/v1/user/signup';
  //headers = {"Content-type": "application/json"};
  //json = (await PreferenceManager.systemInfo).toJson() as String;
  //print("_SendingData.signup: "+data);
  //// make POST request
  ////Response response = await post(url, headers: headers, body: json);

  //// response
  ////int statusCode = response.statusCode;
  //String body = response.body;
}