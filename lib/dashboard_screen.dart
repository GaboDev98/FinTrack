import 'package:flutter/material.dart';
import 'detail_transaction_screen.dart';
import 'full_transactions_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
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
                      title: Text('Total Balance'),
                      subtitle: Text('\$12,345.67'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.arrow_upward, color: Colors.green),
                      title: Text('Income'),
                      subtitle: Text('\$5,000.00'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.arrow_downward, color: Colors.red),
                      title: Text('Expenses'),
                      subtitle: Text('\$2,500.00'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.orange),
                  title: Text('Grocery Shopping'),
                  subtitle: Text('\$150.00'),
                  trailing: Text('Oct 1, 2023'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTransactionScreen(
                          title: 'Grocery Shopping',
                          amount: '\$150.00',
                          date: 'Oct 1, 2023',
                          description: 'Grocery shopping at the local market.',
                          transactionIcon: Icons.shopping_cart,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_gas_station, color: Colors.blue),
                  title: Text('Gas Station'),
                  subtitle: Text('\$60.00'),
                  trailing: Text('Oct 2, 2023'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTransactionScreen(
                          title: 'Gas Station',
                          amount: '\$60.00',
                          date: 'Oct 2, 2023',
                          description: 'Fuel for the car.',
                          transactionIcon: Icons.local_gas_station,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant, color: Colors.purple),
                  title: Text('Restaurant'),
                  subtitle: Text('\$80.00'),
                  trailing: Text('Oct 3, 2023'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTransactionScreen(
                          title: 'Restaurant',
                          amount: '\$80.00',
                          date: 'Oct 3, 2023',
                          description: 'Dinner at a restaurant.',
                          transactionIcon: Icons.restaurant,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
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
                  child: Text('View All Transactions'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
