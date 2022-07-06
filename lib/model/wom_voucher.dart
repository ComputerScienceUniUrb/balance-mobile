
import 'package:floor/floor.dart';

/// Represent one single voucher in the database
@Entity(tableName: "wom_vouchers")
class WomVoucher {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: "token", nullable: false)
  final String token;
  @ColumnInfo(name: "test", nullable: false)
  final int test;
  @ColumnInfo() final String otc;
  @ColumnInfo() final String password;

  WomVoucher({
    this.id,
    this.token,
    this.test,
    this.otc,
    this.password
  });

  /// Creates a simple instance of [WomVoucher].
  ///
  /// This factory method return a new instance
  /// of [WomVoucher] with [token], [test] and auto-incremented [id].
  /// The other parameters will be set to an empty string.
  factory WomVoucher.create({
    String token,
    int test,
  }) => WomVoucher(token: token, test: test, otc: "", password: "");

  /// Creates a simple instance of [WomVoucher].
  ///
  /// This factory method return a new instance
  /// of [WomVoucher] from [WomVoucher] already available, updating  and auto-incremented [id].
  /// The other parameters will be set to an empty string.
  factory WomVoucher.update(WomVoucher voucher, String otc, String password) =>
      WomVoucher(
          id: voucher.id,
          token: voucher.token,
          test: voucher.test,
          otc: otc,
          password: password
      );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'token': this.token,
    'test': this.test,
    'otc': this.otc,
    'password': this.password
  };

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is WomVoucher &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        token == other.token &&
        test == other.test &&
        otc == other.otc &&
        password == other.password;

  @override
  int get hashCode =>
    id.hashCode ^
    token.hashCode ^
    test.hashCode ^
    otc.hashCode ^
    password.hashCode;

  @override
  String toString() {
    return 'WomVoucher(id: $id, token: $token, test: $test, otc: $otc, password: $password)';
  }
}