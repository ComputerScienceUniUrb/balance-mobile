
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:balance/floor/measurement_database.dart';
import 'package:balance/model/measurement.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/rendering.dart';

/// Show the [NoteDialog]
/// Widget that implements a note dialog. This dialog has the
/// purpose of updating note measurement.
Future<bool> showNoteDialog(BuildContext context, int id) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => NoteDialog(id),
  );
}

class NoteDialog extends StatefulWidget {
  final int id;

  NoteDialog(this.id);

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  TextEditingController _noteText = new TextEditingController();

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
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                      children: <Widget> [
                        Text(
                          'note_dialog_txt'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 24),
                        TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(64),
                            ],
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'note_length_txt'.tr(),
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                ),
                            ),
                            controller: _noteText
                        ),
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Stop the test and close the app
        FlatButton(
          onPressed: () async {
            // Close the dialog and the app
            if(_noteText.text != null && _noteText.text != "")
              Navigator.pop(context, await _makePostRequest(widget.id, _noteText.text));
            else
              Navigator.pop(context, false);
          },
          child: Text('ok'.tr()),
        ),
      ],
    );
  }
}

Future<bool> _makePostRequest(measurementId, note) async {

  String url_measurement = 'https://www.balancemobile.it/api/v1/db/note';
  //String url_measurement = 'http://www.dev.balancemobile.it/api/v1/db/note';
  Map<String, String> headers = {"Content-type": "application/json"};

  final database = await MeasurementDatabase.getDatabase();
  var measurement = await database.measurementDao.findMeasurementById(measurementId);

  try {
    Measurement newMeasurement = Measurement.note(measurement, note);
    Response response = await post(url_measurement, headers: headers, body: jsonEncode(newMeasurement)).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      var result = await database.measurementDao.updateMeasurement(newMeasurement);
      print(result);
      return true;
    } else {
      print("_SendingData.updateNote: The server answered with: "+response.statusCode.toString());
      return false;
    }
  } on TimeoutException catch (_) {
    print("_SendingData.updateNote: The connection dropped, maybe the server is congested");
    return false;
  } on SocketException catch (_) {
    print("_SendingData.updateNote: Communication failed. The server was not reachable");
    return false;
  }
}
