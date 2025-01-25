import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';

abstract class DashboardRepository {
  Future<Dashboard> getDashboardData(String userId);
}
