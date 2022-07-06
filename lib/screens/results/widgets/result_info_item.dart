
import 'package:balance/floor/test_database_view.dart';
import 'package:balance/screens/res/b_icons.dart';
import 'package:balance/utils/boolean_quaternary_operator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget that represent a single result info item
///
/// This Widget displays a Card containing the date and
/// eye information of a given [Test]
class ResultInfoItem extends StatelessWidget {
  final Test test;

  ResultInfoItem(this.test);

  List<String> _translateInitCondition =[
    "condition_rest_txt".tr(),
    "condition_work_txt".tr(),
    "condition_walk_txt".tr(),
    "condition_read_txt".tr(),
    "condition_eat_txt".tr(),
    "condition_party_txt".tr(),
    "condition_sport_txt".tr()
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(BIcons.calendar, color: Theme.of(context).iconTheme.color),
                SizedBox(width: 16),
                Text(
                  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(test?.creationDate ?? 0)),
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  bqtop(test?.eyesOpen, BIcons.eye_open, BIcons.eye_close),
                ),
                SizedBox(width: 16),
                Text(
                  bqtop(test?.eyesOpen, 'eyes_open'.tr(), 'eyes_closed'.tr(), "-"),
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            SizedBox(height: 8),
            test.initialCondition != null?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                      ),
                      SizedBox(width: 16),
                      Text(
                        test.initialCondition == null? "no_condition".tr():_translateInitCondition[test.initialCondition-1],
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ]
                ),
              ],
            )
            :
            SizedBox(height: 0),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        bqtop(test?.note != null && test?.note != "", Icons.speaker_notes, Icons.speaker_notes_off),
                      ),
                      SizedBox(width: 16),
                      Text(
                        bqtop(test?.note != null && test?.note != "", test?.note, 'note_no_generic_txt'.tr(), "-"),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}