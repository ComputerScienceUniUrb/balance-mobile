
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balance_app/screens/intro/slider/height.dart';
import 'package:balance_app/screens/intro/slider/widgets/custom_number_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/screens/intro/bloc/onboarding_bloc.dart';

void main() {
  testWidgets("No initial value", (tester) async{
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: HeightScreen(
                0,
                  (_) {},
              ),
            ),
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      final heightEditTextFinder = find.text("Height");
      expect(heightEditTextFinder, findsOneWidget);
    });
  });

  testWidgets("Initial value", (tester) async{
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: HeightScreen(
                0,
                  (_) {},
                //height: "123.4",
              ),
            ),
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      final heightEditTextFinder = find.text("Height");
      expect(heightEditTextFinder, findsOneWidget);
    });
  });

  testWidgets("Write some value", (tester) async{
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: HeightScreen(
                0,
                  (_) => {},
              ),
            ),
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(CustomNumberFormField), "105.0");
      expect(find.text("105.0"), findsOneWidget);
    });
  });
}