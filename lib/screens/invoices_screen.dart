import 'package:flutter/material.dart';
import 'package:vtb_hackaton/screens/invoices_purchases_screen.dart';
import 'package:vtb_hackaton/screens/invoices_all_screen.dart';
import 'package:vtb_hackaton/data/bills.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class InvoicesScreen extends StatefulWidget {
  InvoicesScreen({this.title, this.onCreatePush, this.onDetailPush});

  final String title;
  final VoidCallback onCreatePush;
  final VoidCallback onDetailPush;

  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _textFieldController = TextEditingController();

  int index = 0;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.border_clear),
            onPressed: scan,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Групповые"),
                Tab(text: "Личные"),
              ],
              labelStyle: TextStyle(fontSize: 18.0),
              indicatorColor: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  InvoicesPurchasesScreen(
                    onDetailPush: widget.onDetailPush,
                  ),
                  InvoicesAllScreen(),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _displayDialog(context),
            )
          : null,
    );
  }

  _displayDialog(BuildContext context) async {
    Bills.instance.currentBill = Bill(amount: 0, payments: []);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Введите сумму чека'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Сумма (руб.)"),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              new FlatButton(
                textColor: Colors.red[400],
                child: new Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _textFieldController.clear();
                },
              ),
              new FlatButton(
                child: new Text('Дальше'),
                onPressed: () {
                  Bills.instance.currentBill.amount =
                      double.parse(_textFieldController.text);

                  Navigator.of(context).pop();
                  _textFieldController.clear();
                  widget.onCreatePush();
                },
              ),
            ],
          );
        });
  }

  void onTabChanged() {
    final aniValue = _tabController.animation.value;
    if (aniValue > 0.5 && index != 1) {
      setState(() {
        index = 1;
      });
    } else if (aniValue <= 0.5 && index != 0) {
      setState(() {
        index = 0;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      Map<String, dynamic> qrData = json.decode(barcode);
      print("\n\n");
      print(qrData);

      String address = qrData["address"];
      String invoiceId = qrData["invoiceId"];
      double amount = qrData["invoiceId"];
      int currencyCode = qrData["currencyCode"];

      print(address);
      print(invoiceId);
      print(amount);
      print(currencyCode);

      if (qrData.containsKey("address") &&
          qrData.containsKey("invoiceId") &&
          qrData.containsKey("amount") &&
          qrData.containsKey("currencyCode")) {

        String address = qrData["address"];
        String invoiceId = qrData["invoiceId"];
        double amount = qrData["invoiceId"];
        int currencyCode = qrData["currencyCode"];

        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text("Информация по данному инвойсу: перевести ${amount} руб. на кошелек ${address}. Номер инвойса - ${invoiceId}", style: TextStyle(fontSize: 24.0),)
                ),
              );
            }
        );
      }

//      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        setState(() {
//          this.barcode = 'The user did not grant the camera permission!';
//        });
      } else {
//        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
//      setState(() => this.barcode =
//          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
//      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
