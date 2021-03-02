
import 'package:balance_app/bloc/intro/onboarding_bloc.dart';
import 'package:balance_app/model/user_info.dart';
import 'package:balance_app/screens/intro/intro_screen.dart';
import 'package:balance_app/screens/info/user_info_recap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/screens/intro/widgets/dots_indicator.dart';
import 'package:balance_app/screens/intro/widgets/next_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'intro/slider/consent.dart';
import 'intro/slider/height.dart';
import 'intro/slider/general_info.dart';
import 'intro/slider/posture.dart';
import 'intro/slider/habits.dart';
import 'intro/slider/sight.dart';
import 'intro/slider/welcome.dart';

/// Show a a list of screens that lets edit user information
///
/// This class builds a [PageView] where his children are
/// screens from [balance_app/screens/intro/slider] to let
/// the user edit all his personal information that he gave
/// during the first launch.
/// Pushing this screen with a [Navigator] we can pass an instance
/// of [UserInfo] as argument so each screen will be initialized with
/// that data
/// ```dart
/// Navigator.pushNamed(..., arguments: userInfo);
/// ```
/// See also:
/// * [IntroScreen]
/// * [HeightScreen]
/// * [GeneralInfoScreen]
/// * [PostureScreen]
/// * [TraumaScreen]
/// * [SightScreen]
///
/// * [UserInfoRecapScreen]
class SliderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<Slider> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isNextBtnEnable = false;
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
    UserInfo userInfo = ModalRoute
      .of(context)
      .settings
      .arguments;
    if (_currentPage == 0 && userInfo.height != null)
      setState(() => _isNextBtnEnable = true);
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
                        // If we are in the last page go to home
                        if (_currentPage == 7) {
                          Navigator.pop(context);
                        } else {
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
                          child: NextButton(
                            onTap: () =>
                              BlocProvider.of<OnBoardingBloc>(context).add(
                                NeedToValidateEvent(_currentPage)),
                            isEnable: _isNextBtnEnable,
                            isDone: _currentPage == 7,
                            backgroundColor: BColors.colorPrimary,
                          ),
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