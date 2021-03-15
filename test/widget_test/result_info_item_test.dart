
import 'package:balance/floor/test_database_view.dart';
import 'package:balance/screens/res/b_icons.dart';
import 'package:balance/screens/results/widgets/result_info_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("create with null test", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: ResultInfoItem(null)
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      final dateFinder = find.text(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(0)));
      final iconFinder = find.byIcon(BIcons.eye_open);
      final textFinder = find.text("-");

      expect(dateFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });
  });

  testWidgets("create with fake test", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          child: MaterialApp(
            home: ResultInfoItem(Test(
              id: 1,
              eyesOpen: false,
              creationDate: 1996,
            ))
          ),
          supportedLocales: [Locale("en")],
          saveLocale: false,
          path: "assets/translations",
        )
      );
      await tester.idle();
      await tester.pumpAndSettle();

      final dateFinder = find.text(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(1996)));
      final iconFinder = find.byIcon(BIcons.eye_close);
      final textFinder = find.text("Eyes Closed");

      expect(dateFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });
  });
}