import 'package:balance/screens/res/colors.dart';
import 'package:flutter/material.dart';

/// A custom implementation of a bottom navigation bar
///
/// This Widget implements a custom version of a bottom
/// navigation bar, inspired form the youtube video:
/// https://www.youtube.com/watch?v=jJPSKEEiN-E
class GoogleBottomNavigationBar extends StatelessWidget {
  final List<GoogleBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  GoogleBottomNavigationBar({
    Key key,
    @required this.items,
    this.onTap,
    this.currentIndex = 0,
  }): assert(items != null),
      assert(items.length >= 2),
      assert(0 <= currentIndex && currentIndex < items.length),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56,
      padding: EdgeInsets.only(left: 24, top: 6, right: 24, bottom: 6),
      decoration: BoxDecoration(
        color: isLightTheme? Colors.white: BColors.darkOnBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final itemIdx = items.indexOf(item);
          return Material(
            color: isLightTheme? Colors.white: BColors.darkOnBg,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                if (currentIndex != itemIdx) {
                  onTap.call(itemIdx);
                }
              },
              child: _buildItem(item, currentIndex == itemIdx, isLightTheme),
            ),
          );
        }).toList()
      )
    );
  }

  /// Build a widget for each navigation item
  ///
  /// Given a [GoogleBottomNavigationItem] and if it [isSelected]
  /// returns a Widget to display as navigation element
  Widget _buildItem(GoogleBottomNavigationItem item, bool isSelected, bool isLightTheme) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 270),
      width: isSelected ? 122 : 50,
      height: double.maxFinite,
      decoration: isSelected ? BoxDecoration(
        color: isLightTheme? Color(0xffe8e7ff): BColors.colorPrimary,
        borderRadius: BorderRadius.circular(90)
      ): null,
      child: Center(
        child: isSelected ? ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                    size: 24,
                    color: isLightTheme? BColors.colorPrimary: Colors.white
                  ),
                  child: item.icon,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      color: isLightTheme? BColors.colorPrimary: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                    ),
                    child: item.text
                  ),
                ),
              ],
            ),
          ]
        ): IconTheme(
          data: IconThemeData(
            size: 24,
            color: isLightTheme? BColors.textColor: Colors.white
          ),
          child: item.icon,
        ),
      )
    );
  }
}

/// Class representing a single element of the [GoogleBottomNavigationBar]
class GoogleBottomNavigationItem {
  final Icon icon;
  final Text text;

  GoogleBottomNavigationItem({
    @required this.icon,
    @required this.text,
  }):assert(icon != null),
      assert(text != null);
}
