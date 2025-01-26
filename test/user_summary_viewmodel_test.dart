import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fintrack/user_summary_viewmodel.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDatabaseEvent extends Mock implements DatabaseEvent {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockDatabaseReference mockDatabaseReference;
  late UserSummaryViewModel viewModel;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockDatabaseReference = MockDatabaseReference();

    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('testUserId');
    // when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    // when(mockDatabaseReference.orderByChild(any)).thenReturn(mockDatabaseReference);
    // when(mockDatabaseReference.equalTo(any)).thenReturn(mockDatabaseReference);
    // when(mockDatabaseReference.limitToLast(any)).thenReturn(mockDatabaseReference);

    viewModel = UserSummaryViewModel();
  });

  test('initial values are correct', () {
    expect(viewModel.totalBalance, 0.0);
    expect(viewModel.totalIncome, 0.0);
    expect(viewModel.totalExpenses, 0.0);
    expect(viewModel.transactions, []);
  });

  test('fetchUserSummary updates values correctly', () async {
    final mockDatabaseEvent = MockDatabaseEvent();
    final mockData = {
      'entry1': {
        'amount': '100.0',
        'type': 'Income',
      },
      'entry2': {
        'amount': '50.0',
        'type': 'Expense',
      },
    };

    when(mockDatabaseReference.onValue).thenAnswer((_) {
      return Stream<DatabaseEvent>.fromIterable([mockDatabaseEvent]);
    });
    when(mockDatabaseEvent.snapshot).thenReturn(DataSnapshotMock(mockData));

    await viewModel.fetchUserSummary();

    expect(viewModel.totalIncome, 100.0);
    expect(viewModel.totalExpenses, 50.0);
    expect(viewModel.totalBalance, 50.0);
  });

  test('fetchTransactions updates transactions correctly', () async {
    final mockDatabaseEvent = MockDatabaseEvent();
    final mockData = {
      'entry1': {
        'amount': '100.0',
        'type': 'Income',
        'date': '2023-01-01T00:00:00Z',
        'description': 'Test Income',
      },
      'entry2': {
        'amount': '50.0',
        'type': 'Expense',
        'date': '2023-01-02T00:00:00Z',
        'description': 'Test Expense',
      },
    };

    when(mockDatabaseReference.onValue).thenAnswer((_) {
      return Stream<DatabaseEvent>.fromIterable([mockDatabaseEvent]);
    });
    when(mockDatabaseEvent.snapshot).thenReturn(DataSnapshotMock(mockData));

    await viewModel.fetchTransactions();

    expect(viewModel.transactions.length, 2);
    expect(viewModel.transactions[0]['description'], 'Test Expense');
    expect(viewModel.transactions[1]['description'], 'Test Income');
  });
}

class DataSnapshotMock extends Mock implements DataSnapshot {
  final Map<dynamic, dynamic> data;

  DataSnapshotMock(this.data);

  @override
  dynamic get value => data;
}
