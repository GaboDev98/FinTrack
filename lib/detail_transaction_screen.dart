import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailTransactionScreen extends StatelessWidget {
  final String amount;
  final String date;
  final String description;
  final IconData transactionIcon;

  const DetailTransactionScreen({
    super.key,
    required this.amount,
    required this.date,
    required this.description,
    required this.transactionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.transaction_details)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.green),
                      title: Text(AppLocalizations.of(context)!.amount),
                      subtitle: Text(amount),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text(AppLocalizations.of(context)!.date),
                      subtitle: Text(date),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.grey),
                      title: Text(AppLocalizations.of(context)!.description),
                      subtitle: Text(description),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
