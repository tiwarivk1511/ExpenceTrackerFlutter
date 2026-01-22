import 'package:expence_tracker/models/expense_model.dart';
import 'package:expence_tracker/utils/database_helper.dart';

class ExpenseRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Expense>> getExpenses(int userId) async {
    return await dbHelper.getExpenses(userId);
  }

  Future<void> addExpense(Expense expense) async {
    await dbHelper.insertExpense(expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await dbHelper.updateExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    await dbHelper.deleteExpense(id);
  }

  Future<void> syncExpenses(int userId) async {
    final unsyncedExpenses = (await dbHelper.getExpenses(userId)).where((exp) => !exp.isSynced);

    for (var expense in unsyncedExpenses) {
      print('Syncing expense ${expense.id} to server...');
      await Future.delayed(const Duration(milliseconds: 500));
      expense.isSynced = true;
      await dbHelper.updateExpense(expense);
    }

    print("Sync complete!");
  }
}
