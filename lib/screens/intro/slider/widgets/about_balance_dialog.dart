
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showDataInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black45,
      title:
      Text('other_trauma_title'.tr(),
        style: Theme.of(context).textTheme.subtitle2.copyWith(
        fontSize: 16,
        color: Colors.white,
      ),),
      content:
      Text('trauma_explained_txt'.tr(),
        style: Theme.of(context).textTheme.subtitle2.copyWith(
        fontSize: 12,
        color: Colors.white,
      ),),
      actions: [
        FlatButton(
          child: Text('close'.tr(),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontSize: 10,
            color: Colors.white,
          ),),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}

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