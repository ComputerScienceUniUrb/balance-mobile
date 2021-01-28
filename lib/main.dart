import 'dart:io';

import 'package:balance_app/screens/res/colors.dart';
import 'package:balance_app/screens/res/theme.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:easy_localization/easy_localization.dart';
import 'package:balance_app/generated/codegen_loader.g.dart';

import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/routes.dart';
import 'package:balance_app/screens/main/main_screen.dart';

import 'package:balance_app/screens/intro/intro_screen.dart';
import 'package:balance_app/screens/results/result_screen.dart';
import 'package:balance_app/screens/calibration/calibrate_device_screen.dart';
import 'package:balance_app/screens/info/user_info_recap_screen.dart';
import 'package:balance_app/screens/opensource/open_source_screen.dart';
import 'package:balance_app/screens/slider_screen.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	// Create an app-wide instance of the database
	final isFirstTimeLaunch = await PreferenceManager.isFirstTimeLaunch;
	final dbInstance = await MeasurementDatabase.getDatabase();
	await intl.initializeDateFormatting("en");

	if (Platform.isAndroid) {
		var androidInfo = await DeviceInfoPlugin().androidInfo;
		var release = androidInfo.version.release;
		var sdkInt = androidInfo.version.sdkInt;
		var manufacturer = androidInfo.manufacturer;
		var model = androidInfo.model;
		PreferenceManager.updateSystemInfo(manufacturer, model, "alpha.5", "Android "+release+" SDK "+sdkInt.toString());
	}

	if (Platform.isIOS) {
		var iosInfo = await DeviceInfoPlugin().iosInfo;
		var systemName = iosInfo.systemName;
		var version = iosInfo.systemVersion;
		var name = iosInfo.name;
		var model = iosInfo.model;
		PreferenceManager.updateSystemInfo("Apple", name, "alpha.5", systemName+" "+version);
	}

	runApp(
		EasyLocalization(
			child: BalanceApp(isFirstTimeLaunch, dbInstance),
			supportedLocales: [Locale("en"), Locale("it")],
			fallbackLocale: Locale("en"),
			path: "assets/translations",
			assetLoader: CodegenLoader(),
			preloaderColor: BColors.colorPrimary,
		)
	);
}

class BalanceApp extends StatelessWidget {
	final bool isFirstLaunch;
	final MeasurementDatabase dbInstance;

	const BalanceApp(this.isFirstLaunch, this.dbInstance);

	@override
  Widget build(BuildContext context) {
		SystemChrome.setPreferredOrientations([
			DeviceOrientation.portraitUp,
			DeviceOrientation.portraitDown,
		]);
		return Builder(
			builder: (context) => MultiProvider(
				providers: [
					Provider<MeasurementDatabase>(create: (context) => dbInstance),
				],
			  child: MaterialApp(
					title: "Balance",
					initialRoute: isFirstLaunch ? Routes.intro: Routes.main,
					theme: lightTheme,
					darkTheme: darkTheme,
					routes: {
						Routes.intro: (_) => IntroScreen(),
						Routes.main: (_) => MainScreen(),
						Routes.calibration: (_) => CalibrateDeviceScreen(),
						Routes.info: (_) => UserInfoRecapScreen(),
						Routes.slider: (_) => SliderScreen(),
						Routes.result: (_) => ResultScreen(),
						Routes.open_source: (_) => OpenSourceScreen(),
					},
				),
			),
		);
  }
}
