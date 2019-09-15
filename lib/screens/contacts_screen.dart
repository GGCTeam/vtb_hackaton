import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'package:vtb_hackaton/data/contacts.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen({this.title});

  final String title;

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  @override
  void initState() {
    super.initState();

    getContacts();
  }

  Future<void> getContacts() async {
    await Contacts.instance.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: scan,
      ),
    );
  }

  Widget _buildList() {
    List<Contact> contacts = Contacts.instance.contacts;

    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext content, int index) {
          Contact con = contacts[index];

          return Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
          );
        });
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      var rng = new Random();
      Map<String, dynamic> qrData = json.decode(barcode);

      if (qrData.containsKey("address")) {
        String address = qrData["address"];
        String username = "Friend #${rng.nextInt(100)}";

        if (qrData.containsKey("username")) {
          username = qrData["username"];
        }

        Contact con = Contact(username: username, address: address);
        await Contacts.instance.add(con);
        setState(() {});
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
