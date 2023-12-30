import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_linear_date_picker/persian_linear_date_picker.dart';

class CustomMonthPicker extends StatefulWidget {
  final String? initialDate;

  const CustomMonthPicker({
    super.key,
    this.initialDate = "",
  });

  @override
  State<CustomMonthPicker> createState() => _CustomMonthPickerState();
}

class _CustomMonthPickerState extends State<CustomMonthPicker> {
  String? selectYear;

  String? selectMonth;

  final String formattedData = Jalali.now()
      .toString()
      .replaceFirst('Jalali(', '')
      .replaceAll(' ', '')
      .replaceAll(',', '/')
      .replaceFirst(')', '')
      .split('/0')
      .first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: PersianLinearDatePicker(
        endDate: formattedData,
        initialDate: widget.initialDate ?? formattedData,
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
