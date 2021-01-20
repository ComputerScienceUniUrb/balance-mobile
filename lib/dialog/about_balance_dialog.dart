
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showDataInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:
      Text('other_trauma_title'.tr(),
        style: Theme.of(context).textTheme.subtitle2.copyWith(
        fontSize: 16,
        color: Colors.white,
      ),),
      content:
      Text('Fratture: una frattura é l\'interruzione dell\'integrità strutturale delle ossa\n\nOperazioni agli arti: Sono interventi chirurgici volti a riparare una lesione grave a carico di un arto\n\nCadute: cadere provoca generalmente contusioni ma può avere risvolti ben più gravi. È il tuo caso?\n\nDistorsioni: una distorsione è la perdita della congruità articolare in seguito ad un movimento anomalo a carico di un articolazione.\n\nTraumi cranici: il trauma cranico è un danno che coinvolge il distretto cranio-encefalico. A volte può essere davvero molto grave.',
        style: Theme.of(context).textTheme.subtitle2.copyWith(
        fontSize: 12,
        color: Colors.white,
      ),),
      actions: [
        FlatButton(
          child: Text('Chiudi',
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