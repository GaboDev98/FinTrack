class Dashboard {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final List<Map<dynamic, dynamic>> transactions;

  Dashboard({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.transactions,
  });
}
