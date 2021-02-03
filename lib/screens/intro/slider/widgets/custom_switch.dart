
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Custom implementation of a two-way toggle button
class CustomToggleButton extends StatefulWidget {
  CustomToggleButton({
    Key key,
    @required this.leftText,
    @required this.rightText,
    this.initial,
    @required this.onChanged,
  }): assert(leftText != null),
      assert(rightText != null),
      super(key: key);

  /// [Text] of the left button
  final Text leftText;

  /// [Text] of the right button
  final Text rightText;

  /// Initial value
  ///
  /// The initial selected value can be 0
  /// (left) or 1 (right).
  /// If the initial value is null it will
  /// default to 0 (left).
  final int initial;

  /// Callback called when the selected button changes.
  ///
  /// The [onChanged] callback is called every time time
  /// the selected button changes passing the index
  /// as parameter; this means that [onChanged] is called only
  /// if the selected button is different from the previous, so
  /// pressing multiple times one button will not trigger [onChanged].
  final ValueChanged<int> onChanged;

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  int _selected;
  bool _isEnable;

  @override
  void initState() {
    super.initState();
    _isEnable = widget.onChanged != null;
  }

  @override
  void didUpdateWidget(CustomToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isEnable = widget.onChanged != null;
  }

  @override
  Widget build(BuildContext context) {
    final toggleButtonTheme = Theme.of(context).toggleButtonsTheme;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left button
          _ToggleButton(
            text: widget.leftText,
            onTap: _isEnable? () {
              if (_selected != 0) {
                setState(() => _selected = 0);
                widget?.onChanged(0);
              }
            }: null,
            fontWeight: _getFontWeight(_selected == 0),
            backgroundColor: Colors.blueGrey,//_getBackgroundColor(_selected == 0, toggleButtonTheme),
            textColor: Colors.white,//_getTextColor(_selected == 0, toggleButtonTheme),
            shapeBorder: RoundedRectangleBorder(
              borderRadius: _getBorderRadius(0, toggleButtonTheme),
              side: BorderSide(
                color: _getBorderColor(_selected == 0, toggleButtonTheme),
                width: toggleButtonTheme.borderWidth ?? 1.0,
              ),
            ),
            borderRadius: _getBorderRadius(0, toggleButtonTheme),
          ),
          // Right button
          _ToggleButton(
            text: widget.rightText,
            onTap: _isEnable ?() {
              if (_selected != 1) {
                setState(() => _selected = 1);
                widget?.onChanged(1);
              }
            }: null,
            fontWeight: _getFontWeight(_selected == 1),
            backgroundColor: Colors.blueGrey,//_getBackgroundColor(_selected == 1, toggleButtonTheme),
            textColor: Colors.white,//_getTextColor(_selected == 1, toggleButtonTheme),
            shapeBorder: RoundedRectangleBorder(
              borderRadius: _getBorderRadius(1, toggleButtonTheme),
              side: BorderSide(
                color: _getBorderColor(_selected == 1, toggleButtonTheme),
                width: toggleButtonTheme.borderWidth ?? 1.0,
              )
            ),
            borderRadius: _getBorderRadius(1, toggleButtonTheme),
          ),
        ],
      ),
    );
  }

  /// Return the [FontWeight]
  FontWeight _getFontWeight(bool isSelected) =>
    _isEnable && isSelected
      ? FontWeight.w500
      : FontWeight.w400;

  /// Return the background [Color]
  Color _getBackgroundColor(bool isSelected, ToggleButtonsThemeData toggleButtonTheme) =>
    (_isEnable && isSelected)
      ? toggleButtonTheme.fillColor ?? Colors.red.shade200
      : Colors.transparent;

  /// Return the text [Color]
  Color _getTextColor(bool isSelected, ToggleButtonsThemeData toggleButtonTheme) {
    if (_isEnable)
      if (isSelected)
        return toggleButtonTheme.selectedColor ?? Colors.red;
      else
        return toggleButtonTheme.color ?? Colors.grey;
    return toggleButtonTheme.disabledColor ?? Colors.grey;
  }

  /// Return the border [Color]
  Color _getBorderColor(bool isSelected, ToggleButtonsThemeData toggleButtonTheme) {
    if (_isEnable)
      if (isSelected)
        return toggleButtonTheme.selectedBorderColor ?? Colors.red;
      else
        return toggleButtonTheme.borderColor ?? Colors.grey;
    else
      return toggleButtonTheme.disabledBorderColor ?? Colors.grey;
  }

  /// Return the [BorderRadius]
  BorderRadius _getBorderRadius(int index, ToggleButtonsThemeData toggleButtonTheme) {
    BorderRadius themeBorderRadius = toggleButtonTheme.borderRadius
      ?? BorderRadius.all(Radius.circular(0.0));
    return index == 0
      ? BorderRadius.only(
          topLeft: themeBorderRadius.topLeft,
          bottomLeft: themeBorderRadius.bottomLeft,
        )
      : BorderRadius.only(
          topRight: themeBorderRadius.topRight,
          bottomRight: themeBorderRadius.bottomRight,
        );
  }
}

/// Widget representing a single [CustomToggleButton]'s button
class _ToggleButton extends StatelessWidget {
  final Text text;
  final VoidCallback onTap;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final Color textColor;
  final ShapeBorder shapeBorder;
  final BorderRadius borderRadius;

  const _ToggleButton({
    Key key,
    this.text,
    this.onTap,
    this.fontWeight,
    this.backgroundColor,
    this.shapeBorder,
    this.textColor,
    this.borderRadius,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: shapeBorder,
      color: backgroundColor,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: DefaultTextStyle.merge(
            child: text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
