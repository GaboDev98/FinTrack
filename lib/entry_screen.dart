import 'package:fintrack/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String entryType = 'Expense';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.add_entry),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.entry_type,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              value: entryType,
              onChanged: (String? newValue) {
                setState(() {
                  entryType = newValue!;
                });
              },
              items: <String>['Expense', 'Income']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amount,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: Text(
                  AppLocalizations.of(context)!.add_entry_button,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEntry() async {
    final String amount = amountController.text;
    final String description = descriptionController.text;
    final User? user = FirebaseAuth.instance.currentUser;

    if (amount.isNotEmpty && description.isNotEmpty && user != null) {
      final entry = {
        'type': entryType,
        'amount': amount,
        'description': description,
        'date': DateTime.now().toIso8601String(),
        'userId': user.uid,
      };

      _database.child('entries').push().set(entry).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add entry: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}
