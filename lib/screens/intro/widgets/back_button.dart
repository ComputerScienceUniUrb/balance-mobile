
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Represent the next button of intro screens
///
/// This Widget implements a round button used as
/// next button in [IntroScreen].
/// This button has an enable and disable states,
/// his enable background can be personalized and
/// can display a done string when it represent the
/// last page.
class BackCustomButton extends StatelessWidget {
  final bool isEnable;
  final bool isVisible;
  final bool isDone;
  final Color backgroundColor;
  final VoidCallback onTap;

  BackCustomButton({
    Key key,
    this.isEnable = true,
    this.isVisible = false,
    this.isDone = false,
    this.onTap,
    this.backgroundColor,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 270),
      height: 64,
      width: 64,
      child: FloatingActionButton(
        onPressed: isEnable? onTap: null,
        heroTag: 'back_btn',
        child: isDone?
          Text(
            'done_btn'.tr(),
            style: Theme.of(context).textTheme.button.copyWith(
              color: Colors.white
            ),
          ):
          Icon(
            Icons.arrow_back,
          ),
        backgroundColor: isEnable? backgroundColor: Color(0xFFE0E0E0),
        foregroundColor: isEnable? Colors.white: Color(0xFFA6A6A6),
      ),
    );
  }
}