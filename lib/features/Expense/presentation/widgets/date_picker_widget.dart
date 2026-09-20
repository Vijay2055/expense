import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget(
      {super.key, required this.onSelectDate, required this.selectedDate});
  final Function() onSelectDate;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate != null
                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'Select Date'),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.date_range)
          ],
        ),
      ),
    );
  }
}
