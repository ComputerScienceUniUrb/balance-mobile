
import 'package:balance/screens/res/colors.dart';
import 'package:balance/screens/intro/slider/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/color_match_finder.dart';

void main() {
  group("Check item selection", () {
    testWidgets("init with selected displays the correct items", (tester) async{
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxGroup(
            labels: [
              "one",
              "two",
              "three",
            ],
            selected: [
              false,
              true,
              true,
            ],
            onChanged: null,
          ),
        ),
      );

      final elements = await tester.widgetList<CheckboxElement>(find.byType(CheckboxElement)).toList();
      expect(elements, hasLength(3));
      // First element is not selected
      expect(elements[0].label, equals("one"));
      expect(elements[0].isSelected, isFalse);
      // Second element is selected
      expect(elements[1].label, equals("two"));
      expect(elements[1].isSelected, isTrue);
      // Third element is selected
      expect(elements[2].label, equals("three"));
      expect(elements[2].isSelected, isTrue);
    });

    testWidgets("onChanged return the correct elements", (tester) async{
      List<bool> selected;
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxGroup(
            labels: [
              "one",
              "two",
              "three",
            ],
            selected: null,
            onChanged: (newSelect) {
              selected = newSelect;
            },
          ),
        ),
      );

      final elements = await tester.widgetList<CheckboxElement>(find.byType(CheckboxElement)).toList();
      expect(elements, hasLength(3));
      // All elements are not selected
      expect(elements[0].isSelected, isFalse);
      expect(elements[1].isSelected, isFalse);
      expect(elements[2].isSelected, isFalse);

      await tester.tap(find.text("two"));
      await tester.tap(find.text("three"));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected, hasLength(3));
      expect(selected[0], isFalse);
      expect(selected[1], isTrue);
      expect(selected[2], isTrue);
    });

    testWidgets("checkbox element is initialized correctly", (tester) async{
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxElement(
            label: "test",
            isSelected: false,
          ),
        )
      );

      // Widget has non selected color
      final deselectText = await tester.widget<Text>(find.text("test"));
      expect(deselectText.style.color, equals(Color(0xFFBFBFBF)));
      expect(MaterialHasColor(Colors.white), findsOneWidget);
      expect(MaterialHasColor(Color(0xFFF3F3FF)), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxElement(
            label: "test",
            isSelected: true,
          ),
        )
      );

      // Widget has selected color
      final selectText = await tester.widget<Text>(find.text("test"));
      expect(selectText.style.color, equals(BColors.colorPrimary));
      expect(MaterialHasColor(Color(0xFFF3F3FF)), findsOneWidget);
      expect(MaterialHasColor(Colors.white), findsNothing);
    });

    testWidgets("checkbox element onItemSelected is called correctly", (tester) async{
      bool selected;
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxElement(
            label: "test",
            isSelected: false,
            onItemSelected: (sel) {
              selected = sel;
            },
          ),
        )
      );

      expect(selected, isNull);

      // Select element
      await tester.tap(find.text("test"));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxElement(
            label: "test",
            isSelected: selected,
            onItemSelected: (sel) {
              selected = sel;
            },
          ),
        )
      );
      expect(selected, isNotNull);
      expect(selected, isTrue);

      // Deselect element
      await tester.tap(find.text("test"));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        MaterialApp(
          home: CheckboxElement(
            label: "test",
            isSelected: selected,
            onItemSelected: (sel) {
              selected = sel;
            },
          ),
        )
      );
      expect(selected, isNotNull);
      expect(selected, isFalse);
    });
  });

  group("Check assertions", () {
    testWidgets("checkbox labels are non-null", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: CheckboxGroup(
              labels: null,
              onChanged: null,
            ),
          ),
        );
        fail("Labels must be not null");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("labels != null"));
      }
    });

    testWidgets("checkbox labels are non-empty", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: CheckboxGroup(
              labels: [],
              onChanged: null,
            ),
          ),
        );
        fail("Labels must be not empty");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("labels.isNotEmpty"));
      }
    });

    testWidgets("checkbox selected has same size of labels", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: CheckboxGroup(
              labels: [
                "one",
                "two",
                "three",
              ],
              selected: [
                false,
                true
              ],
              onChanged: null,
            ),
          ),
        );
        fail("Selected must have the same size of labels");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("selected must have the same size of labels!"));
      }
    });

    testWidgets("checkbox element label is non-null", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: CheckboxElement(
              label: null,
              isSelected: false,
            ),
          ),
        );
        fail("Element label must be non-null");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("label != null"));
      }
    });

    testWidgets("checkbox element isSelected is non-null", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: CheckboxElement(
              label: "test",
              isSelected: null,
            ),
          ),
        );
        fail("Element isSelected must be non-null");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("isSelected != null"));
      }
    });
  });
}