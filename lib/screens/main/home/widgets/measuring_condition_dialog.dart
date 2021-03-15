
import 'package:balance/manager/preference_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:balance/screens/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Show the [TutorialDialog]
///
/// The callback [onDone] is called every time the action button
/// is pressed and it lets the parent Widget start the measuring
void showMeasuringConditionDialog(BuildContext context, VoidCallback onDone) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => MeasuringConditionDialog(onDone),
  );
}

/// Widget that implements a tutorial dialog
///
/// This dialog has the purpose of teaching the user
/// how to correctly perform a measurement.
class MeasuringConditionDialog extends StatefulWidget {
  final VoidCallback callback;

  MeasuringConditionDialog(this.callback);

  @override
  _MeasuringConditionDialogState createState() => _MeasuringConditionDialogState();
}

class _MeasuringConditionDialogState extends State<MeasuringConditionDialog> {
  int _value;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('recent_activity_title'.tr()),
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text("recent_activity_txt".tr()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 1);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 1 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/sleeping.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 2);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 2 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/working.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 3);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 3 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/walking.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 4);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 4 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/reading.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 5);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 5 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/eating.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 6);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 6 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/drinking.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() => _value = 7);
                        PreferenceManager.updateInitialCondition(_value);
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: _value == 7 ? BColors.colorPrimary : Colors.transparent,
                          child: Center(
                            child: Image.asset("assets/images/sport.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
