import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vtb_hackaton/data/data.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.title});

  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${Data.username}", style: TextStyle(fontSize: 28.0)),
            Text("${Data.wallet}", style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 40,),
            QrImage(
              data: "{\"address\":\"${Data.wallet}\",\"username\":\"${Data.username}\",\"currencyCode\":810}",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
