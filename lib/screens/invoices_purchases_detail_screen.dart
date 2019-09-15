import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vtb_hackaton/data/bills.dart';
import 'package:vtb_hackaton/data/invoices.dart';

class InvoicesPurchasesDetailScreen extends StatefulWidget {
  @override
  _InvoicesPurchasesDetailScreenState createState() =>
      _InvoicesPurchasesDetailScreenState();
}

class _InvoicesPurchasesDetailScreenState
    extends State<InvoicesPurchasesDetailScreen> {

  @override
  void initState() {
    super.initState();

    checkInvoicesStates();
  }

  Future<void> checkInvoicesStates() async {
    List<Payment> payments = Bills.instance.billToShow.payments;

    for (var i = 0; i < payments.length; i++) {
      int state = await Invoices.instance.checkState(payments[i]);
      payments[i].invoiceState = state;
      setState(() {});
    }
  }

  Future<Null> _refresh() async {
    checkInvoicesStates();

    return await Future<Null>.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Чек - ${Bills.instance.billToShow.amount} руб.',
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildRemaining(),
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildRemaining() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Я плачу:",
              style: TextStyle(fontSize: 22.0),
            ),
            Text(
              "${Bills.instance.billToShow.remainingToPay()} руб.",
              style: TextStyle(fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    List<Payment> payments = Bills.instance.billToShow.payments;

    return Expanded(
      child: Container(
        child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (BuildContext content, int index) {
                  Payment pay = payments[index];

                  return Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // TODO тут если QR CODE то выводить его на экран
                          if (pay.type == Payment.QR_CODE_TYPE) {
                            _displayQRCodeDialog(context, pay);
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${pay.username}",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "${pay.amount} руб.",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('${pay.payer}',
                                    style: TextStyle(fontSize: 14.0)),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Статус: ${pay.invoiceStateToString()}',
                                    style: TextStyle(fontSize: 16.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }

  _displayQRCodeDialog(BuildContext context, Payment payment) async {
    print("\n\n\n");
    print(payment.invoiceNumber);
    print("\n\n\n");
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: QrImage(
                data:
                    "{\"address\":\"${payment.recipient}\",\"invoiceId\":\"${payment.invoiceNumber}\",\"currencyCode\":810,\"amount\":${payment.amount}}",
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          );
        });
  }
}