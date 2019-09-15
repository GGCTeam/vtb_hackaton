import 'package:dio/dio.dart';
import 'package:vtb_hackaton/data/data.dart';

class Session {
  Session._();

  static final instance = Session._();

  String session_id = "";

  Future<String> get() async {
    Response resp = await Dio().post(
      Data.SessionUrl,
      data: {
        "addresses": [],
        "deviceId": "test_device_id",
        "deviceType": 1,
      },
    );

    SessionResp sData = SessionResp.fromJson(resp.data);

    session_id = sData.data;

    return session_id;
  }
}

class SessionResp {
  SessionResp({this.timestamp, this.message, this.data});

  final String timestamp;
  final String message;
  final String data;

  factory SessionResp.fromJson(Map<String, dynamic> json_data) {
    if (json_data == null) return null;

    final String timestamp = json_data["timestamp"];
    final String message = json_data["message"];
    final String data = json_data["data"];

    return SessionResp(
      timestamp: timestamp,
      message: message,
      data: data,
    );
  }
}