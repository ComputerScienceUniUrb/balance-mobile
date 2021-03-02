
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Show a dialog to ask the user if he wants to close the app during the test.
///
/// This method return a [Future] of [bool] used by the method [didPopRoute]
/// to know if the app should be closed or not.
Future<bool> showDeviceNotReady(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Dispositivo non pronto'),
      content: Text('Per eseguire al meglio la misurazione é necessario che la batteria sia superiore al 30%. Ricarica il telefono e ritenta quando sei pronto.'),
      actions: [
        // Stop the test and close the app
        FlatButton(
          onPressed: () {
            // Close the dialog and the app
            Navigator.pop(context, false);
          },
          child: Text('Chiudi'),
        ),
      ],
    )
  );
}