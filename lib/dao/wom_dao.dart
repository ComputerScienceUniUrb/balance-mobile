
import 'package:balance/model/wom_voucher.dart';
import 'package:floor/floor.dart';

/// DAO class declaring the database operations for [WomVoucher]
@dao
abstract class WomDao {
  /// Insert a new [WomVoucher] into the database
  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertWom(WomVoucher wom);

  /// Updates an already existing [WomVoucher]
  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateWom(WomVoucher wom);

  /// Returns a [Future] with a [List] of all the [WomVoucher]s inside the database
  @Query("SELECT * FROM wom_vouchers WHERE token = :token AND test = :test")
  Future<WomVoucher> getWom(String token, int test);

  /// Returns a [Future] with a [List] of all the [WomVoucher]s inside the database
  @Query("SELECT * FROM wom_vouchers")
  Future<List<WomVoucher>> getAllWom();

  /// Returns a specific [WomVoucher] based on the given [id]
  @Query("SELECT * FROM wom_vouchers WHERE id = :id")
  Future<WomVoucher> findWomById(int id);
}