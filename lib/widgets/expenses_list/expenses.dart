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
    setState(() {
      _registeredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.deepPurple.shade400,
          shadowColor: Colors.black54,
        ),
        body: Column(
          children: [
            const Text('Chart'),
            Expanded(
                child: ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            )),
          ],
        ));
  }
}
