import 'package:fintrack/features/dashboard/domain/entities/dashboard.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository repository;

  GetDashboardData(this.repository);

  Future<Dashboard> call(String userId) async {
    return await repository.getDashboardData(userId);
  }
}
