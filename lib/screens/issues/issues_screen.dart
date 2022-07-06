
import 'dart:async';
import 'dart:io';

import 'package:balance/manager/preference_manager.dart';
import 'package:balance/screens/issues/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';

class IssuesScreen extends StatefulWidget {
  @override
  _IssuesScreenState createState() => _IssuesScreenState();
}

/// Widget for displaying informations about open source dependencies
class _IssuesScreenState extends State<IssuesScreen> {
  PackageInfo packageInfo;
  String token;
  String _description;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() => packageInfo = value));
    _description = '';
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((value) => packageInfo = value);
    return Scaffold(
      appBar: AppBar(
        title: Text('report_title'.tr()),
      ),
      body: Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                  width: 150,
                  height: 150,
                  child: Center(
                    child: Image.asset("assets/app_logo_circle_broken.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    'report_title_txt'.tr(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    "${'version_txt'.tr()} ${packageInfo
                        ?.version} (${'build_txt'.tr()}${packageInfo
                        ?.buildNumber})",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: CustomFormField(
                    labelText: 'report_description_txt'.tr(),
                    initialValue: '',
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    validator: (value) {
                         return value.isEmpty? 'too_short_error_txt'.tr():value;
                    },
                  ),
                ),
                RaisedButton(
                    onPressed: () async {
                      if (_description.length > 0) {
                        String token = (await PreferenceManager.userInfo).token;
                        String version = "${'version_txt'.tr()} ${packageInfo
                            ?.version} (${'build_txt'.tr()}${packageInfo
                            ?.buildNumber})";
                        String json = '{"token":"$token","version":"$version","description":"$_description"}';
                        _makePostRequest(json);
                        FocusScope.of(context).unfocus();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('report_snack_true_txt'.tr()),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        FocusScope.of(context).unfocus();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('report_snack_false_txt'.tr()),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text('report_send_txt'.tr())
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<bool> _makePostRequest(var data) async {
  // set up POST request arguments
  String url = 'https://www.balancemobile.it/api/v1/db/reporting';
  //String url = 'http://192.168.1.206:8000/api/v1/db/reporting';
  Map<String, String> headers = {"Content-type": "application/json"};

  try {
    Response response = await post(url, headers: headers, body: data).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return true;
    } else {
      print("_SendingData.Issues: The server answered with: "+response.statusCode.toString());
      return false;
    }
  } on TimeoutException catch (_) {
    print("_SendingData.Issues: The connection dropped, maybe the server is congested");
    return false;
  } on SocketException catch (_) {
    print("_SendingData.Issues: Communication failed. The server was not reachable");
    return false;
  }
}