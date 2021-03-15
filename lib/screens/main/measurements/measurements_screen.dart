
import 'package:balance/bloc/main/measurements/measurements_bloc.dart';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/floor/test_database_view.dart';
import 'package:balance/screens/main/measurements/widgets/backend_status_dialog.dart';
import 'package:balance/screens/main/measurements/widgets/wrong_measurement_dialog.dart';
import 'package:balance/screens/res/b_icons.dart';
import 'package:balance/utils/boolean_quaternary_operator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:balance/routes.dart';
import 'package:easy_localization/easy_localization.dart';

class MeasurementsScreen extends StatefulWidget {
  MeasurementsScreen();

  @override
  _MeasurementsScreenState createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeasurementsBloc.create(Provider.of<MeasurementDatabase>(context, listen: false)),
      child: BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsEmpty)
            return _emptyScreen(context);
          else if (state is MeasurementsError)
            return _errorScreen(context);
          else if (state is MeasurementsSuccess) {
            state.tests.sort((a, b) => b.creationDate.compareTo(a.creationDate));
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) =>
                _measurementItemTemplate(context,state.tests[index]),
              itemCount: state.tests.length,
            );
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
            "assets/images/empty.png",
            fit: BoxFit.fitWidth,
          )
        ),
        SizedBox(height: 42),
        Text(
          'empty_txt'.tr(),
          style: Theme.of(context).textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
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
  Widget _measurementItemTemplate(BuildContext context, Test test) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.result,
          arguments: test
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
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
                          children: <Widget>[
                            Text(
                                "${'test_txt'.tr()} ${test?.id ?? ""}",
                                style: Theme.of(context).textTheme.headline4.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(children: <Widget>[
                          Icon(BIcons.calendar),
                          SizedBox(width: 16),
                          Text(
                            DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(test.creationDate)),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ]),
                        SizedBox(height: 8),
                        Row(children: <Widget>[
                          Icon(
                            bqtop(test?.eyesOpen, BIcons.eye_open, BIcons.eye_close),
                          ),
                          SizedBox(width: 16),
                          Text(
                            bqtop(test?.eyesOpen, 'eyes_open'.tr(), 'eyes_closed'.tr(), "-"),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ]),
                      ]
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          minWidth: 30.0,
                          height: 30.0,
                          color: test.invalid ? Colors.red : Colors.green,
                          splashColor: Colors.grey,
                          onPressed: () {
                            showMeasurementDialog(context, test.invalid ?? false);
                          },
                          child: test.invalid ? Icon(Icons.priority_high) : Icon(Icons.check),
                        ),
                        FlatButton(
                          minWidth: 30.0,
                          height: 30.0,
                          color: test.sent ? Colors.green : Colors.red ,
                          splashColor: Colors.grey,
                          onPressed: () async {
                            bool result = await showBackendStatusDialog(context, test.sent, test.id);
                            if (result)
                              BlocProvider.of<MeasurementsBloc>(context).add(
                                  MeasurementsEvents.fetch);
                          },
                          child: test.sent ? Icon(Icons.wifi) : Icon(Icons.signal_wifi_off),
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
}