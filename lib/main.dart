
import 'dart:io';

import 'package:balance_app/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:balance_app/res/theme.dart';

import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:easy_localization/easy_localization.dart';
import 'package:balance_app/generated/codegen_loader.g.dart';

import 'package:balance_app/floor/measurement_database.dart';
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/routes.dart';
import 'package:balance_app/screens/main_screen.dart';

import 'package:balance_app/screens/intro_screen.dart';
import 'package:balance_app/screens/result_screen.dart';
import 'package:balance_app/screens/calibrate_device_screen.dart';
import 'package:balance_app/screens/onboarding_screen.dart';
import 'package:balance_app/screens/user_info_recap_screen.dart';
import 'package:balance_app/screens/open_source_screen.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	// Create an app-wide instance of the database
	final isFirstTimeLaunch = await PreferenceManager.isFirstTimeLaunch;
	final dbInstance = await MeasurementDatabase.getDatabase();
	await intl.initializeDateFormatting("en");
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
						Routes.personal_info_recap: (_) => UserInfoRecapScreen(),
						Routes.onboarding: (_) => OnBoardingScreen(),
						Routes.result: (_) => ResultScreen(),
						Routes.open_source: (_) => OpenSourceScreen(),
					},
				),
			),
		);
  }
}
