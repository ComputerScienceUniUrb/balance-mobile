
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:balance_app/routes.dart';

/// Display a dialog that prompt the user to the calibration screen
void showCalibrateDeviceDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text('need_to_calibrate_title'.tr()),
      content: Text('need_to_calibrate_msg'.tr()),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.calibration);
          },
          child: Text('got_it_btn'.tr()),
        )
      ],
    ),
  );
}