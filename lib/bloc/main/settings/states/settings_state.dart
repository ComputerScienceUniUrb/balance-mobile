
import 'package:balance/model/wom_voucher.dart';

/// Base State of the measurements page
abstract class SettingsState {
  const SettingsState();
}

/// State for when there is no data
class SettingsEmpty extends SettingsState {}

/// State for when the loading
class SettingsLoading extends SettingsState {}

/// State for when the data is retrieved successfully
class SettingsSuccess extends SettingsState {
  final List<WomVoucher> woms;
  final List<int> archived;
  const SettingsSuccess(this.woms, this.archived);
}

/// State for when there is an error
class SettingsError extends SettingsState {
  final String exceptionMsg;
  const SettingsError(this.exceptionMsg);
}