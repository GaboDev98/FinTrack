import 'package:flutter/material.dart';

class DetailTransactionScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String description;
  final IconData transactionIcon;

  DetailTransactionScreen({
    required this.title,
    required this.amount,
    required this.date,
    required this.description,
    required this.transactionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(transactionIcon, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Text(title),
          ],
        ),
      ),
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
                      title: Text('Amount'),
                      subtitle: Text(amount),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text('Date'),
                      subtitle: Text(date),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.grey),
                      title: Text('Description'),
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
