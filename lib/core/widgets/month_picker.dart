import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_linear_date_picker/persian_linear_date_picker.dart';

class CustomMonthPicker extends StatelessWidget {
  String? selectYear;
  String? selectMonth;

  final String? initialDate;

  final String formattedData = Jalali.now()
      .toString()
      .replaceFirst('Jalali(', '')
      .replaceAll(' ', '')
      .replaceAll(',', '/')
      .replaceFirst(')', '')
      .split('/0')
      .first;

  CustomMonthPicker({
    super.key,
    this.initialDate = "",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: PersianLinearDatePicker(
        endDate: formattedData,
        initialDate: initialDate ?? formattedData,
        startDate: "1390/01/01",
        showDay: false,
        dateChangeListener: (selectedDate) {
          if (selectedDate.trim().isEmpty) {
            return;
          }
          selectYear = selectedDate.split('/').first;
          selectMonth = selectedDate.split('/').last;
        },
        showMonthName: true,
        columnWidth: 90,
        labelStyle: const TextStyle(
          fontFamily: 'IranSans',
          color: Colors.blue,
        ),
        selectedRowStyle: const TextStyle(
          fontFamily: 'IranSans',
          fontSize: 22,
          color: Colors.blue,
        ),
        unselectedRowStyle: const TextStyle(
          fontFamily: 'IranSans',
        ),
        isPersian: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            selectYear == null
                ? null
                : {
                    'year': selectYear,
                    'month': selectMonth,
                  },
          ),
          child: const Text('تایید'),
        ),
      ],
    );
  }
}
