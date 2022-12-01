import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:moyoung_ble_plugin_example/modules/avatar.dart';

class FlutterContactsExample extends StatefulWidget {
  final BuildContext pageContext;

  const FlutterContactsExample({Key? key, required this.pageContext}) : super(key: key);

  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState(pageContext);
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  BuildContext pageContext;
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  _FlutterContactsExampleState(this.pageContext);

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(withThumbnail: true);
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('flutter_contacts_example')),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            leading: avatar(_contacts![i], 18.0),
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact = await FlutterContacts.getContact(_contacts![i].id);
              Navigator.pop(pageContext, fullContact);
              /*await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));*/
            }));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  const ContactPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}
