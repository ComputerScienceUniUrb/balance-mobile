
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:balance/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/routes.dart';
import 'package:balance/screens/intro/widgets/next_button.dart';
import 'package:balance/screens/intro/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balance/screens/res/colors.dart';
import 'package:balance/screens/intro/widgets/dots_indicator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/intro/onboarding_bloc.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'slider/welcome.dart';
import 'slider/consent.dart';
import 'slider/height.dart';
import 'slider/general_info.dart';
import 'slider/posture.dart';
import 'slider/habits.dart';
import 'slider/sight.dart';

import 'package:easy_localization/easy_localization.dart';

/// This class show an introduction when the app is first open.
class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0, keepPage: false);
  int _currentPage = 0;

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  List<Color> _pageColors = [
    BColors.colorPrimary,
    Color(0xFF398AA7),
    Color(0xFF36836C),
    Color(0xFF739AA7),
    Color(0xFF798CA7),
    Color(0xFF8F8CA7),
    Color(0xFF897AA7),
  ];

  Future<bool> _makePostRequest(var data, bool endpoint) async{
    // Make the call last at least 1 second
    await Future.delayed(Duration(seconds: 2), () {});

    // set up POST request arguments
    String url = "";
    if (endpoint) {
      url = 'https://www.balancemobile.it/api/v1/user/signup';
      //url = 'https://www.dev.balancemobile.it/api/v1/user/signup';
      print("_SendingData.signup: "+data);
    } else {
      url = 'https://www.balancemobile.it/api/v1/db/system';
      //url = 'https://www.dev.balancemobile.it/api/v1/db/system';
      print("_SendingData.system: "+data);
    }
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Response response = await post(url, headers: headers, body: data).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (endpoint) {
          await PreferenceManager.updateUserInfo(token: jsonDecode(response.body)["response"].toString());
          await PreferenceManager.updateSystemInfo(token: jsonDecode(response.body)["response"].toString());
          _makePostRequest(jsonEncode(await PreferenceManager.systemInfo), false);
        }
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (_) {
      print("_SendingData.signup: The connection dropped, maybe the server is congested");
      return false;
    } on SocketException catch (_) {
      print("_SendingData.signup: Communication failed. The server was not reachable");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        child: BlocProvider<OnBoardingBloc>(
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
                              // start the modal progress HUD
                              setState(() {
                                _isInAsyncCall = true;
                              });

                              bool result = await _makePostRequest(jsonEncode(await PreferenceManager.userInfo), true);

                              setState(() {
                                if (!result) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 10),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('intro_backend_snack_txt'.tr())
                                  ));
                                }
                                _isInAsyncCall = false;
                              });

                              if (result) {
                                PreferenceManager.firstLaunchDone();
                                Navigator.pushReplacementNamed(context, Routes.main);
                              }
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
                                }),
                            children: [
                              WelcomeScreen(0),
                              ConsentScreen(1),
                              HeightScreen(2),
                              GeneralInfoScreen(3),
                              PostureScreen(4),
                              HabitsScreen(5),
                              SightScreen(6),
                            ],
                          ),
                        ),
                      ),
                      // Bottom bar with progress, skip and next button
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                        color: _pageColors[_currentPage],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 270),
                              height: 42,
                              child: Row(children: <Widget>[
                                BackCustomButton(
                                  onTap: () => [_pageController.previousPage(
                                      duration: Duration(milliseconds: 800),
                                      curve: Curves.ease
                                  )],
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
                              height: 42,
                              child: Row(children: <Widget>[
                                BlocBuilder<OnBoardingDataBloc, OnBoardingData>(builder: (context, state) {
                                  return NextButton(
                                    onTap: () =>
                                        BlocProvider.of<OnBoardingBloc>(context).add(
                                            NeedToValidateEvent(_currentPage)),
                                    isEnable: state.isButtonEnabled(_currentPage),
                                    isDone: _currentPage == 6,
                                    backgroundColor: (_currentPage == 0) ? BColors.colorAccent : BColors.colorPrimary,
                                  );
                                })
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
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}