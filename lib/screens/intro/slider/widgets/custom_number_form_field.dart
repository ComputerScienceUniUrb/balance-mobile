
import 'package:flutter/material.dart';

/// StatelessWidget that implements the custom
/// style for a [TextFormField]
class CustomNumberFormField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final String suffix;
  final bool decimal;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  CustomNumberFormField({
    this.labelText,
    this.suffix,
    this.decimal = false,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: decimal),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
            suffixText: suffix,
            hintStyle: TextStyle(
              color: Color(0xFFBFBFBF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            suffixStyle: TextStyle(
              color: Color(0xFFBFBFBF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextStyle(
            color: Color(0xFFBFBFBF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          autocorrect: false,
          initialValue: initialValue,
          onChanged: (newValue) => onChanged?.call(newValue),
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }
}