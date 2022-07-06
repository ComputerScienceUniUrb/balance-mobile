import 'dart:io';

import 'package:balance/bloc/intro_state/on_boarding_data_bloc.dart';
import 'package:balance/bloc/main/home/countdown_bloc_impl.dart';
import 'package:balance/bloc/main/settings/settings_bloc_impl.dart';
import 'package:balance/screens/calibration/quick_calibration_screen.dart';
import 'package:balance/screens/info/wom_recap_screen.dart';
import 'package:balance/screens/issues/issues_screen.dart';
import 'package:balance/screens/main/charts/chart_screen.dart';
import 'package:balance/screens/res/colors.dart';
import 'package:balance/screens/res/theme.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:easy_localization/easy_localization.dart';
import 'package:balance/generated/codegen_loader.g.dart';

import 'package:balance/floor/measurement_database.dart';
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/routes.dart';
import 'package:balance/screens/main/main_screen.dart';

import 'package:balance/screens/intro/intro_screen.dart';
import 'package:balance/screens/results/result_screen.dart';
import 'package:balance/screens/calibration/calibrate_device_screen.dart';
import 'package:balance/screens/info/user_info_recap_screen.dart';
import 'package:balance/screens/opensource/open_source_screen.dart';
import 'package:balance/screens/slider_screen.dart';
import 'package:balance/screens/credits/credits.dart';

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
		PreferenceManager.updateSystemInfo(producer: manufacturer, model: model, appVersion: "beta.5", osVersion: "Android "+release+" SDK "+sdkInt.toString());
	}

	if (Platform.isIOS) {
		var iosInfo = await DeviceInfoPlugin().iosInfo;
		var systemName = iosInfo.systemName;
		var version = iosInfo.systemVersion;
		var name = iosInfo.name;
		//var model = iosInfo.model;
		PreferenceManager.updateSystemInfo(producer: "Apple", model: name, appVersion: "beta.5", osVersion: systemName+" "+version);
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
					routes: {
						Routes.intro: (_) => BlocProvider(child: IntroScreen(), create: (context) => OnBoardingDataBloc()),
						Routes.main: (_) => BlocProvider(child: MainScreen(), create: (context) => CountdownBloc.create(Provider.of<MeasurementDatabase>(context, listen: false))),
						Routes.quick_calibration: (_) => QuickCalibrationScreen(),
						Routes.calibration: (_) => CalibrateDeviceScreen(),
						Routes.info: (_) => UserInfoRecapScreen(),
						Routes.slider: (_) => SliderScreen(),
						Routes.credits: (_) => CreditsScreen(),
						Routes.issues: (_) => IssuesScreen(),
						Routes.wom: (_) => BlocProvider(child: WOMScreen(), create: (context) => SettingsBloc.create(Provider.of<MeasurementDatabase>(context, listen: false))),
						Routes.result: (_) => ResultScreen(),
						Routes.charts: (_) => ChartsScreen(),
						Routes.open_source: (_) => OpenSourceScreen(),
					},
				),
			),
		);
	}
}
