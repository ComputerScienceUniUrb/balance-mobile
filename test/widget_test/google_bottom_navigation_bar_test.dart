
import 'package:balance_app/widgets/google_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Check selection", () {
    testWidgets("display correct current item", (tester) async{
      await tester.pumpWidget(
        MaterialApp(
          home: GoogleBottomNavigationBar(
            items: [
              GoogleBottomNavigationItem(
                text: Text("0"),
                icon: Icon(Icons.home),
              ),
              GoogleBottomNavigationItem(
                text: Text("1"),
                icon: Icon(Icons.message),
              ),
              GoogleBottomNavigationItem(
                text: Text("2"),
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: 0,
          ),
        ),
      );

      expect(find.text("0"), findsOneWidget);
      expect(find.text("1"), findsNothing);
      expect(find.text("2"), findsNothing);
    });

    testWidgets("onTap is called", (tester) async{
      int currentIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: GoogleBottomNavigationBar(
            items: [
              GoogleBottomNavigationItem(
                text: Text("0"),
                icon: Icon(Icons.home),
              ),
              GoogleBottomNavigationItem(
                text: Text("1"),
                icon: Icon(Icons.message),
              ),
              GoogleBottomNavigationItem(
                text: Text("2"),
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: currentIndex,
            onTap: (newIdx) {
              currentIndex = newIdx;
            },
          ),
        )
      );

      expect(currentIndex, equals(0));
      expect(find.text("0"), findsOneWidget);
      expect(find.text("1"), findsNothing);
      expect(find.text("2"), findsNothing);

      await tester.tap(find.byIcon(Icons.message));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: GoogleBottomNavigationBar(
            items: [
              GoogleBottomNavigationItem(
                text: Text("0"),
                icon: Icon(Icons.home),
              ),
              GoogleBottomNavigationItem(
                text: Text("1"),
                icon: Icon(Icons.message),
              ),
              GoogleBottomNavigationItem(
                text: Text("2"),
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: currentIndex,
            onTap: (newIdx) {
              currentIndex = newIdx;
            },
          ),
        )
      );

      expect(currentIndex, equals(1));
      expect(find.text("0"), findsNothing);
      expect(find.text("1"), findsOneWidget);
      expect(find.text("2"), findsNothing);
    });
  });

  group("Check assertions", () {
    test("navigation item text is non-null", () {
      try {
        GoogleBottomNavigationItem(
          text: null,
          icon: Icon(Icons.text_fields),
        );
        fail("The text sould be not null");
      } on AssertionError catch (e) {
        expect(e.toString(), contains("text != null"));
      }
    });

    test("navigation item icon is non-null", () {
      try {
        GoogleBottomNavigationItem(
          text: Text("test"),
          icon: null,
        );
        fail("The icon sould be not null");
      } on AssertionError catch (e) {
        expect(e.toString(), contains("icon != null"));
      }
    });

    testWidgets("navigation items are non-null", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: GoogleBottomNavigationBar(
              items: null,
            ),
          )
        );
        fail("Items must be not null");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("items != null"));
      }
    });

    testWidgets("navigation items are at least two", (tester) async{
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: GoogleBottomNavigationBar(
              items: [],
            ),
          )
        );
        fail("Items lenght must be >= 2");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("items.length >= 2"));
      }
    });
    
    testWidgets("navigation index out of range", (tester) async{
      // Lower bound
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: GoogleBottomNavigationBar(
              items: [
                GoogleBottomNavigationItem(
                  text: Text("test"),
                  icon: Icon(Icons.text_fields),
                ),
                GoogleBottomNavigationItem(
                  text: Text("test"),
                  icon: Icon(Icons.text_fields),
                ),
              ],
              currentIndex: -1,
            ),
          )
        );
        fail("Current index should be >= 0");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("0 <= currentIndex"));
      }
      // Upper bound
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: GoogleBottomNavigationBar(
              items: [
                GoogleBottomNavigationItem(
                  text: Text("test"),
                  icon: Icon(Icons.text_fields),
                ),
                GoogleBottomNavigationItem(
                  text: Text("test"),
                  icon: Icon(Icons.text_fields),
                ),
              ],
              currentIndex: 2,
            ),
          )
        );
        fail("Current index should be < items.length");
      } on AssertionError catch(e) {
        expect(e.toString(), contains("currentIndex < items.length"));
      }
    });
  });
}