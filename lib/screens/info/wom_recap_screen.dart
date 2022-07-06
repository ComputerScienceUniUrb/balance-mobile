
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:balance/bloc/main/settings/settings_bloc.dart';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/model/wom_voucher.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart' as pro;

class WOMScreen extends StatefulWidget {

  @override
  _WOMScreenState createState() => _WOMScreenState();
}

/// Widget for displaying information about open source dependencies
class _WOMScreenState extends State<WOMScreen> {

  var brightness = SchedulerBinding.instance.window.platformBrightness;
  List<WomVoucher> admittedWoms;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => SettingsBloc.create(pro.Provider.of<MeasurementDatabase>(context, listen: false)),
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsEmpty)
              return _emptyScreen(context);
            else if (state is SettingsError)
              return _errorScreen(context);
            else if (state is SettingsSuccess) {
              admittedWoms = List<WomVoucher>();
              state.woms.sort((a, b) => b.id.compareTo(a.id));
              for (var i=0;i<state.woms.length;i++)
                if (!state.archived.contains(state.woms[i].id))
                  admittedWoms.add(state.woms[i]);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Worth One Minute'),
                ),
                body: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Image.asset("assets/images/wom.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'wom_discover_title'.tr(),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    color: Colors.indigoAccent,
                                      icon: Icon(Icons.search),
                                      onPressed: () async {
                                        const url = 'https://digit.srl/prodotti/wom/';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  'wom_discover_txt'.tr(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      //color: Colors.white,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          return Slidable(
                            actionPane: SlidableScrollActionPane(),
                            child: _measurementItemTemplate(context, admittedWoms[index]),
                            key: Key(admittedWoms[index].toString()),
                            actions: <Widget> [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: IconSlideAction(
                                    caption: "wom_delete_txt".tr(),
                                    color: Colors.transparent,
                                    icon: Icons.restore_from_trash_sharp,
                                    onTap: () async {
                                      await PreferenceManager.updateArchivedWom(index: admittedWoms[index].id);
                                      BlocProvider.of<SettingsBloc>(context).add(
                                          SettingsEvents.fetch);
                                    },
                                  ),
                                ),
                              )
                            ]
                          );
                        },
                        itemCount: admittedWoms.length,
                      ),
                    ),
                  ],
                ),
              );
            }
            else
              return _loadingScreen(context);
          }
      ),
    );
  }

  /// Build the empty screen
  Widget _emptyScreen(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Worth One Minute'),
    ),
    body: Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(20),
          width: 90,
          height: 90,
          child: Center(
            child: Image.asset("assets/images/wom.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              'wom_discover_title'.tr(),
              style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        color: Colors.indigoAccent,
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          const url = 'https://digit.srl/prodotti/wom/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      'wom_discover_txt'.tr(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  /// Build the error screen
  Widget _errorScreen(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Image.asset(
              "assets/images/error.png",
              fit: BoxFit.fitWidth,
            )
        ),
        SizedBox(height: 42),
        Text(
          'error_txt'.tr(),
          style: Theme.of(context).textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );

  /// Build the loading screen
  Widget _loadingScreen(BuildContext context) => Center(
    child: Center(
      child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator()
      ),
    ),
  );

  /// Returns a [Widget] with a measurement item
  Widget _measurementItemTemplate(BuildContext context, WomVoucher wom) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () => {},
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> [
                                    Text(
                                        'WOM',
                                        style: Theme.of(context).textTheme.headline4.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                    Text(
                                        'Voucher ${wom?.id ?? ""}',
                                        style: Theme.of(context).textTheme.headline4.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> [
                                    Text(
                                      "Stato:",
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    Text(
                                      wom.otc == ""? "Non Ricevuto": "Ricevuto",
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              minWidth: 25.0,
                              height: wom.otc == "" ? 25:50,
                              color: wom.otc == "" ? Colors.red : Colors.indigoAccent,
                              splashColor: Colors.grey,
                              onPressed: () async {
                                if (wom.otc != "") {
                                  String url1 = 'wom://transfer/${wom.otc}';
                                  String url2 = 'https://wom.social/vouchers/${wom.otc}';

                                  if (!await launch(url1)) {
                                    await launch(url2);
                                  }

                                } else {
                                  bool result = await _makePostRequest(wom);
                                  if (result)
                                    BlocProvider.of<SettingsBloc>(context).add(
                                        SettingsEvents.fetch);

                                }
                              },
                              child: wom.otc == "" ? Text("Richiedi") : Text("Riscatta\nPIN: ${wom.password}", textAlign: TextAlign.center,),
                            ),
                          ]
                      ),
                    ]
                ),
              ]
          ),
        ),
      ),
    );
  }

  Future<bool> _makePostRequest(WomVoucher voucher) async {
    // set up POST request arguments
    String url = 'https://www.balancemobile.it/api/v1/db/wom';
    //String url = 'https://dev.balancemobile.it/api/v1/db/wom';
    Map<String, String> headers = {"Content-type": "application/json"};
    final database = await MeasurementDatabase.getDatabase();

    try {
      print(jsonEncode(voucher));
      Response response = await post(url, headers: headers, body: jsonEncode(voucher)).timeout(Duration(seconds: 5));
      print(response.body);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)["otc"].toString());
        print(jsonDecode(response.body)["password"].toString());
        String otc = jsonDecode(response.body)["otc"].toString();
        String password = jsonDecode(response.body)["password"].toString();
        database.womDao.updateWom(WomVoucher.update(voucher, otc, password));
        return true;
      } else {
        print("_SendingData.RequestVoucher: The server answered with: "+response.statusCode.toString());
        return false;
      }
    } on TimeoutException catch (_) {
      print("_SendingData.RequestVoucher: The connection dropped, maybe the server is congested");
      return false;
    } on SocketException catch (_) {
      print("_SendingData.RequestVoucher: Communication failed. The server was not reachable");
      return false;
    }
  }
}