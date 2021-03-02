
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/model/user_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Extension function used in [UserInfoRecapScreen].
extension _UserInfoIterableExtension on Iterable<bool> {
  /// Generate an [Iterable] of [int] where the elements
  /// are the index of all the elements with value true.
  Iterable<int> whereIndexed() sync*{
    for (var i = 0; i < this.length; i++)
      if (this.elementAt(i))
        yield i;
  }
}

class UserInfoRecapScreen extends StatelessWidget {
  /// Get the String of gender
  static String _getGenderString(int gender) {
    if (gender == null)
      return 'unknown_txt'.tr();

    switch(gender) {
      case 1:
        return 'male_txt'.tr();
      case 2:
        return 'female_txt'.tr();
      default:
        return 'unknown_txt'.tr();
    }
  }
  /// Get the String of posture problems
  static String _getPostureString(List<bool> list) {
    if (list == null || list.where((element) => element).isEmpty)
      return 'none_txt'.tr();

    final problems = ['scoliosis_txt'.tr(), 'kyphosis_txt'.tr(), 'lordosis_txt'.tr()];
    return "[${list.whereIndexed().map((e) => problems[e]).join(", ")}]";
  }
  /// Get the String of other trauma
  static String _getTraumaString(List<bool> list) {
    if (list == null || list.where((element) => element).isEmpty)
      return 'none_txt'.tr();

    final problems = ['fractures_txt'.tr(), 'limb_operations_txt'.tr(), 'falls_txt'.tr(), 'distortions_txt'.tr(), 'head_trauma'.tr()];
    return "[${list.whereIndexed().map((e) => problems[e]).join(", ")}]";
  }
  /// Get the String of sight problems
  static String _getSightString(List<bool> list) {
    if (list == null || list.where((element) => element).isEmpty)
      return 'none_txt'.tr();

    final problems = ['myopia_txt'.tr(), 'presbyopia_txt'.tr(), 'farsightedness_txt'.tr(), 'astigmatism_txt'.tr()];
    return "[${list.whereIndexed().map((e) => problems[e]).join(", ")}]";
  }
  /// Get the String of hearing problems
  static String _getHearingString(List<bool> list) {
    if (list == null || list.where((element) => element).isEmpty)
      return 'none_txt'.tr();

    final problems = ['Destro', 'Sinistro'];
    return "[${list.whereIndexed().map((e) => problems[e]).join(", ")}]";
  }
  /// Get the String of hearing problems
  static String _getSportString(int element) {
    final problems = ['nope_txt'.tr(), 'occasional_txt'.tr(), 'weekly_txt'.tr(), 'daily_txt'.tr()];
    return "${problems[element]}";
  }
  /// Get the String of hearing problems
  static String _getAlcoholString(int element) {
    final problems = ['nope_txt'.tr(), 'abstemious_txt'.tr(), 'occasional_txt'.tr(), 'at_meals_txt'.tr(), 'outside_meals_txt'.tr()];
    return "${problems[element]}";
  }


  @override
  Widget build(BuildContext context) {
    // Text styles used by the widget
    final titleTextStyle = Theme.of(context).textTheme.subtitle2.copyWith(
      fontSize: 17,
    );
    final headlineTextStyle = Theme.of(context).textTheme.bodyText1;
    final valueTextStyle = Theme.of(context).textTheme.caption;

    return Scaffold(
      appBar: AppBar(
        title: Text('your_personal_info_txt'.tr()),
      ),
      body: FutureBuilder(
        future: PreferenceManager.userInfo,
        builder: (context, snapshot) {
          // Show loading screen
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          final userInfo = snapshot.data as UserInfo;
          return ListView(
            children: <Widget>[
              //// General Info Card
              Card(
                margin: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'general_title'.tr(),
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Token',
                            style: headlineTextStyle,
                          ),
                          Spacer(),
                          Flexible(
                            child: Text(
                              userInfo?.token?.toString() ?? "-",
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'age_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            userInfo?.age?.toString() ?? "-",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'gender_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            _getGenderString(userInfo?.gender),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'height_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            userInfo?.height != null
                                ? "${userInfo.height.toStringAsFixed(1)} cm"
                                : "-",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'weight_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            userInfo?.weight != null
                                ? "${userInfo.weight.toStringAsFixed(1)} Kg"
                                : "-",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Health Info Card
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'health_title'.tr(),
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'postural_problems_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              _getPostureString(userInfo?.posturalProblems),
                              style: valueTextStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'postural_problems_in_family_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            userInfo != null && userInfo.problemsInFamily ? 'yes'.tr() : 'no'.tr(),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'other_trauma_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          SizedBox(width: 16),
                          Flexible(
                              child: Text(
                                _getTraumaString(userInfo?.physicalTrauma),
                                style: valueTextStyle,
                                textAlign: TextAlign.end,
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Sight/Hear Defects Info Card
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'hearing_defects_title'.tr(),
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'wear_glasses_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              userInfo != null && userInfo.visionLoss ? 'yes'.tr() : 'no'.tr(),
                              style: valueTextStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'sight_defects_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              _getSightString(userInfo?.visionProblems),
                              style: valueTextStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'hearing_defects_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            userInfo != null && userInfo.hearingLoss ? 'yes'.tr() : 'no'.tr(),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'which_hear_txt'.tr(),
                            style: headlineTextStyle,
                          ),
                          Text(
                            _getHearingString(userInfo?.hearingProblems),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Trauma Info Card
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'habits_txt'.tr(),
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                'drugs_txt'.tr(),
                                style: headlineTextStyle,
                              )
                          ),
                          Text(
                            userInfo != null && userInfo.useOfDrugs ? 'yes'.tr() : 'no'.tr(),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                'sport_txt'.tr(),
                                style: headlineTextStyle,
                              )
                          ),
                          Text(
                            _getSportString(userInfo?.sportsActivity),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                'alcohol_txt'.tr(),
                                style: headlineTextStyle,
                              )
                          ),
                          Text(
                            _getAlcoholString(userInfo?.alcoholIntake),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        },
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () async {
      //    // Open the onboarding route with UserInfo from memory
      //    Navigator.pushNamed(
      //      context,
      //      Routes.onboarding,
      //      arguments: await PreferenceManager.userInfo
      //    );
      //  },
      //  child: Icon(Icons.edit),
      //),
    );
  }
}
