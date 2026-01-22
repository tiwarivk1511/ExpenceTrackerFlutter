import 'package:expence_tracker/providers/auth_provider.dart';
import 'package:expence_tracker/providers/expense_provider.dart';
import 'package:expence_tracker/screens/add_expense_screen.dart';
import 'package:expence_tracker/screens/expense_detail_screen.dart';
import 'package:expence_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              Provider.of<ExpenseProvider>(context, listen: false).syncExpenses();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing expenses...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              Colors.grey[850]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Consumer<ExpenseProvider>(
              builder: (ctx, expenseProvider, child) {
                if (expenseProvider.expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 100, color: Colors.grey[600]),
                        const SizedBox(height: 20),
                        const Text(
                          'No Expenses Logged',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap the + button to add a new expense.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: expenseProvider.expenses.length,
                    itemBuilder: (ctx, i) {
                      final expense = expenseProvider.expenses[i];
                      final isIncome = expense.amount >= 0;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExpenseDetailScreen(expense: expense),
                              ),
                            ).then((_) {
                              Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            child: Icon(
                              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat.yMMMd().format(expense.date)),
                          trailing: Text(
                            '${isIncome ? '+' : '-'}\$${expense.amount.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.green : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddExpenseScreen())).then((_) {
              Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}
