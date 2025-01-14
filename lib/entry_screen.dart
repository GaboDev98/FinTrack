import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String formNum(String s) {
    if (s.isEmpty) return '';
    return NumberFormat.decimalPattern().format(
      double.tryParse(s) ?? 0.0,
    );
  }

  void _saveEntry() async {
    final String amount =
        amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
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
        context.go('/');
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
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amount,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.monetization_on),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15), // Limit to 15 characters
              ],
              onChanged: (string) {
                string = formNum(string.replaceAll(',', ''));
                amountController.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(
                    offset: string.length,
                  ),
                );
              },
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
}
