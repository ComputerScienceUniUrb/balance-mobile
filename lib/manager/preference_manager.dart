
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balance_app/model/sensor_bias.dart';
import 'package:balance_app/model/user_info.dart';

class PreferenceManager {
  // First launch
  static const _isFirstTimeLaunch = "IsFirstTimeLaunch";
  // Show measuring tutorial
  static const _showTutorial = "ShowTutorial";
  // Calibration
  static const _isDeviceCalibrated = "IsDeviceCalibrated";
  // Accelerometer
  static const _accelerometerBiasX = "AccelerometerBiasX";
  static const _accelerometerBiasY = "AccelerometerBiasY";
  static const _accelerometerBiasZ = "AccelerometerBiasZ";
  // Gyroscope
  static const _gyroscopeBiasX = "GyroscopeBiasX";
  static const _gyroscopeBiasY = "GyroscopeBiasY";
  static const _gyroscopeBiasZ = "GyroscopeBiasZ";
  // User Info
  static const _height = "userHeight";
  static const _age = "userAge";
  static const _weight = "userWeight";
  static const _gender = "userGender";
  static const _posturalProblems = "posturalProblems";
  static const _problemsInFamily = "problemsInFamily";
  static const _useOfDrugs = "useOfDrugs";
  static const _otherTrauma = "otherTrauma";
  static const _sightProblems = "sightProblems";
  static const _hearingProblems = "hearingProblems";

  /// Is this the first time the app has been launched?
  static Future<bool> get isFirstTimeLaunch async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(_isFirstTimeLaunch) ?? true;
  }

  /// Mark the first time launch as done
  static Future<void> firstLaunchDone() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(_isFirstTimeLaunch, false);
  }

  /// Can show the measuring tutorial?
  static Future<bool> get showMeasuringTutorial async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(_showTutorial) ?? true;
  }

  /// Never show the tutorial again
  static Future<void> neverShowMeasuringTutorial() async{
    var pref = await SharedPreferences.getInstance();
    pref.setBool(_showTutorial, false);
  }

  /// The device is already calibrated?
  ///
  /// Returns a [Future] of [true] if the device is
  /// already calibrated, [false] otherwise.
  static Future<bool> get isDeviceCalibrated async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(_isDeviceCalibrated) ?? false;
  }

  /// Update the all sensors biases with fresh values
  ///
  /// Given an accelerometer [SensorBias] and a gyroscope
  /// [SensorBias] update their values into the [SharedPreferences]
  /// and set [_isDeviceCalibrated] to true.
  static Future<void> updateSensorBiases(SensorBias accBias, SensorBias gyroBias) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(_isDeviceCalibrated, true);
    pref.setDouble(_accelerometerBiasX, accBias?.x);
    pref.setDouble(_accelerometerBiasY, accBias?.y);
    pref.setDouble(_accelerometerBiasZ, accBias?.z);
    pref.setDouble(_gyroscopeBiasX, gyroBias?.x);
    pref.setDouble(_gyroscopeBiasY, gyroBias?.y);
    pref.setDouble(_gyroscopeBiasZ, gyroBias?.z);
  }

  /// Return a [Future] with accelerometer [SensorBias]
  ///
  /// This method will return the accelerometer
  /// [SensorBias] stored in [SharedPreferences];
  /// if the values are null [0.0] will be passed instead.
  static Future<SensorBias> get accelerometerBias async {
    var pref = await SharedPreferences.getInstance();
    double accX = pref.getDouble(_accelerometerBiasX) ?? 0.0;
    double accY = pref.getDouble(_accelerometerBiasY) ?? 0.0;
    double accZ = pref.getDouble(_accelerometerBiasZ) ?? 0.0;
    return SensorBias(accX, accY, accZ);
  }

  /// Return a [Future] with gyroscope [SensorBias]
  ///
  /// This method will return the gyroscope
  /// [SensorBias] stored in [SharedPreferences];
  /// if the values are null [0.0] will be passed instead.
  static Future<SensorBias> get gyroscopeBias async {
    var pref = await SharedPreferences.getInstance();
    double gyroX = pref.getDouble(_gyroscopeBiasX) ?? 0.0;
    double gyroY = pref.getDouble(_gyroscopeBiasY) ?? 0.0;
    double gyroZ = pref.getDouble(_gyroscopeBiasZ) ?? 0.0;
    return SensorBias(gyroX, gyroY, gyroZ);
  }

  /// Return the stored [UserInfo]
  ///
  /// This method parse the anamnesis data stored
  /// in the [SharedPreferences] and return them
  /// as an instance of [UserInfo].
  /// If the stored height is null the entire object
  /// will be null.
  /// If there is some error extracting
  /// the data the object will be null.
  static Future<UserInfo> get userInfo async {
    var pref = await SharedPreferences.getInstance();
    var height = pref.getDouble(_height);
    if (height == null) return null;
    try {
      return UserInfo(
        height: height,
        age: pref.getInt(_age), // Defaults to null
        weight: pref.getDouble(_weight), // Defaults to null
        gender: pref.getInt(_gender) ?? 0, // Defaults to unknown
        posturalProblems: pref.getString(_posturalProblems)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        problemsInFamily: pref.getBool(_problemsInFamily) ?? false, // Defaults to false
        useOfDrugs: pref.getBool(_useOfDrugs) ?? false, // Defaults to false
        otherTrauma: pref.getString(_otherTrauma)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        sightProblems: pref.getString(_sightProblems)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        hearingProblems: pref.getInt(_hearingProblems) ?? 0, // Defaults to none
      );
    } catch(_) {
      // Some error occurred... return a null object
      return null;
    }
  }

  /// Update the stored [UserInfo]
  ///
  /// This method updates the anamnesis data
  /// stored in the [SharedPreferences] with
  /// the given values.
  /// Only the non-null given values will be
  /// updated so this method can be with optional
  /// parameters to update only some of the data.
  static Future<void> updateUserInfo({
    double height,
    double weight,
    int age,
    int gender,
    List<bool> posturalProblems,
    bool problemsInFamily,
    bool useOfDrugs,
    List<bool> otherTrauma,
    List<bool> sightProblems,
    int hearingProblems,
  }) async {
    var pref = await SharedPreferences.getInstance();

    // Update the value of all the non-null given elements
    if (height != null)
      pref.setDouble(_height, height);
    if (age != null)
      pref.setInt(_age, age);
    if (weight != null)
      pref.setDouble(_weight, weight);
    if (gender != null)
      pref.setInt(_gender, gender);
    if (posturalProblems != null)
      pref.setString(_posturalProblems, posturalProblems.join(","));
    if (problemsInFamily != null)
      pref.setBool(_problemsInFamily, problemsInFamily);
    if (useOfDrugs != null)
      pref.setBool(_useOfDrugs, useOfDrugs);
    if (otherTrauma != null)
      pref.setString(_otherTrauma, otherTrauma.join(","));
    if (sightProblems != null)
      pref.setString(_sightProblems, sightProblems.join(","));
    if (hearingProblems != null)
      pref.setInt(_hearingProblems, hearingProblems);
  }
}