import 'package:fintrack/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';

class DashboardSummaryCard extends StatelessWidget {
  final Dashboard dashboard;
  final NumberFormat currencyFormat;

  // ignore: use_super_parameters
  const DashboardSummaryCard({
    Key? key, 
    required this.dashboard,
    required this.currencyFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading:
                  Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
              title: Text(AppLocalizations.of(context)!.total_balance),
              subtitle: Text(
                currencyFormat.format(dashboard.totalBalance),
                style: TextStyle(
                  color: dashboard.totalBalance < 0 ? Colors.red : Colors.green,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.arrow_upward, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.income),
              subtitle: Text(currencyFormat.format(dashboard.totalIncome)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.arrow_downward, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.expenses),
              subtitle: Text(currencyFormat.format(dashboard.totalExpenses)),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
  final List<Map<dynamic, dynamic>> transactions;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  // ignore: use_super_parameters
  const RecentTransactionsList({
    Key? key, // Añadido parámetro Key.
    required this.transactions,
    required this.currencyFormat,
    required this.dateFormat,
  }) : super(key: key); // Pasando Key al constructor base.

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Text(AppLocalizations.of(context)!.no_recent_transactions))
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final amount =
                  double.tryParse(transaction['amount'].toString()) ?? 0.0;
              final date =
                  DateTime.tryParse(transaction['date']) ?? DateTime.now();
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
                  context.go(AppRoutes.detail, extra: {
                    'amount': currencyFormat.format(amount),
                    'date': dateFormat.format(date),
                    'description': transaction['description'],
                    'transactionIcon': Icons.local_gas_station,
                  });
                },
              );
            },
          );
  }
}
