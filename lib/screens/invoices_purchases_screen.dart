import 'package:flutter/material.dart';
import 'package:vtb_hackaton/data/bills.dart';

class InvoicesPurchasesScreen extends StatefulWidget {
  InvoicesPurchasesScreen({this.onDetailPush});

  final VoidCallback onDetailPush;

  @override
  _InvoicesPurchasesScreenState createState() => _InvoicesPurchasesScreenState();
}

class _InvoicesPurchasesScreenState extends State<InvoicesPurchasesScreen> {
  @override
  void initState() {
    super.initState();

    getBills();
  }

  Future<void> getBills() async {
    await Bills.instance.get();
    setState(() {});
  }

  Future<Null> _refresh() async {
    getBills();

    return await Future<Null>.value(null);
  }

  @override
  Widget build(BuildContext context) {
    List<Bill> bills = Bills.instance.bills.reversed.toList();

    return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (BuildContext content, int index) {
          Bill bil = bills[index];

          return Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Bills.instance.billToShow = bil;
                  widget.onDetailPush();
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Чек на сумму: ${bil.amount} руб.',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Разделен между: ${bil.payments.length} (людьми)',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Инвойсов: ${bil.InvoicesNumber()}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('QR-кодов: ${bil.QRCodesNumber()}',
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        })
    );
  }
}
