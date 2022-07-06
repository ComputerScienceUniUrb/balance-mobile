
import 'package:balance/manager/preference_manager.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:balance/screens/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Show the [TutorialDialog]
///
/// The callback [onDone] is called every time the action button
/// is pressed and it lets the parent Widget start the measuring
void showWomDialog(BuildContext context, VoidCallback onDone) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WomDialog(onDone),
  );
}

/// Widget that implements a tutorial dialog
///
/// This dialog has the purpose of teaching the user
/// how to correctly perform a measurement.
class WomDialog extends StatefulWidget {
  final VoidCallback callback;

  WomDialog(this.callback);

  @override
  _WomDialogState createState() => _WomDialogState();
}

class _WomDialogState extends State<WomDialog> {
  bool _neverShowAgainCheck = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
               padding: const EdgeInsets.all(16.0),
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(9.0)),
                  child: Image.asset(
                    "assets/images/wom.png",
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Text(
                  'wom_dialog_discover_txt'.tr(),
                  style: TextStyle(
                    color: BColors.textColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Text(
                  'wom_dialog_hint_txt'.tr(),
                  style: TextStyle(
                    color: BColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _neverShowAgainCheck = !_neverShowAgainCheck);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircularCheckBox(
                        value: _neverShowAgainCheck,
                        onChanged: (value) {
                          setState(() => _neverShowAgainCheck = value);
                        },
                        activeColor: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'never_show_again'.tr(),
                        textScaleFactor: 0.9,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        // Stop the test and close the app
        FlatButton(
          onPressed: () {
            if (_neverShowAgainCheck)
              PreferenceManager.neverShowMeasuringTutorial();
            widget.callback();
            Navigator.pop(context);
          },
          child: Text('wom_dialog_ok_txt'.tr()),
        ),
      ],
    );
  }
}
