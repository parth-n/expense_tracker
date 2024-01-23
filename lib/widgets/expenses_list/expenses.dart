import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Food',
        amount: 20.50,
        date: DateTime.now(),
        category: Category.food),
  ];

  void _openExpenseList() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fallback = const Center(
      child: Text('Add Expenses to Start'),
    );

    if (_registeredExpenses.isNotEmpty) {
      fallback = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _openExpenseList,
              icon: const Icon(Icons.add),
              color: Colors.black,
            )
          ],
          title: const Text('Expense Tracker'),
          elevation: 10,
          shadowColor: Colors.black54,
        ),
        body: Column(
          children: [
            const Text('Chart'),
            Expanded(child: fallback),
          ],
        ));
  }
}
