import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/user_summary_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy hh:mm a');

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.logout),
            content: Text(AppLocalizations.of(context)!.logout_confirmation),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.no),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(true);
                  context.go('/login');
                },
                child: Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        bool value = await _onWillPop();
        if (value) {
          navigator.pop(result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                context.go('/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(AppLocalizations.of(context)!.transactions),
              onTap: () {
                context.go('/transactions');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.go('/login');
              },
            ),
          ]),
        ),
        body: Consumer<UserSummaryViewModel>(
          builder: (context, userSummary, child) {
            return SingleChildScrollView(
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
                            title: Text(
                                AppLocalizations.of(context)!.total_balance),
                            subtitle: Text(
                              currencyFormat.format(userSummary.totalBalance),
                              style: TextStyle(
                                color: userSummary.totalBalance < 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading:
                                Icon(Icons.arrow_upward, color: Colors.green),
                            title: Text(AppLocalizations.of(context)!.income),
                            subtitle: Text(
                                currencyFormat.format(userSummary.totalIncome)),
                          ),
                          Divider(),
                          ListTile(
                            leading:
                                Icon(Icons.arrow_downward, color: Colors.red),
                            title: Text(AppLocalizations.of(context)!.expenses),
                            subtitle: Text(currencyFormat
                                .format(userSummary.totalExpenses)),
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
                  userSummary.transactions.isEmpty
                      ? Center(
                          child: Text(AppLocalizations.of(context)!
                              .no_recent_transactions))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userSummary.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = userSummary.transactions[index];
                            final amount = double.tryParse(
                                    transaction['amount'].toString()) ??
                                0.0;
                            final date =
                                DateTime.tryParse(transaction['date']) ??
                                    DateTime.now();
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
                              subtitle: Text(dateFormat.format(date)),
                              trailing: Text(currencyFormat.format(amount)),
                              onTap: () {
                                context.go('/detail', extra: {
                                  'amount': currencyFormat.format(amount),
                                  'date': dateFormat.format(date),
                                  'description': transaction['description'],
                                  'transactionIcon': Icons.local_gas_station,
                                });
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
                          context.go('/transactions');
                        },
                        child: Text(AppLocalizations.of(context)!
                            .view_all_transactions),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/entry');
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
  }
}
