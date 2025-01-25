import 'package:flutter/material.dart';
import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_dashboard_data.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardData getDashboardData;
  Dashboard? dashboard;
  bool isLoading = false;

  DashboardProvider({required this.getDashboardData});

  Future<void> fetchDashboardData(String userId) async {
    isLoading = true;
    notifyListeners();
    dashboard = await getDashboardData(userId);
    isLoading = false;
    notifyListeners();
  }
}
