import 'dart:io';
import 'package:expence_tracker/models/expense_model.dart';
import 'package:expence_tracker/providers/expense_provider.dart';
import 'package:expence_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  void _deleteExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
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
              Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id);
              Navigator.of(ctx).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.amount >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddExpenseScreen(expense: expense),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteExpense(context),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  Text(
                    '${isIncome ? '+' : '-'} \$${expense.amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  Text(
                    DateFormat.yMMMMd().format(expense.date),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Divider(height: 40, thickness: 1),
                  if (expense.imageUrl != null && expense.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(
                        File(expense.imageUrl!),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Center(
                        child: Text(
                          'No Image Attached',
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
