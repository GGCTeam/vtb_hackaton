import 'package:localstorage/localstorage.dart';

class Bills {
  final LocalStorage storage = new LocalStorage('bills_storage');

  Bills._();

  static final instance = Bills._();

  List<Bill> bills = [];
  Bill currentBill;
  Bill billToShow;
  Payment currentPayment;

  Future<List<Bill>> get() async {
    bool isReady = await storage.ready;
    if (isReady) {
      List<dynamic> mBills = storage.getItem("bills") ?? [];
      bills = [];

      for (var i = 0; i < mBills.length; i++) {
        bills.add(Bill.fromMap(cast<Map<String, dynamic>>(mBills[i])));
      }

      // contacts = cast<List<Contact>>(data["contacts"]);
    }

    return bills;
  }

  Future<void> add(Bill bil) async {
    bool isReady = await storage.ready;
    if (isReady) {
      bills.add(bil);

      List<Map<String, dynamic>> mBills = [];
      for (var i = 0; i < bills.length; i++) {
        mBills.add(bills[i].toMap());
      }
      storage.setItem("bills", mBills);
    }

    return null;
  }

  T cast<T>(x) => x is T ? x : null;
}

class Bill {
  Bill({
    this.amount,
    this.payments,
  });

  double amount;
  List<Payment> payments;

  double remainingToPay() {
    var sum = amount;

    for (var i = 0; i < payments.length; i++) {
      sum -= payments[i].amount;
    }

    return sum;
  }

  int InvoicesNumber() {
    var sum = 0;
    for (var i = 0; i < payments.length; i++) {
      if (payments[i].type == Payment.INVOICE_TYPE) {
        sum++;
      }
    }
    return sum;
  }

  int QRCodesNumber() {
    var sum = 0;
    for (var i = 0; i < payments.length; i++) {
      if (payments[i].type == Payment.QR_CODE_TYPE) {
        sum++;
      }
    }
    return sum;
  }

  factory Bill.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final double amount = data["amount"];
    final List<dynamic> tmp_data = data["payments"];

    final List<Payment> goodData = [];

    for (int i = 0; i < tmp_data.length; i++) {
      goodData.add(Payment.fromJson(tmp_data[i]));
    }

    return Bill(
      amount: amount,
      payments: goodData,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> goodData = [];

    for (int i = 0; i < payments.length; i++) {
      goodData.add(payments[i].toMap());
    }

    return {
      "amount": amount,
      "payments": goodData,
    };
  }
}

class Payment {
  Payment({
    this.type,
    this.amount,
    this.username,
    this.description,
    this.recipient,
    this.payer,
    this.invoiceNumber,
  });

  static String INVOICE_TYPE = "invoice";
  static String QR_CODE_TYPE = "qr_code";

  String type;
  double amount;
  String username;
  String description;
  String recipient;
  String payer;
  String invoiceNumber;
  int invoiceState = -1;

  factory Payment.fromJson(Map<String, dynamic> data) {
    if (data == null) return null;

    final String type = data["type"];
    final double amount = data["amount"];
    final String username = data["username"];
    final String description = data["description"];
    final String recipient = data["recipient"];
    final String payer = data["payer"];
    final String invoiceNumber = data["invoiceNumber"];

    return Payment(
      type: type,
      amount: amount,
      username: username,
      description: description,
      recipient: recipient,
      payer: payer,
      invoiceNumber: invoiceNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "amount": amount,
      "username": username,
      "description": description,
      "recipient": recipient,
      "payer": payer,
      "invoiceNumber": invoiceNumber,
    };
  }

  String invoiceStateToString() {
    switch (invoiceState) {
      case 1: return "Создан";
      case 2: return "Выставлен";
      case 3: return "Ошибочный счет";
      case 4: return "Истекло время действия счета";
      case 5: return "Оплачен";
    }

    return "Не определен";
  }
}
