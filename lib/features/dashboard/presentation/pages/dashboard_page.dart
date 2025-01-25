import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fintrack/features/dashboard/presentation/widgets/dashboard_widget.dart';
import 'package:fintrack/features/dashboard/presentation/providers/dashboard_provider.dart';

class DashboardPage extends StatelessWidget {
  final NumberFormat currencyFormat =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy hh:mm a');

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Scaffold(
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
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DashboardSummaryCard(
                    dashboard: provider.dashboard!,
                    currencyFormat: currencyFormat,
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
                  RecentTransactionsList(
                    transactions: provider.dashboard!.transactions,
                    currencyFormat: currencyFormat,
                    dateFormat: dateFormat,
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
            ),
    );
  }
}
