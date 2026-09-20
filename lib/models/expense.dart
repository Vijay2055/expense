import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();
final dateFormatter = DateFormat.yMd();

enum Category { food, leisure, travel, work }

const categoryIcons = {
  Category.food: Icons.food_bank,
  Category.leisure: Icons.timelapse,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
  }) : id = uid.v4();
  final String id;
  final double amount;
  final DateTime date;
  final String title;
  final Category category;

  String get formattedDate {
    return dateFormatter.format(date);
  }

  Map get categoryIcon {
    return categoryIcons;
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpense {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
