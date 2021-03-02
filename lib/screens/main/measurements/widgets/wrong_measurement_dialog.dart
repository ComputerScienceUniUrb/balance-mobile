
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
        title: Text('Misurazione eseguita correttamente'),
        content: Text('Congratulazioni! Quando esegui una misurazione verifichiamo i tuoi parametri. Alcuni di questi forniscono un\'indicazione riguardante la corretta esecuzione e sembra sia andato tutto bene!'),
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
          title: Text('Misurazione Sospetta'),
          content: Text('Questa misurazione presenta dei risultati irregolari. Se non hai eseguito il test correttamente, effettualo nuovamente. Se il problema persiste, contatta i ricercatori.'),
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