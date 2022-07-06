
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balance/model/sensor_bias.dart';
import 'package:balance/model/user_info.dart';
import 'package:balance/model/system_info.dart';

class PreferenceManager {
  // First launch
  static const _isFirstTimeLaunch = "IsFirstTimeLaunch";
  // Show measuring tutorial
  static const _showTutorial = "ShowTutorial";
  // Calibration
  static const _isDeviceCalibrated = "IsDeviceCalibrated";
  // Initial Condition
  static const _initialCondition = "initialCondition";
  // Accelerometer
  static const _accelerometerBiasX = "AccelerometerBiasX";
  static const _accelerometerBiasY = "AccelerometerBiasY";
  static const _accelerometerBiasZ = "AccelerometerBiasZ";
  // Gyroscope
  static const _gyroscopeBiasX = "GyroscopeBiasX";
  static const _gyroscopeBiasY = "GyroscopeBiasY";
  static const _gyroscopeBiasZ = "GyroscopeBiasZ";
  // System Info
  static const _producer = "Producer";
  static const _model = "Model";
  static const _appVersion = "AppVersion";
  static const _osVersion = "OsVersion";
  // User Info
  static const _token = "userToken";
  static const _height = "userHeight";
  static const _age = "userAge";
  static const _weight = "userWeight";
  static const _gender = "userGender";
  static const _posturalProblems = "posturalProblems";
  static const _problemsInFamily = "problemsInFamily";
  static const _useOfDrugs = "useOfDrugs";
  static const _alcoholIntake = "alcoholIntake";
  static const _sportsActivity = "sportsActivity";
  static const _otherTrauma = "otherTrauma";
  static const _visionLoss = "visionLoss";
  static const _sightProblems = "sightProblems";
  static const _hearingLoss = "hearingLoss";
  static const _hearingProblems = "hearingProblems";
  // Archived Wom List
  static const _archivedWom = "archivedWom";

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
  static Future<void> updateInitialCondition(int condition) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt(_initialCondition, condition);
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

  /// Update the system info
  ///
  /// Given a system update [SystemInfo] into the [SharedPreferences].
  static Future<void> updateSystemInfo({String token, String producer, String model, String appVersion, String osVersion}) async {
    var pref = await SharedPreferences.getInstance();

    // Update the value of all the non-null given elements
    if (token != null)
      pref.setString(_token, token);
    if (producer != null)
      pref.setString(_producer, producer);
    if (model != null)
      pref.setString(_model, model);
    if (appVersion != null)
      pref.setString(_appVersion, appVersion);
    if (osVersion != null)
      pref.setString(_osVersion, osVersion);
  }

