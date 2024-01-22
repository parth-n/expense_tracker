import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titlecontroller =
      TextEditingController(); // it is a class provided by flutter
  final _amountcontroller = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  void _presentDatePicker() async {
    // date picker function , show date picker is inbuilt.
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(
        _amountcontroller.text); // tryParse('hello)=> null, tryParse('10')=> 10

    final invalidAmount = enteredAmount == null || enteredAmount <= 0;
    if (_titlecontroller.text.trim().isEmpty ||
        invalidAmount ||
        _selectedDate == null) {
      // trim removes whitespace
      //show error
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure a valid Title,amount,Date and cateogory was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Ok'))
                ],
              ));
      return; // no code after this will be executed if control comes to the if statement.
    }
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        TextField(
          controller: _titlecontroller,
          maxLength: 50,
          decoration: const InputDecoration(
            label: Text('Title'),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '₹',
                  label: Text('Amount'),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_selectedDate == null
                    ? 'No Selected Date'
                    : formatter.format(
                        _selectedDate!)), //! is added to force dart to assume that _selectedDate wont be null
                IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month)),
              ],
            ))
          ],
        ),
        Row(
          children: [
            DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase())))
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: _submitExpenseData,
              child: const Text('Save'),
            ),
          ],
        )
      ]),
    );
  }
}
