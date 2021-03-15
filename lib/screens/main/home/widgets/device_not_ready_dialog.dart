
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Show a dialog to ask the user if he wants to close the app during the test.
///
/// This method return a [Future] of [bool] used by the method [didPopRoute]
/// to know if the app should be closed or not.
Future<bool> showDeviceNotReady(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('not_ready_txt'.tr()),
      content: Text('battery_low_txt'.tr()),
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