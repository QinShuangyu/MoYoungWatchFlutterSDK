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
  final BuildContext pageContext;
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  bool _multiSelectMode = false;
  final Set<String> _selectedContactIds = {};  // Set to keep track of selected contacts

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
      appBar: AppBar(
        title: const Text('flutter_contacts_example'),
        actions: [
          IconButton(
            icon: Icon(_multiSelectMode ? Icons.close : Icons.checklist),
            onPressed: () {
              setState(() {
                _multiSelectMode = !_multiSelectMode;
                _selectedContactIds.clear();  // Reset selections when toggling mode
              });
            },
          ),
        ],
      ),
      body: _body(),
      bottomNavigationBar: _multiSelectMode && _selectedContactIds.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            // Fetch the full contacts for selected IDs
            final selectedContacts = await Future.wait(
              _contacts!
                  .where((c) => _selectedContactIds.contains(c.id))
                  .map((c) => FlutterContacts.getContact(c.id)),
            );

            // Filter null values and return selected contacts
            Navigator.pop(pageContext, selectedContacts.whereType<Contact>().toList());
          },
          child: Text('complete (${_selectedContactIds.length})'),
        ),
      )
          : null,
    ),
  );

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) {
        final contact = _contacts![i];
        final isSelected = _selectedContactIds.contains(contact.id);
        return ListTile(
          leading: avatar(contact, 18.0),
          title: Text(contact.displayName),
          trailing: _multiSelectMode
              ? Checkbox(
            value: isSelected,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedContactIds.add(contact.id);
                } else {
                  _selectedContactIds.remove(contact.id);
                }
              });
            },
          )
              : null,
          onTap: () async {
            if (_multiSelectMode) {
              setState(() {
                // Add or remove the contact from selected list
                if (isSelected) {
                  _selectedContactIds.remove(contact.id);
                } else {
                  _selectedContactIds.add(contact.id);
                }
              });
            } else {
              // Single selection: return the selected contact
              final fullContact = await FlutterContacts.getContact(contact.id);

              // Ensure the contact is not null before returning
              if (fullContact != null) {
                Navigator.pop(pageContext, [fullContact]); // Return as a list of one
              } else {
                // Handle the case where fullContact is null (if necessary)
                print("Selected contact is null");
              }
            }
          },
        );
      },
    );
  }
}
