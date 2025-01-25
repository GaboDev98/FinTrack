import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fintrack/features/dashboard/data/datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Dashboard> getDashboardData(String userId) async {
    final data = await remoteDataSource.fetchDashboardData(userId);
    // Process data and calculate totalBalance, totalIncome, totalExpenses
    double totalIncome = 0.0;
    double totalExpenses = 0.0;
    List<Map<dynamic, dynamic>> transactions = [];
    data.forEach((key, value) {
      final amount = double.tryParse(value['amount'].toString()) ?? 0.0;
      if (value['type'] == 'Income') {
        totalIncome += amount;
      } else if (value['type'] == 'Expense') {
        totalExpenses += amount;
      }
      transactions.add(value);
    });
    final totalBalance = totalIncome - totalExpenses;
    return Dashboard(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      transactions: transactions,
    );
  }
}
