import 'package:dio/dio.dart';
import 'package:vtb_hackaton/data/data.dart';
import 'package:vtb_hackaton/data/session.dart';

class Balance {
  Balance._();

  static final instance = Balance._();

  double balance = 0.0;

  Future<double> get() async {
    Response resp = await Dio().get(
      "${Data.BalanceUrl}/810/balance/${Data.wallet}",
      options: Options(headers: {"FPSID": Session.instance.session_id}),
    );

    BalanceResp bData = BalanceResp.fromJson(resp.data);
    balance = bData.data.total;

    return balance;
  }
}

class BalanceResp {
  BalanceResp({this.timestamp, this.message, this.data});

  final String timestamp;
  final String message;
  final BalanceData data;

  factory BalanceResp.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String timestamp = json_data["timestamp"];
    final String message = json_data["message"];
    final BalanceData data = BalanceData.fromJson(json_data["data"]);

    return BalanceResp(
      timestamp: timestamp,
      message: message,
      data: data,
    );
  }
}

class BalanceData {
  BalanceData({this.currencyCode, this.address, this.total});

  final int currencyCode;
  final String address;
  final double total;

  factory BalanceData.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final int currencyCode = json_data["currencyCode"];
    final String address = json_data["address"];
    final double total = json_data["total"];

    return BalanceData(
      currencyCode: currencyCode,
      address: address,
      total: total,
    );
  }
}