import 'package:dio/dio.dart';
import 'package:vtb_hackaton/data/data.dart';
import 'package:vtb_hackaton/data/session.dart';

class Transactions {
  Transactions._();

  static final instance = Transactions._();

  List<Transaction> transactions = [];

  Future<List<Transaction>> get() async {
    Response resp = await Dio().get(
      "${Data.TransactionsUrl}/810/history/${Data.wallet}/all",
      options: Options(headers: {"FPSID": Session.instance.session_id}),
    );

    TransactionsResp transactionsResp = TransactionsResp.fromJson(resp.data);
    transactions = transactionsResp.data;

    return transactionsResp.data;
  }
}

class TransactionsResp {
  TransactionsResp({this.timestamp, this.message, this.data});

  final String timestamp;
  final String message;
  final List<Transaction> data;

  factory TransactionsResp.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String timestamp = json_data["timestamp"];
    final String message = json_data["message"];
    final List<dynamic> tmp_data = json_data["data"];

    final List<Transaction> goodData = [];

    for (int i = 0; i < tmp_data.length; i++) {
      goodData.add(Transaction.fromJson(tmp_data[i]));
    }

    return TransactionsResp(
      timestamp: timestamp,
      message: message,
      data: goodData,
    );
  }
}

class Transaction {
  Transaction({
    this.txId,
    this.txType,
    this.timestamp,
    this.currencyCode,
    this.addressFrom,
    this.addressTo,
    this.payload,
    this.amount,
    this.status,
    this.atc,
    this.errorCode,
    this.errorData,
  });

  String txId;
  int txType;
  int timestamp;
  int currencyCode;
  String addressFrom;
  String addressTo;
  String payload;
  double amount;
  int status;
  int atc;
  int errorCode;
  String errorData;

  factory Transaction.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String txId = json_data["txId"];
    final int txType = json_data["txType"];
    final int timestamp = json_data["timestamp"];
    final int currencyCode = json_data["currencyCode"];
    final String addressFrom = json_data["addressFrom"];
    final String addressTo = json_data["addressTo"];
    final String payload = json_data["payload"];
    final double amount = json_data["amount"];
    final int status = json_data["status"];
    final int atc = json_data["atc"];
    final int errorCode = json_data["errorCode"];
    final String errorData = json_data["errorData"];

    return Transaction(
      txId: txId,
      txType: txType,
      timestamp: timestamp,
      currencyCode: currencyCode,
      addressFrom: addressFrom,
      addressTo: addressTo,
      payload: payload,
      amount: amount,
      status: status,
      atc: atc,
      errorCode: errorCode,
      errorData: errorData,
    );
  }

  String txTypeToString() {
    switch (txType) {
      case 4: return "Оплата счета";
      case 1: return "Зачисление";
      case 2: return "Перевод";
    }

    return "Не определено";
  }

  String statusToString() {
    switch (status) {
      case 3:
        return "Исполнено";
      case 2:
        return "Отклонено";
    }

    return "Не определен";
  }
}
