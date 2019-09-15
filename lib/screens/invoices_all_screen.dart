import 'package:flutter/material.dart';
import 'package:vtb_hackaton/data/invoices.dart';

class InvoicesAllScreen extends StatefulWidget {
  @override
  _InvoicesAllScreenState createState() => _InvoicesAllScreenState();
}

class _InvoicesAllScreenState extends State<InvoicesAllScreen> {
  int shouldUpdate = 0;

  @override
  void initState() {
    super.initState();

    getInvoices();
  }

  Future<void> getInvoices() async {
    await Invoices.instance.get();
    setState(() {
      shouldUpdate++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    List<Invoice> invoices = Invoices.instance.invoices;

    return shouldUpdate == 0 && invoices.length == 0
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (BuildContext content, int index) {
              Invoice inv = invoices[index];

              return Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Получатель: ${inv.recipient}',
                              style: TextStyle(fontSize: 16.0)),
                          Text('Сумма: ${inv.amount} руб.',
                              style: TextStyle(fontSize: 16.0)),
                          Text('Описание: ${inv.description}',
                              style: TextStyle(fontSize: 16.0)),
                          Text('Состояние: ${inv.stateToString()}',
                              style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
  }
}
