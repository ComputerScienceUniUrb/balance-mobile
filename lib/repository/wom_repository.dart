import 'dart:async';
import 'dart:io';
import 'package:balance/floor/measurement_database.dart';
import 'package:balance/model/wom_voucher.dart';
import 'package:http/http.dart';


class WomRepository {
  final MeasurementDatabase database;

  WomRepository(this.database);

  /// Creates a new [WOM]
  Future<bool> createWomVoucher(String token, int test) async {
    final womDao = database.womDao;

    try {
      // Create and insert a new WOM
      await womDao.insertWom(
        WomVoucher.create(
          token: token,
          test: test
        ),
      );

      // Send data to server
      WomVoucher voucher = await womDao.getWom(token, test);
      _makePostRequest(voucher);

      // return the newly added Test
      return true;
    } catch(e) {
      print("WomVoucherRepository.createWomVoucher: Error $e");
      return false;
    }
  }

  /// Return all registered Wom Vouchers
  Future<List<WomVoucher>> getAllWom() async {
    return database.womDao.getAllWom();
  }

  Future<bool> _makePostRequest(WomVoucher voucher) async {
    // set up POST request arguments
    String url = 'https://www.balancemobile.it/api/v1/db/wom';
    //String url = 'https://www.dev.balancemobile.it/api/v1/db/wom';
    Map<String, String> headers = {"Content-type": "application/json"};


    try {
      Response response = await post(url, headers: headers, body: voucher.toJson()).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return true;
      } else {
        print("_SendingData.RequestVoucher: The server answered with: "+response.statusCode.toString());
        return false;
      }
    } on TimeoutException catch (_) {
      print("_SendingData.RequestVoucher: The connection dropped, maybe the server is congested");
      return false;
    } on SocketException catch (_) {
      print("_SendingData.RequestVoucher: Communication failed. The server was not reachable");
      return false;
    }
  }
}