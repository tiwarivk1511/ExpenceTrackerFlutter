import 'dart:io';
import 'package:expence_tracker/models/expense_model.dart';
import 'package:expence_tracker/providers/auth_provider.dart';
import 'package:expence_tracker/providers/expense_provider.dart';
import 'package:expence_tracker/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  File? _image;
  late DateTime _selectedDate;
  final PermissionService _permissionService = PermissionService();
  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title);
    _amountController = TextEditingController(text: widget.expense?.amount.toString());
    _selectedDate = widget.expense?.date ?? DateTime.now();
    if (widget.expense?.imageUrl != null && widget.expense!.imageUrl!.isNotEmpty) {
      _image = File(widget.expense!.imageUrl!);
    }
  }

  Future<void> _pickImage() async {
    final hasCameraPermission = await _permissionService.requestCameraPermission();
    if (!hasCameraPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to take a photo.')),
      );
      return;
    }

    final hasStoragePermission = await _permissionService.requestStoragePermission();
    if (!hasStoragePermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to select a photo.')),
      );
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not authenticated.')),
        );
        return;
      }

      final amount = double.parse(_amountController.text);
      final expense = Expense(
        id: widget.expense?.id ?? const Uuid().v4(),
        userId: authProvider.userId!,
        title: _titleController.text,
        amount: amount,
        date: _selectedDate,
        imageUrl: _image?.path,
        isSynced: widget.expense?.isSynced ?? false,
      );

      if (_isEditing) {
        Provider.of<ExpenseProvider>(context, listen: false).updateExpense(expense);
      } else {
        Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Expense' : 'Add Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter an amount';
                          if (double.tryParse(value) == null) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Image'),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),
                      if (_image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(_image!, height: 150, width: double.infinity, fit: BoxFit.cover),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveExpense,
                icon: const Icon(Icons.save),
                label: Text(_isEditing ? 'Save Changes' : 'Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
