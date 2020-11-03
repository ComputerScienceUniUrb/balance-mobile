import 'package:flutter/material.dart';

/// A custom implementation of a group of settings
///
/// This Widget implements a group of settings
/// with a title and a collection of child
/// [SettingsElement]s.
class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingsElement> children;

  SettingsGroup({
    Key key,
    @required this.title,
    @required this.children
  }): assert(title != null),
      assert(children != null),
      assert(children.isNotEmpty),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Column(
            children: children,
          )
        ],
      ),
    );
  }
}

/// Custom implementation of a [SettingsGroup]'s element
///
/// This Widget implements and element of a [SettingsGroup],
/// the element has an [icon], a [text] and responds to
/// [onTap] and [onLongPress] events.
class SettingsElement extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  SettingsElement({
    Key key,
    this.icon,
    @required this.text,
    this.onTap,
    this.onLongPress
  }): assert(text != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.light? Colors.white: Theme.of(context).primaryColor,
      child: InkWell(
        onLongPress: () => onLongPress?.call(),
        onTap: () => onTap?.call(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                icon != null ? icon: SizedBox(width: 24, height: 24),
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