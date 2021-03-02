/// Class that store system information
class SystemInfo {
  final String token;
  final String producer;
  final String model;
  final String app_version;
  final String os_version;

  SystemInfo({
    this.token,
    this.producer,
    this.model,
    this.app_version,
    this.os_version,
  });

  /// Maps this object to json
  Map<String, dynamic> toJson() =>
      {
        'token': this.token,
        'producer': this.producer,
        'model': this.model,
        'app_version': this.app_version,
        'os_version': this.os_version,
      };

  /// Print as String
  @override
  String toString() =>
      "UserInfo("
        "token=$token, "
        "producer=$producer, "
        "model=$model, "
        "app_version=$app_version, "
        "os_version=$os_version"
      ")";
}