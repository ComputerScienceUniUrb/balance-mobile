
import 'package:balance/bloc/main/charts/charts_bloc.dart';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/screens/main/charts/widgets/custom_switch.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:screenshot/screenshot.dart';

import '../../../model/measurement.dart';
import '../../res/colors.dart';
import 'widgets/graph.dart';

class ChartsScreen extends StatefulWidget {
  ChartsScreen();

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {

  bool _chosenValue;
  int _switch;
  int _initialCondition;
  int _btn;

  List<bool> _initConditionlist;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    _btn = 0;
    _chosenValue = true;
    _switch = 0;
    _initialCondition = 0;
    _initConditionlist = [false, false, false, false, false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartsBloc.create(Provider.of<MeasurementDatabase>(context, listen: false)),
      child: BlocBuilder<ChartsBloc, ChartsState>(
        builder: (context, state) {
          if (state is ChartsEmpty)
            return _emptyScreen(context);
          else if (state is ChartsError)
            return _errorScreen(context);
          else if (state is ChartsSuccess) {
            state.measurements.sort((a, b) => a.creationDate.compareTo(b.creationDate));
            return _chartsPage(context, state.measurements);
          }
          else
            return _loadingScreen(context);
        }
      ),
    );
  }

  /// Build the empty screen
  Widget _emptyScreen(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Image.asset(
            "assets/images/no_charts.png",
            fit: BoxFit.fitWidth,
          )
        ),
        SizedBox(height: 42),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'no_charts_txt'.tr(),
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w500,),
            textAlign: TextAlign.center,
          )
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

  /// Build the loading screen
  Widget _chartsPage(BuildContext context, List<Measurement> tests) {

    return Screenshot(
      controller: screenshotController,
      child: Center(
          child: ListView(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(
                      left: 16, top: 16, right: 16, bottom: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "charts_select_txt".tr(),
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 24,),
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                      onPressed: () {
                                        if (_btn != 0) {
                                          int testNumber = 0;
                                          for (var i = 0; i < tests.length; i++)
                                            if (tests[i].eyesOpen == true)
                                              testNumber += 1;

                                          if (testNumber > 1) {
                                            setState(() {
                                              _chosenValue = true;
                                              _switch = 0;
                                              _initialCondition = 0;
                                              _initConditionlist = [false, false, false, false, false, false, false];
                                            });
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    duration: const Duration(
                                                        seconds: 10),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'no_records_open_txt'
                                                            .tr())
                                                ));
                                          }

                                          _btn = 0;
                                        }
                                      },
                                      child: Text("eyes_open".tr()),
                                      color: _chosenValue? Colors.indigoAccent:Colors.grey,
                                      textColor: Colors.white
                                  )
                              ),
                              SizedBox(width: 12,),
                              Expanded(
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (_btn != 1) {
                                        int testNumber = 0;
                                        for (var i = 0; i < tests.length; i++)
                                          if (tests[i].eyesOpen == false)
                                            testNumber += 1;

                                        if (testNumber > 1) {
                                          setState(() {
                                            _chosenValue = false;
                                            _switch = 0;
                                            _initialCondition = 0;
                                            _initConditionlist = [false, false, false, false, false, false, false];
                                          });
                                        } else {
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                              duration: const Duration(seconds: 10),
                                              behavior: SnackBarBehavior.floating,
                                              content: Text('no_records_close_txt'.tr())
                                          ));
                                        }

                                        _btn = 1;
                                      }
                                    },
                                    child: Text("eyes_closed".tr()),
                                    color: _chosenValue? Colors.grey:Colors.indigoAccent,
                                    textColor: Colors.white,
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24,),
                        (_initConditionlist=_filterActive(tests, _chosenValue)).any((element) => element == true)?
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "charts_filter_txt".tr(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              CustomSwitch(
                                initial: 1,
                                onChanged: (selected) {
                                  setState(() {
                                    _switch = selected;
                                    if (selected == 0)
                                      _initialCondition = 0;
                                  });
                                },
                                leftText: Text('no'.tr()),
                                rightText: Text('yes'.tr()),
                              ),
                            ]
                        )
                            :
                        Text(
                          "Esegui almeno due misurazioni con la stessa condizione iniziale e potrai visualizzare dei grafici ancora più dettagliati!",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                        Visibility(
                            visible: _switch==1?true:false,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(0) == true?
                                          setState(() => _initialCondition = 1)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 1 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[0] == true?Image.asset("assets/images/sleeping.png"):Image.asset("assets/images/sleeping_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(1) == true?
                                          setState(() => _initialCondition = 2)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 2 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[1] == true?Image.asset("assets/images/working.png"):Image.asset("assets/images/working_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(2) == true?
                                          setState(() => _initialCondition = 3)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 3 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[2] == true?Image.asset("assets/images/walking.png"):Image.asset("assets/images/walking_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(3) == true?
                                          setState(() => _initialCondition = 4)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 4 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[3] == true?Image.asset("assets/images/reading.png"):Image.asset("assets/images/reading_grey.png"),
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
                                          _initConditionlist.elementAt(4) == true?
                                          setState(() => _initialCondition = 5)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 5 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[4] == true?Image.asset("assets/images/eating.png"):Image.asset("assets/images/eating_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(5) == true?
                                          setState(() => _initialCondition = 6)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 6 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[5] == true?Image.asset("assets/images/drinking.png"):Image.asset("assets/images/drinking_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          _initConditionlist.elementAt(6) == true?
                                          setState(() => _initialCondition = 7)
                                              :
                                          Fluttertoast.showToast(
                                            msg: "Not enough data to estimate the trends. Make more measurements!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.indigoAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            height: 48,
                                            width: 48,
                                            color: _initialCondition == 7 ? BColors.colorPrimary : Colors.transparent,
                                            child: Center(
                                              child: _initConditionlist[6] == true?Image.asset("assets/images/sport.png"):Image.asset("assets/images/sport_grey.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Column(
                          children: <Widget>[
                            Text("charts_trends_title".tr(), style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1),
                          ]
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(
                          left: 16, top: 16, right: 16, bottom: 8),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 8, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 8,),
                            Text(
                              "charts_swaypath_title".tr(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16
                              ),
                            ),
                            SizedBox(height: 16,),
                            LinePlot(
                              plotData: PlotData(_createSwayPathSeries(tests, _chosenValue, _initialCondition)),
                              lowBound: _chosenValue? 3.13:6.9,
                              highBound: _chosenValue? 6.9:38.54,
                            ),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(
                          left: 16, top: 16, right: 16, bottom: 8),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 8,),
                            Text(
                              "charts_meanfrequency_title".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(height: 16,),
                            LinePlot(
                                plotData: PlotData(_createMeanFrequencySeries(tests, _chosenValue, _initialCondition)),
                                lowBound: _chosenValue? 0.1:0.1,
                                highBound: _chosenValue? 0.3:0.3,
                            ),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(
                          left: 16, top: 16, right: 16, bottom: 8),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 8,),
                            Text(
                              "charts_meantime_title".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(height: 16,),
                            LinePlot(
                              plotData: PlotData(_createMeanTimeSeries(tests, _chosenValue, _initialCondition)),
                              lowBound: _chosenValue? 0.25:0.15,
                              highBound: _chosenValue? 0.79:0.52,
                            ),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]
          )
      ),
    );
  }

  /// Creates the SwayPathSeries
  static List<bool> _filterActive(List<Measurement> tests, bool eyesOpen) {

    List<Measurement> selectedMeasurements = [];
    for(var i = 0; i < tests.length; i++) {
      if (eyesOpen == tests[i].eyesOpen && tests[i].initCondition != null)
        selectedMeasurements.add(tests[i]);
    }

    final group_conditions = groupBy(selectedMeasurements, (Measurement t) {
      return t.initCondition;
    });

    List<bool> conditionsArray = [false,false,false,false,false,false,false];
    group_conditions.forEach((key, value) {
      if (value.length > 1)
        conditionsArray[key-1] = true;
    });

    return conditionsArray;
  }

  /// Creates the SwayPathSeries
  static List<SeriesElem> _createSwayPathSeries(List<Measurement> tests, bool eyesOpen, int filter) {

    List<SeriesElem> data = [];
    for(var i = 0; i < tests.length; i++)
      if (filter == 0) {
        if (eyesOpen == tests[i].eyesOpen) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].swayPath));
        }
      } else {
        if (eyesOpen == tests[i].eyesOpen && filter == tests[i].initCondition) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].swayPath));
        }
      }
    return data;
  }

  /// Creates the data for the COGv ball chart
  static List<SeriesElem> _createMeanFrequencySeries(List<Measurement> tests, bool eyesOpen, int filter) {

    List<SeriesElem> data = [];
    for(var i = 0; i < tests.length; i++)
      if (filter == 0) {
        if (eyesOpen == tests[i].eyesOpen) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].meanFrequencyAP));
        }
      } else {
        if (eyesOpen == tests[i].eyesOpen && filter == tests[i].initCondition) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].meanFrequencyAP));
        }
      }

    return data;
  }

  /// Creates the data for the COGv ball chart
  static List<SeriesElem> _createMeanTimeSeries(List<Measurement> tests, bool eyesOpen, int filter) {

    List<SeriesElem> data = [];
    for(var i = 0; i < tests.length; i++)
      if (filter == 0) {
        if (eyesOpen == tests[i].eyesOpen) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].meanTime));
        }
      } else {
        if (eyesOpen == tests[i].eyesOpen && filter == tests[i].initCondition) {
          var dateString = DateFormat('yyyy-M-d H:m').parse(DateTime.fromMillisecondsSinceEpoch(tests[i].creationDate).toString());
          data.add(new SeriesElem(dateString, tests[i].meanTime));
        }
      }

    return data;
  }

}

/// Sway Path Series data type.
class SeriesElem {
  final DateTime time;
  final double value;

  SeriesElem(this.time, this.value);
}
