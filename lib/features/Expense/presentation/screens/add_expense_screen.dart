import 'package:expense_app/core/widgets/app_text_fiield.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_type_entity.dart';
import 'package:expense_app/features/Expense/presentation/providers/customer_notifier.dart';
import 'package:expense_app/features/Expense/presentation/providers/expense_notifier.dart';
import 'package:expense_app/features/Expense/presentation/widgets/date_picker_widget.dart';
import 'package:expense_app/features/Expense/providers/usecase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayDate = DateTime.now();

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, required this.customerId});
  final String customerId;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ExpenseTypeEntity expenseType = ExpenseTypeEntity.give;
  DateTime selectedDate = todayDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(todayDate.year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _amount.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _amount,
                        labelText: "Amount",
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount is required";
                          }

                          final amount = double.tryParse(value);
                          if (amount == null || amount < 0) {
                            return "Amount can't be less than zero";
                          }
                          if (amount > 10000000000) {
                            return "Too much amount";
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DatePickerWidget(
                        onSelectDate: () {
                          _selectDate();
                        },
                        selectedDate: selectedDate,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                AppTextField(
                  controller: _note,
                  labelText: "Description",
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(Icons.location_on),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 3) {
                      return "Invalid Address";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: Text("Money In"),
                      selected: expenseType == ExpenseTypeEntity.take,
                      onSelected: (value) {
                        setState(() {
                          expenseType = ExpenseTypeEntity.take;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ChoiceChip(
                      label: Text("Money Out"),
                      selected: expenseType == ExpenseTypeEntity.give,
                      onSelected: (value) {
                        setState(() {
                          expenseType = ExpenseTypeEntity.give;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final amount = double.tryParse(_amount.text.trim());
                        final notes = _note.text.trim();

                        final result =
                            await ref.read(addExpenseUsecaseProvider)(
                                amount: amount ?? 0,
                                customerId: widget.customerId,
                                date: selectedDate,
                                note: notes,
                                type: expenseType);
                        result.fold(ifLeft: (failure) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)));
                        }, ifRight: (response) {
                          ref.invalidate(customerListProvider);
                          ref
                              .read(expenseListProvider.notifier)
                              .loadExpense(customerId: widget.customerId);
                          Navigator.of(context).pop();
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
