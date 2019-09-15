import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vtb_hackaton/data/bills.dart';
import 'package:vtb_hackaton/data/data.dart';
import 'package:uuid/uuid.dart';
import 'package:vtb_hackaton/data/contacts.dart';
import 'package:vtb_hackaton/data/invoices.dart';

class CreateInvoicesForBillScreen extends StatefulWidget {
  CreateInvoicesForBillScreen({this.title});

  final String title;

  @override
  _CreateInvoicesForBillScreenState createState() =>
      _CreateInvoicesForBillScreenState();
}

class _CreateInvoicesForBillScreenState
    extends State<CreateInvoicesForBillScreen> {
  TextEditingController _textFieldController = TextEditingController();
  String saveButtonText = "Сохранить";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          '${widget.title}',
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildRemaining(),
          _buildPayers(),
          _buildSaveButton(context),
        ],
      ),
      floatingActionButton: _getFAB(context),
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
              "Остаток (я):",
              style: TextStyle(fontSize: 22.0),
            ),
            Text(
              "${Bills.instance.currentBill.remainingToPay()} руб.",
              style: TextStyle(fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayers() {
    List<Payment> payments = Bills.instance.currentBill.payments;

    return Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: payments.length,
            itemBuilder: (BuildContext content, int index) {
              Payment pay = payments[index];

              return Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // TODO замутить обновление или удаление данных
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            SizedBox(height: 8,),
                            Text('${pay.payer}',
                                style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    bool buttonDisabled = Bills.instance.currentBill.payments.length == 0;

    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16, top: 8),
          child: NiceButton(
            width: 180,
            elevation: 4.0,
            radius: 52.0,
            fontSize: 20,
            padding: EdgeInsets.all(16.0),
            text: saveButtonText,
            background:
                buttonDisabled ? Colors.grey : Theme.of(context).primaryColor,
            onPressed: buttonDisabled ? null : () async {
              setState(() {
                saveButtonText = "Сохраняю...";
              });

              List<Payment> payments = Bills.instance.currentBill.payments;

              for (var i = 0; i < payments.length; i++) {
                await Invoices.instance.create(payments[i]);
              }

              setState(() {
                saveButtonText = "Сохранить";
              });

              Bills.instance.add(Bills.instance.currentBill);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _getFAB(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22),
      visible: true,
      overlayOpacity: 0.0,
      curve: Curves.ease,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(Icons.border_clear),
          onTap: () {
            var uuid = new Uuid();
            Bills.instance.currentPayment = Payment(
              type: Payment.QR_CODE_TYPE,
              amount: 0,
              username: "QR CODE",
              description: "from the Crack.Team app",
              recipient: Data.wallet,
              payer: "",
              invoiceNumber: uuid.v4(),
            );

            // показываем чтобы вбил сумму
            _displayAmountDialog(context);
          },
          label: 'QR-код для оплаты',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: Theme.of(context).primaryColor,
        ),

        // FAB 2
        SpeedDialChild(
          child: Icon(Icons.library_books),
          onTap: () {
            var uuid = new Uuid();
            Bills.instance.currentPayment = Payment(
                type: Payment.INVOICE_TYPE,
                amount: 0,
                username: "",
                description: "from the Crack.Team app",
                recipient: Data.wallet,
                payer: "",
                invoiceNumber: uuid.v4(),
            );

            _displayContactsDialog(context);
          },
          label: 'Выставить счет',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  _displayContactsDialog(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return _buildContactsList();
        }
    );
  }

  Widget _buildContactsList() {
    List<Contact> contacts = Contacts.instance.contacts;

    return Container(
      child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext content, int index) {
            Contact con = contacts[index];

            return Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // тут заполняем промежуточные данные
                    Bills.instance.currentPayment.username = con.username;
                    Bills.instance.currentPayment.payer = con.address;

                    // убираем нижний sheet
                    Navigator.of(context).pop();

                    // показываем чтобы вбил сумму
                    _displayAmountDialog(context);
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${con.username}',
                              style: TextStyle(fontSize: 18.0)),
                          Text('${con.address}',
                              style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _displayAmountDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Введите запрашиваемую сумму'),
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
                child: new Text('Добавить'),
                onPressed: () {
                  Navigator.of(context).pop();

                  Bills.instance.currentPayment.amount = double.parse(_textFieldController.text);
                  Bills.instance.currentBill.payments.add(Bills.instance.currentPayment);
                  setState(() {});

                  _textFieldController.clear();
                },
              ),
            ],
          );
        });
  }
}
