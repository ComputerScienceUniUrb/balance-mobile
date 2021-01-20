import 'package:balance_app/screens/res/b_icons.dart';
import 'package:flutter/material.dart';

/// Custom implementation of a [InfoElement]
///
/// The element has an [icon], a [text] and responds to
/// [onTap] events.
class InfoElement extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  InfoElement({
    Key key,
    this.icon,
    @required this.text,
    this.onTap
  }): assert(text != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                icon != null ? icon: Icon(BIcons.opensource),
                SizedBox(width: 16),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}