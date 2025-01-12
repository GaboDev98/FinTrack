import 'package:fintrack/detail_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FullTransactionsScreen extends StatefulWidget {
  const FullTransactionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FullTransactionsScreenState createState() => _FullTransactionsScreenState();
}

class _FullTransactionsScreenState extends State<FullTransactionsScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('entries');
  List<Map<dynamic, dynamic>> _transactions = [];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    if (user != null) {
      _database
          .orderByChild('userId')
          .equalTo(user!.uid)
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && mounted) {
          setState(() {
            _transactions =
                data.values.map((e) => e as Map<dynamic, dynamic>).toList();
          });
        } else if (mounted) {
          setState(() {
            _transactions = [];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.transactions),
        ),
      ),
      body: _transactions.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.no_transactions))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  leading: Icon(
                    transaction['type'] == 'Income'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction['type'] == 'Income'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(transaction['description']),
                  subtitle: Text(transaction['date']),
                  trailing: Text('\$${transaction['amount']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTransactionScreen(
                          amount: '\$${transaction['amount']}',
                          date: transaction['date'],
                          description: transaction['description'],
                          transactionIcon: Icons.local_gas_station,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
