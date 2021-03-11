
import 'package:balance_app/manager/preference_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Show the [TutorialDialog]
///
/// The callback [onDone] is called every time the action button
/// is pressed and it lets the parent Widget start the measuring
void showTutorialDialog(BuildContext context, VoidCallback onDone) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => TutorialDialog(onDone),
  );
}

/// Widget that implements a tutorial dialog
///
/// This dialog has the purpose of teaching the user
/// how to correctly perform a measurement.
class TutorialDialog extends StatefulWidget {
  final VoidCallback callback;

  TutorialDialog(this.callback);

  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 190,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(9.0)),
                  child: Image.asset(
                    "assets/images/tutorial.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'tutorial_msg'.tr(),
                  textScaleFactor: 0.9,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _neverShowAgainCheck = !_neverShowAgainCheck);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
        FlatButton(
          onPressed: () {
            if (_neverShowAgainCheck)
              PreferenceManager.neverShowMeasuringTutorial();
            widget.callback();
            Navigator.pop(context);
          },
          child: Text('ok'.tr())
        ),
      ],
    );
  }
}