  /// Return a [Future] with accelerometer [SensorBias]
  ///
  /// This method will return the accelerometer
  /// [SensorBias] stored in [SharedPreferences];
  /// if the values are null [0.0] will be passed instead.
  static Future<int> get initialCondition async {
    var pref = await SharedPreferences.getInstance();
    return pref.getInt(_initialCondition) ?? 0;
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

  /// Return a [Future] with gyroscope [SystemInfo]
  ///
  /// This method will return the system data
  /// [SystemInfo] stored in [SharedPreferences];
  /// if the values are null [0.0] will be passed instead.
  static Future<SystemInfo> get systemInfo async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString(_token);
    String producer = pref.getString(_producer);
    String model = pref.getString(_model);
    String appVersion = pref.getString(_appVersion);
    String osVersion = pref.getString(_osVersion);
    return SystemInfo(token: token,
                      producer: producer,
                      model: model,
                      app_version: appVersion,
                      os_version: osVersion);
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
    var height = pref.getInt(_height);
    if (height == null) return null;
    try {
      return UserInfo(
        token: pref.getString(_token) ?? '',
        height: height,
        age: pref.getInt(_age), // Defaults to null
        weight: pref.getInt(_weight), // Defaults to null
        gender: pref.getInt(_gender) ?? 0, // Defaults to unknown
        posturalProblems: pref.getString(_posturalProblems)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        problemsInFamily: pref.getBool(_problemsInFamily) ?? false, // Defaults to false
        useOfDrugs: pref.getBool(_useOfDrugs) ?? false, // Defaults to false
        alcoholIntake: pref.getInt(_alcoholIntake) ?? 0, // Defaults to false
        sportsActivity: pref.getInt(_sportsActivity) ?? 0, // Defaults to false
        physicalTrauma: pref.getString(_otherTrauma)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        visionLoss: pref.getBool(_visionLoss) ?? false,
        visionProblems: pref.getString(_sightProblems)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
        hearingLoss: pref.getBool(_hearingLoss) ?? false,
        hearingProblems: pref.getString(_hearingProblems)
          ?.split(",")
          ?.map((e) => e == 'true')
          ?.toList(), // Defaults to null
      );
    } catch(e) {
      // Some error occurred... return a null object
      print("_PreferenceManager.get.userInfo: "+e.toString());
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
    String token,
    int height,
    int weight,
    int age,
    int gender,
    List<bool> posturalProblems,
    bool problemsInFamily,
    bool useOfDrugs,
    int alcoholIntake,
    int sportsActivity,
    List<bool> physicalTrauma,
    bool visionLoss,
    List<bool> visionProblems,
    bool hearingLoss,
    List<bool> hearingProblems,
  }) async {
    var pref = await SharedPreferences.getInstance();

    // Update the value of all the non-null given elements
    if (token != null)
      pref.setString(_token, token);
    if (height != null)
      pref.setInt(_height, height);
    if (age != null)
      pref.setInt(_age, age);
    if (weight != null)
      pref.setInt(_weight, weight);
    if (gender != null)
      pref.setInt(_gender, gender);
    if (posturalProblems != null)
      pref.setString(_posturalProblems, posturalProblems.join(","));
    if (problemsInFamily != null)
      pref.setBool(_problemsInFamily, problemsInFamily);
    if (useOfDrugs != null)
      pref.setBool(_useOfDrugs, useOfDrugs);
    if (alcoholIntake != null)
      pref.setInt(_alcoholIntake, alcoholIntake);
    if (sportsActivity != null)
      pref.setInt(_sportsActivity, sportsActivity);
    if (physicalTrauma != null)
      pref.setString(_otherTrauma, physicalTrauma.join(","));
    if (visionLoss != null)
      pref.setBool(_visionLoss, visionLoss);
    if (visionProblems != null)
      pref.setString(_sightProblems, visionProblems.join(","));
    if (hearingLoss != null)
      pref.setBool(_hearingLoss, hearingLoss);
    if (hearingProblems != null)
      pref.setString(_hearingProblems, hearingProblems.join(","));
  }

  /// Is this the first time the app has been launched?
  static Future<List<int>> get archivedWom async {
    var pref = await SharedPreferences.getInstance();
    var list = pref.getStringList(_archivedWom) ?? List.empty();
    return [for (var i = 0; i < list.length; i++) int.parse(list[i])];
  }

  /// Update the archived [ArchivedWom]
  ///
  /// This method updates the Wom archived
  /// by the user.
  static Future<void> updateArchivedWom({
    int index
  }) async {
    var pref = await SharedPreferences.getInstance();

    // Update the value of all the non-null given elements
    if (index != null) {
      var intList = pref.getStringList(_archivedWom) ?? List.empty();
      var stringList = [for (var i = 0; i < intList.length; i++) intList[i].toString()];
      stringList.add(index.toString());
      pref.setStringList(_archivedWom, stringList);
    }
  }

  /// Reset the archived [ArchivedWom]
  ///
  /// This method updates the Wom archived
  /// by the user.
  static Future<void> resetArchivedWom() async {
    var pref = await SharedPreferences.getInstance();
    pref.setStringList(_archivedWom, List<String>());
  }
}