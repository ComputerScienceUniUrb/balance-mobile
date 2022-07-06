
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Show a dialog to ask the user if he wants to close the app during the test.
///
/// This method return a [Future] of [bool] used by the method [didPopRoute]
/// to know if the app should be closed or not.
Future<bool> showMeasurementDialog(BuildContext context, bool valid) {
  if (!valid)
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('test_measurement_ok_title'.tr()),
        content: Text('test_measurement_ok_txt'.tr()),
        actions: [
          // Stop the test and close the app
          FlatButton(
            onPressed: () {
              // Close the dialog and the app
              Navigator.pop(context, false);
            },
            child: Text('close'.tr()),
          ),
        ],
      )
    );
  else
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('test_measurement_wrong_title'.tr()),
          content: Text('test_measurement_wrong_txt'.tr()),
          actions: [
            // Stop the test and close the app
            FlatButton(
              onPressed: () {
                // Close the dialog and the app
                Navigator.pop(context, false);
              },
              child: Text('close'.tr()),
            ),
          ],
        )
    );
}