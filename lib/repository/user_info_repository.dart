
import 'package:balance/manager/preference_manager.dart';
import 'package:balance/model/user_info.dart';

/// Repository class used to get the user information
/// stored in the preferences
class UserInfoRepository {

  /// Return a [Future] of [UserInfo] object from [UserInfoManager]
  Future<UserInfo> getUserInfo() => PreferenceManager.userInfo;
}