import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';

class DashboardModel extends Dashboard {
  DashboardModel({
    required super.totalBalance,
    required super.totalIncome,
    required super.totalExpenses,
    required super.transactions,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalBalance: json['totalBalance'],
      totalIncome: json['totalIncome'],
      totalExpenses: json['totalExpenses'],
      transactions: List<Map<dynamic, dynamic>>.from(json['transactions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'transactions': transactions,
    };
  }
}
