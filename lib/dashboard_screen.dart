import 'package:flutter/material.dart';
import 'package:fintrack/entry_screen.dart';
import 'package:fintrack/login_screen.dart';
import 'package:fintrack/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/full_transactions_screen.dart';
import 'package:fintrack/detail_transaction_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
          .limitToLast(3)
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            _transactions = data.values
                .map((e) => e as Map<dynamic, dynamic>)
                .toList()
                .reversed
                .toList();
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
          child: Text(
            AppLocalizations.of(context)!.financial_summary,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              AppLocalizations.of(context)!.menu,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.profile),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(AppLocalizations.of(context)!.transactions),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullTransactionsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ]),
      ),
      body: SingleChildScrollView(
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
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet,
                          color: Colors.blueAccent),
                      title: Text(AppLocalizations.of(context)!.total_balance),
                      subtitle: Text('\$12,345.67'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.arrow_upward, color: Colors.green),
                      title: Text(AppLocalizations.of(context)!.income),
                      subtitle: Text('\$5,000.00'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.arrow_downward, color: Colors.red),
                      title: Text(AppLocalizations.of(context)!.expenses),
                      subtitle: Text('\$2,500.00'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.recent_transactions,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            _transactions.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                        onTap: () => {
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
                          )
                        },
                      );
                    },
                  ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullTransactionsScreen(),
                      ),
                    );
                  },
                  child:
                      Text(AppLocalizations.of(context)!.view_all_transactions),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
