
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showAboutBalanceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('about_balance_title'.tr()),
      content: Text('about_balance_msg'.tr()),
      actions: [
        FlatButton(
          child: Text('cool_btn'.tr()),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}