import 'package:dio/dio.dart';
import 'package:vtb_hackaton/data/data.dart';
import 'package:vtb_hackaton/data/session.dart';
import 'package:vtb_hackaton/data/bills.dart';

class Invoices {
  Invoices._();

  static final instance = Invoices._();

  List<Invoice> invoices = [];

  Future<List<Invoice>> get() async {
    Response resp = await Dio().get(
      "${Data.InvoicesUrl}/810/${Data.wallet}/all",
      options: Options(headers: {"FPSID": Session.instance.session_id}),
    );

    InvoicesResp invoicesResp = InvoicesResp.fromJson(resp.data);
    invoices = invoicesResp.data;

    return invoicesResp.data;
  }

  Future<void> create(Payment pay) async {
    Map<String, dynamic> data = {
      "amount": pay.amount,
      "currencyCode": 810,
      "description": pay.description,
      "number": pay.invoiceNumber,
      "recipient": pay.recipient,
    };
    if (pay.type == Payment.INVOICE_TYPE) {
      data["payer"] = pay.payer;
    }

    await Dio().post(
      Data.InvoicesUrl,
      options: Options(headers: {"FPSID": Session.instance.session_id}),
      data: data,
    );

    return null;
  }

  Future<int> checkState(Payment pay) async {
    Response resp = await Dio().get(
      "${Data.InvoicesUrl}/810/${pay.invoiceNumber}/${pay.recipient}",
      options: Options(headers: {"FPSID": Session.instance.session_id}),
    );

    Invoice inv = Invoice.fromJson(resp.data["data"]);

    return inv.state;
  }
}

class InvoicesResp {
  InvoicesResp({this.timestamp, this.message, this.data});

  final String timestamp;
  final String message;
  final List<Invoice> data;

  factory InvoicesResp.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String timestamp = json_data["timestamp"];
    final String message = json_data["message"];
    final List<dynamic> tmp_data = json_data["data"];

    final List<Invoice> goodData = [];

    for (int i = 0; i < tmp_data.length; i++) {
      goodData.add(Invoice.fromJson(tmp_data[i]));
    }

    return InvoicesResp(
      timestamp: timestamp,
      message: message,
      data: goodData,
    );
  }
}

class Invoice {
  Invoice({
    this.number,
    this.currencyCode,
    this.amount,
    this.description,
    this.recipient,
    this.payer,
    this.state,
    this.created,
    this.updated,
    this.owner,
    this.errorCode,
  });

  String number;
  int currencyCode;
  double amount;
  String description;
  String recipient;
  String payer;
  int state;
  int created;
  int updated;
  String owner;
  int errorCode;

  factory Invoice.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String number = json_data["number"];
    final int currencyCode = json_data["currencyCode"];
    final double amount = json_data["amount"];
    final String description = json_data["description"];
    final String recipient = json_data["recipient"];
    final String payer = json_data["payer"];
    final int state = json_data["state"];
    final int created = json_data["created"];
    final int updated = json_data["updated"];
    final String owner = json_data["owner"];
    final int errorCode = json_data["errorCode"];

    return Invoice(
      number: number,
      currencyCode: currencyCode,
      amount: amount,
      description: description,
      recipient: recipient,
      payer: payer,
      state: state,
      created: created,
      updated: updated,
      owner: owner,
      errorCode: errorCode,
    );
  }

  String stateToString() {
    switch (state) {
      case 1: return "Создан";
      case 2: return "Выставлен";
      case 3: return "Ошибочный счет";
      case 4: return "Истекло время действия счета";
      case 5: return "Оплачен";
    }

    return "Не определен";
  }
}
