
import 'package:balance_app/widgets/custom_number_form_field.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balance_app/screens/onboarding/general_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

void main() {
  testWidgets("No initial value", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: GeneralInfoScreen(0),
            ),
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      final ageEditTextFinder = find.text("Age");
      final genderDropdownFinder = find.text("Gender");
      final weightEditTextFinder = find.text("Weight");
      expect(ageEditTextFinder, findsOneWidget);
      expect(genderDropdownFinder, findsOneWidget);
      expect(weightEditTextFinder, findsOneWidget);
    });
  });

  testWidgets("Initial value", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: GeneralInfoScreen(
                0,
                age: "20",
                gender: 1,
                weight: "80.0",
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

      final ageEditTextFinder = find.text("20");
      final genderDropdownFinder = find.text("Male");
      final weightEditTextFinder = find.text("80.0");
      expect(ageEditTextFinder, findsOneWidget);
      expect(genderDropdownFinder, findsOneWidget);
      expect(weightEditTextFinder, findsOneWidget);
    });
  });

  testWidgets("Edit some value", (tester) async{
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: BlocProvider(
              create: (context) => OnBoardingBloc.create(),
              child: GeneralInfoScreen(0),
            ),
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      // Edit the age and weight text fields
      await tester.enterText(find.widgetWithText(CustomNumberFormField, "Age"), "22");
      await tester.enterText(find.widgetWithText(CustomNumberFormField, "Weight"), "87.2");
      expect(find.text("22"), findsOneWidget);
      expect(find.text("87.2"), findsOneWidget);

      // Open the dropdown and select one item
      await tester.tap(find.byType(CustomDropdown));
      await tester.pump();
      await tester.tap(find.text("Female"));
      await tester.pump();
      expect(find.text("Female"), findsOneWidget);
    });
  });
}