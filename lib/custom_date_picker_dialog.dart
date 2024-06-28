import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime selectedDate;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    final days = DateFormat.EEEE('id').format(selectedDate);
    final months = DateFormat.MMMM('id').format(selectedDate);
    final dates = DateFormat.d('id').format(selectedDate);
    final years = DateFormat.y('id').format(selectedDate);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: screenWidth * 0.25,
        child: SingleChildScrollView( 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(days,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                  Text(months,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 25)),
                  Text(dates,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 50)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: SizedBox(
                              width: screenWidth * 0.7, // adjust width to 60% of screen width
                              height: screenHeight * 0.5,
                              child: YearPicker(
                                selectedDate: selectedDate,
                                onChanged: (DateTime dateTime) {
                                  setState(() {
                                    selectedYear = dateTime.year;
                                    selectedDate = DateTime(selectedYear,
                                        selectedDate.month, selectedDate.day);
                                    Navigator.pop(context);
                                  });
                                },
                                firstDate: widget.firstDate,
                                lastDate: widget.lastDate,
                              ),
                            ),

                          );
                        },
                      );
                    },
                    child: Text(
                      years,
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                selectableDayPredicate: (DateTime date) {
                  return true;
                },
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('BATAL', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedDate);
                  },
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

