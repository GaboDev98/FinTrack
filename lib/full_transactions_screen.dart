import 'package:flutter/material.dart';
import 'detail_transaction_screen.dart';

class FullTransactionsScreen extends StatelessWidget {
  const FullTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
          // Add more transactions here
        ],
      ),
    );
  }
}
