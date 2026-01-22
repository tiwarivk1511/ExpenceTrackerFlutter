import 'package:expence_tracker/models/expense_model.dart';
import 'package:expence_tracker/providers/auth_provider.dart';
import 'package:expence_tracker/repository/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  final AuthProvider authProvider;
  List<Expense> _expenses = [];

  ExpenseProvider({required this.authProvider});

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    if (authProvider.userId != null) {
      _expenses = await _expenseRepository.getExpenses(authProvider.userId!);
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _expenseRepository.addExpense(expense);
    await fetchExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseRepository.updateExpense(expense);
    await fetchExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _expenseRepository.deleteExpense(id);
    await fetchExpenses();
  }

  Future<void> syncExpenses() async {
    if (authProvider.userId != null) {
      await _expenseRepository.syncExpenses(authProvider.userId!);
      await fetchExpenses();
    }
  }
}
