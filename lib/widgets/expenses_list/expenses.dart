import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/new_expense.dart';

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
        title: 'Work Expense',
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
      useSafeArea: true,
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
    final width = (MediaQuery.of(context).size.width);

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
              color: Colors.white,
            )
          ],
          title: const Text('Expense X'),
          elevation: 10,
          shadowColor: Colors.black54,
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(child: fallback),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: fallback),
                ],
              ));
  }
}
