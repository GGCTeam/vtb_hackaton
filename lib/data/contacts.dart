import 'package:localstorage/localstorage.dart';

class Contacts {
  final LocalStorage storage = new LocalStorage('contacts_storage');

  Contacts._();

  static final instance = Contacts._();

  List<Contact> contacts = [];

  Future<List<Contact>> get() async {
    bool isReady = await storage.ready;
    if (isReady) {
      List<dynamic> mContacts = storage.getItem("contacts") ?? [];
      contacts = [];

      for (var i = 0; i < mContacts.length; i++) {
        contacts.add(Contact.fromMap(cast<Map<String, dynamic>>(mContacts[i])));
      }

      // contacts = cast<List<Contact>>(data["contacts"]);
    }

    return contacts;
  }

  Future<void> add(Contact con) async {
    bool isReady = await storage.ready;
    if (isReady) {
      contacts.add(con);

      List<Map<String, dynamic>> mContacts = [];
      for (var i = 0; i < contacts.length; i++) {
        mContacts.add(contacts[i].toMap());
      }
      storage.setItem("contacts", mContacts);
    }

    return null;
  }

  T cast<T>(x) => x is T ? x : null;
}

class Contact {
  Contact({
    this.username,
    this.address,
  });

  final String username;
  final String address;

  factory Contact.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final String username = data["username"];
    final String address = data["address"];

    return Contact(
      username: username,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "address": address,
    };
  }
}
