import 'package:flutter/material.dart';
import 'note.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import 'custom_date_picker_dialog.dart';
import 'custom_time_picker_dialog.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  final Function(Note) onSave;

  const EditNotePage({super.key, required this.note, required this.onSave});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  bool isImportant = false;
  bool _showButtons = true;
  Color backgroundColor = Colors.white;
  bool showTomorrowButton = false;
  bool showTimeButton = false;
  DateTime selectedDate = DateTime.now();
  String tomorrowButtonText = 'Tomorrow';
  String timeButtonText = '09.00';
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _noteController = TextEditingController();
  bool _showRedoEdit = false;
  String _previousText = '';
  bool _toTheTop = false;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  File? _selectedImage; // Menambahkan properti untuk gambar
  Color appBarColor = Colors.blue;
  Color floatingActionButtonColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  void _navigateUp() {
    String text = _noteController.text.trim();
    if (text.isNotEmpty || _selectedImage != null) {
      Note note = Note(
        title: text,
        content: text,
        date: DateFormat('dd MMMM', 'id').format(selectedDate),
        color: backgroundColor,
        image: _selectedImage, // Menambahkan gambar ke dalam note
      );
      widget.onSave(note);
    }
    Navigator.pop(context);
  }

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
    TimeOfDay? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePickerDialog(
          initialTime: selectedTime,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeButtonText = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_noteController.text.isNotEmpty) {
            Note note = Note(
              title: _noteController.text.length > 20
                  ? _noteController.text.substring(0, 20)
                  : _noteController.text,
              content: _noteController.text,
              date: DateFormat('dd MMMM yyyy', 'id').format(selectedDate),
              color: backgroundColor, // Menambahkan gambar ke dalam note
            );
            widget.onSave(note);
          }
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _navigateUp, // Call the _navigateUp function here
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
                    tooltip:
                        isImportant ? 'Remove from important' : 'Important',
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
                      if (_showRedoEdit)
                        const PopupMenuItem(
                          value: 'edo_edit',
                          child: Text('Redo Edit'),
                        ),
                      PopupMenuItem(
                        value: _toTheTop ? 'to_the_end' : 'to_the_top',
                        child: Text(_toTheTop ? 'To The End' : 'To The Top'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: 'hare',
                        child: Text('Share'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'reminder') {
                        _showReminderPopup();
                      } else if (value == 'undo_edit') {
                        if (_noteController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: const Text(
                                  'Nothing to undo: you have not edited this note',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              );
                            },
                          );
                        } else {
                          setState(() {
                            _showRedoEdit = true;
                            _previousText = _noteController.text;
                            _noteController.text = '';
                          });
                        }
                      } else if (value == 'edo_edit') {
                        setState(() {
                          _showRedoEdit = false;
                          _noteController.text = _previousText;
                        });
                      } else if (value == 'to_the_top') {
                        _controller.selection =
                            const TextSelection(baseOffset: 0, extentOffset: 0);
                        _focusNode.requestFocus();
                        setState(() {
                          _toTheTop = true;
                        });
                      } else if (value == 'to_the_end') {
                        _controller.selection = TextSelection(
                            baseOffset: _controller.text.length,
                            extentOffset: _controller.text.length);
                        _focusNode.requestFocus();
                        setState(() {
                          _toTheTop = false;
                        });
                      } else if (value == 'delete') {
                        _noteController.text = '';
                        setState(() {
                          _showButtons = true;
                          showTomorrowButton = false;
                          showTimeButton = false;
                          backgroundColor = Colors.white;
                          isImportant = false;
                        });
                        Navigator.of(context).pop();
                      } else if (value == 'hare') {
                        // Bagikan catatan ke sosial media
                        Share.share(
                          _noteController.text,
                          subject: 'Catatan Penting',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil dibagikan')),
                        );
                      } else {}

                      TextField(
                        controller: _noteController,
                        cursorColor: Colors.blue,
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Stack(children: [
              Container(
                color: backgroundColor,
              ),
              if (_showButtons && showTomorrowButton && showTimeButton)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                child: Text(
                                  tomorrowButtonText,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _selectTime(context);
                                },
                                child: Text(
                                  timeButtonText,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showButtons = false;
                              });
                            },
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30,
                                    height: 2,
                                    color: Colors.white,
                                    transform: Matrix4.rotationZ(pi / 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _noteController,
                        focusNode: _focusNode,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter your note',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _noteController,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter your note',
                      border: InputBorder.none,
                    ),
                  ),
                ),
            ])));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showThemePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme'),
          content: SizedBox(
            width: 300,
            height: 200,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (Color color in [
                  Colors.red,
                  Colors.orange,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.grey
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        appBarColor = color;
                        floatingActionButtonColor =
                            color; // Ubah warna FloatingActionButton juga
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
