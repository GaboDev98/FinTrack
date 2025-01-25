import 'package:firebase_database/firebase_database.dart';

class DashboardRemoteDataSource {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('entries');

  Future<Map<dynamic, dynamic>> fetchDashboardData(String userId) async {
    final snapshot =
        await _database.orderByChild('userId').equalTo(userId).get();
    return snapshot.value as Map<dynamic, dynamic>;
  }
}
