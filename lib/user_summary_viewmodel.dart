import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserSummaryViewModel extends ChangeNotifier {
  final User? user = FirebaseAuth.instance.currentUser;
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  List<Map<dynamic, dynamic>> _transactions = [];

  UserSummaryViewModel() {
    fetchUserSummary();
    fetchTransactions();
  }

  Future<void> fetchUserSummary() async {
    if (user != null) {
      final DatabaseReference database = 
          FirebaseDatabase.instance.ref().child('entries');
      database
          .orderByChild('userId')
          .equalTo(user!.uid)
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          double income = 0.0;
          double expenses = 0.0;
          data.forEach((key, value) {
            final entry = value as Map<dynamic, dynamic>;
            final amount = double.tryParse(entry['amount'].toString()) ?? 0.0;
            if (entry['type'] == 'Income') {
              income += amount;
            } else if (entry['type'] == 'Expense') {
              expenses += amount;
            }
          });
          totalIncome = income;
          totalExpenses = expenses;
          totalBalance = income - expenses;
          notifyListeners();
        }
      });
    }
  }

  Future<void> fetchTransactions() async {
    if (user != null) {
      final DatabaseReference database =
          FirebaseDatabase.instance.ref().child('entries');
      database
          .orderByChild('userId')
          .equalTo(user!.uid)
          .limitToLast(3)
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          _transactions =
              data.values.map((e) => e as Map<dynamic, dynamic>).toList();
          _transactions.sort((a, b) {
            final dateA = DateTime.tryParse(a['date']) ?? DateTime.now();
            final dateB = DateTime.tryParse(b['date']) ?? DateTime.now();
            return dateB.compareTo(dateA);
          });
          notifyListeners();
        }
      });
    }
  }

  List<Map<dynamic, dynamic>> get transactions => _transactions;
}
