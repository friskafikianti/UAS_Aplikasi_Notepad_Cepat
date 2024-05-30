import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MyNotepadApp());
}

class MyNotepadApp extends StatelessWidget {
  const MyNotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad Cepat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text('My Notes', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                print("Search button pressed");
              },
            ),
          ),
        ],
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
        },
        tooltip: 'Add Note',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  bool isImportant = false;
  Color backgroundColor = Colors.white;
  bool showTomorrowButton = false;
  bool showTimeButton = false;
  DateTime selectedDate = DateTime.now();
  String tomorrowButtonText = 'Tomorrow';
  String timeButtonText = '09.00';

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 150,
            height: 220,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _colorPickerTile(Colors.pink),
                _colorPickerTile(Colors.purple),
                _colorPickerTile(Colors.deepPurple),
                _colorPickerTile(Colors.blue),
                _colorPickerTile(Colors.green),
                _colorPickerTile(Colors.lightGreen),
                _colorPickerTile(Colors.lightBlue),
                _colorPickerTile(Colors.blueAccent),
                _colorPickerTile(Colors.yellow),
                _colorPickerTile(Colors.orange),
                _colorPickerTile(Colors.red),
                _colorPickerTile(Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorPickerTile(Color color) {
    Color borderColor;
    if (color == Colors.white) {
      borderColor = Colors.grey;
    } else {
      borderColor = darkenColor(color);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          backgroundColor = color;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: color == backgroundColor
              ? const Icon(Icons.check, color: Colors.black)
              : null,
        ),
      ),
    );
  }

  Color darkenColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red * 0.7).toInt(),
      (color.green * 0.7).toInt(),
      (color.blue * 0.7).toInt(),
    );
  }

  void _showReminderPopup() {
    setState(() {
      showTomorrowButton = true;
      showTimeButton = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'Allow Fast Notepad to run on device startup',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fast Notepad need to run on device startup (in background) to reactive your reminders, which are normally erased on device shutdown',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10),
              Text(
                'Otherwise, to receive reminders after reboots on your devices, you\'ll have to start Fast Notepad manually',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Take Me To Setting pressed');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Take Me To Setting'),
            ),
            TextButton(
              onPressed: () {
                print('Don\'t show again pressed');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Don\'t show again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tomorrowButtonText = DateFormat('dd MMMM', 'id').format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        timeButtonText = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Mengubah warna navbar menjadi biru
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            print("navigate up");
          },
          tooltip: 'Navigate Up',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                isImportant ? Icons.star : Icons.star_border,
                color: isImportant ? Colors.yellow : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isImportant = !isImportant;
                });
              },
              tooltip: isImportant ? 'Remove from important' : 'Important',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.color_lens, color: Colors.white),
              onPressed: _openColorPicker,
              tooltip: 'Colour of this note',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              tooltip: 'Opsi Lainnya',
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 'reminder',
                  child: Text('Reminder'),
                ),
                const PopupMenuItem(
                  value: 'undo_edit',
                  child: Text('Undo Edit'),
                ),
                const PopupMenuItem(
                  value: 'to_the_end',
                  child: Text('To the End'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Text('Share'),
                ),
              ],
              onSelected: (value) {
                if (value == 'reminder') {
                  _showReminderPopup();
                } else {
                  // Tambahkan aksi sesuai dengan pilihan menu yang dipilih
                }
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: backgroundColor,
          ),
          if (showTomorrowButton)
            Positioned(
              top: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(
                  tomorrowButtonText,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          if (showTimeButton)
            Positioned(
              top: 20,
              left: 150,
              child: ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text(
                  timeButtonText,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePickerDialog({super.key, 
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(days, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  Text(months, style: const TextStyle(color: Colors.white, fontSize: 25)),
                  Text(dates, style: const TextStyle(color: Colors.white, fontSize: 50)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: SizedBox(
                              width: 250,
                              height: 300,
                              child: YearPicker(
                                selectedDate: selectedDate,
                                onChanged: (DateTime dateTime) {
                                  setState(() {
                                    selectedYear = dateTime.year;
                                    selectedDate = DateTime(selectedYear, selectedDate.month, selectedDate.day);
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
                  child: const Text('BATAL', style: TextStyle(color: Colors.blue)),
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
    );
  }
}
