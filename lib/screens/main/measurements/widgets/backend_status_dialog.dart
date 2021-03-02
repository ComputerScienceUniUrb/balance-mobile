
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Show a dialog to ask the user if he wants to close the app during the test.
///
/// This method return a [Future] of [bool] used by the method [didPopRoute]
/// to know if the app should be closed or not.
Future<bool> showBackendStatusDialog(BuildContext context, bool valid) {
  if (!valid)
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Misurazione inviata correttamente al server'),
        content: Text('La tua misurazione é stata registrata correttamente nel server. Stai contribuendo attivamente alla ricerca!'),
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
          title: Text('La misurazione non ha raggiunto il backend'),
          content: Text('La misurazione non ha raggiunto il backend. Per farlo devi attivare la connessione alla rete internet. Se non invii i risultati della tua misurazione non contribuirai alla ricerca ma solo a te stesso.'),
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