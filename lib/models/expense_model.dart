class Expense {
  final String id;
  final int userId;
  final String title;
  final double amount;
  final DateTime date;
  final String? imageUrl;
  bool isSynced;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.date,
    this.imageUrl,
    this.isSynced = false,
  });
}
