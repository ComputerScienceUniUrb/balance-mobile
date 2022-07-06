import 'package:easy_localization/easy_localization.dart';
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Text(
                  'tutorial_msg'.tr(),
                  textScaleFactor: 0.9,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              widget.callback();
              Navigator.pop(context);
            },
            child: Text('ok'.tr())
        ),
      ],
    );
  }
}
