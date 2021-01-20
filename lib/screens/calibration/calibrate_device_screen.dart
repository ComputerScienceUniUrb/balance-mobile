
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/model/sensor_bias.dart';
import 'package:balance_app/model/sensor_data.dart';
import 'package:balance_app/sensors/sensor_widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// This Widget represent the Calibrate Device Screen
///
/// His purpose is to display all the calibration related
/// UI and let the user calibrate his phone before any
/// test. The calibration is achieved through [CalibrationHelper].
class CalibrateDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calibrate_txt'.tr())),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: SensorWidget(
            duration: Duration(seconds: 10),
            builder: (context, controller) {
              final state = controller.state;
              // Calibration completed... Compute and save the SensorBiases
              if (state == SensorController.complete)
                PreferenceManager.updateSensorBiases(
                  _computeAccelerometerBias(controller.result),
                  _computeGyroscopeBias(controller.result)
                );
              // Return the child widget containing the UI elements
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Image.asset("assets/images/phone.png")),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _makeTextElements(context, state),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                            onPressed: state == SensorController.listening
                              ? null
                              : () => controller.listen(),
                            child: Text(
                              state == SensorController.complete
                                ? 'calibrate_again_btn'.tr()
                                : 'start_calibration_btn'.tr()
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                ],
              );
            }
          ),
      ),
    );
  }

  /// Returns the correct block of widgets based
  /// on the current state of the calibration
  Widget _makeTextElements(BuildContext context, int state) {
    switch (state) {
      // Display the progress bar and the calibrating texts
      case SensorController.listening:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 300, height: 3, child: LinearProgressIndicator()),
              SizedBox(height: 32),
              Text(
                'calibrating_txt'.tr(),
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8),
              Text(
                'do_not_move_the_device_txt'.tr(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        break;
      // Display the calibration complete text
      case SensorController.complete:
        return Container(
          child: Text(
            'calibration_completed_txt'.tr(),
            style: Theme.of(context).textTheme.headline5,
          ),
        );
        break;
      // Display the calibration guide text
      default:
        return Container(
          child: Text(
            'calibration_message_txt'.tr(),
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        );
        break;
    }
  }

  /// Compute the [SensorBias] for given accelerometer values
  SensorBias _computeAccelerometerBias(List<SensorData> result) {
    if (result.isEmpty) return null;
    double xSum = 0, ySum = 0, zSum = 0;
    for (var data in result){
      xSum += data.accelerometerX ?? 0;
      ySum += data.accelerometerY ?? 0;
      zSum += data.accelerometerZ ?? 0;
    }
    return SensorBias(
      (xSum / result.length) - 0.0,
      (ySum / result.length) - 0.0,
      (zSum / result.length) - 9.806,
    );
  }

  /// Compute the [SensorBias] for given gyroscope values
  SensorBias _computeGyroscopeBias(List<SensorData> result) {
    if (result.isEmpty) return null;
    double xSum = 0, ySum = 0, zSum = 0;
    for (var data in result) {
      xSum += data.gyroscopeX ?? 0;
      ySum += data.gyroscopeY ?? 0;
      zSum += data.gyroscopeZ ?? 0;
    }
    return SensorBias(
      (xSum / result.length) - 0.0,
      (ySum / result.length) - 0.0,
      (zSum / result.length) - 0.0,
    );
  }
}