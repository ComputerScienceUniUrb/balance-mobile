
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:balance/screens/res/b_icons.dart';

import 'package:balance/routes.dart';
import 'package:balance/screens/main/settings/widgets/settings_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo packageInfo;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() => packageInfo = value));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SettingsGroup(
          title: 'calibration_title'.tr(),
          children: [
            SettingsElement(
              icon: Icon(BIcons.calibration),
              text: 'calibrate_your_device_txt'.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.calibration),
            ),
          ],
        ),
        SettingsGroup(
          title: 'your_information_title'.tr(),
          children: [
            SettingsElement(
              icon: Icon(BIcons.info_outline),
              text: 'what_we_know_about_you_txt'.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.info),
            )
          ]
        ),
        SettingsGroup(
          title: 'legals_title'.tr(),
          children: [
            SettingsElement(
              icon: Icon(BIcons.opensource),
              text: 'open_source_txt'.tr(),
              onTap: () => Navigator.of(context).pushNamed(Routes.open_source),
            ),
          ]
        ),
        SettingsGroup(
          title: 'about_title'.tr(),
          children: [
            SettingsElement(
              icon: Image.asset("assets/app_logo.png", width: 24, height: 24,),
              text: 'about_balance_txt'.tr(),
              onTap: () => Navigator.of(context).pushNamed(Routes.credits),
            ),
          ]
        ),
        SettingsGroup(
            title: 'report_title'.tr(),
            children: [
              SettingsElement(
                  icon: Icon(BIcons.version),
                  text: "report_issue_title".tr(),
                  //text: "${'version_txt'.tr()} ${packageInfo?.version} (${'build_txt'.tr()}${packageInfo?.buildNumber})",
                  onTap: () => Navigator.of(context).pushNamed(Routes.issues),
              ),
            ]
        ),
        //SettingsGroup(
        //  title: 'version_txt'.tr(),
        //  children: [
        //    SettingsElement(
        //        icon: Icon(BIcons.version),
        //        text: "${'version_txt'.tr()} ${packageInfo?.version} (${'build_txt'.tr()}${packageInfo?.buildNumber})",
        //        onLongPress: () {
        //          Scaffold.of(context)
        //              .showSnackBar(
        //              SnackBar(
        //                behavior: SnackBarBehavior.floating,
        //                content: Text('easter_egg_txt'.tr()),
        //                duration: Duration(seconds: 2),
        //              )
        //          );
        //        }
        //    ),
        //  ]
        //),
      ]
    );
  }
}