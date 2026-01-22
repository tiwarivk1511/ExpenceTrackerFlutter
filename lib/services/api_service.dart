import 'package:expence_tracker/models/expense_model.dart';

class ApiService {
  // Simulate uploading an expense to the server
  Future<void> uploadExpense(Expense expense) async {
    print('Uploading expense ${expense.id} to the server...');
    // In a real app, you would make an HTTP request here.
    await Future.delayed(const Duration(seconds: 1));
    print('Expense ${expense.id} uploaded successfully!');
  }

  // Simulate fetching new expenses from the server
  Future<List<Expense>> fetchNewExpenses() async {
    print('Fetching new expenses from the server...');
    // In a real app, you would make an HTTP request here.
    await Future.delayed(const Duration(seconds: 1));
    print('No new expenses from the server.');
    return [];
  }
}
