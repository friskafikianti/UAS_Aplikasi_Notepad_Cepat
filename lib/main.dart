import 'package:flutter/material.dart';

void main() {
  runApp(MyNotepadApp());
}

class MyNotepadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad Cepat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 141, 156), // Warna abu-abu lebih gelap
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Tambahkan aksi untuk menu panel
          },
        ),
        title: Text('My Notes', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Tambahkan aksi untuk tombol search
                print("Search button pressed");
              },
            ),
          ),
        ],
      ),
      body: Container(), // Halaman kosong
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan aksi untuk tombol tambah
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Note',
        backgroundColor: Color.fromARGB(255, 122, 141, 156), // Warna abu-abu lebih gelap
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  bool isImportant = false;
  Color backgroundColor = Colors.white;

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: 200,
            height: 215,
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
              ? Icon(Icons.check, color: Colors.black)
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Allow Fast Notepad to run on device startup',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
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
                // Tambahkan aksi untuk "Take Me To Setting"
                print('Take Me To Setting pressed');
              },
              child: Text('Take Me To Setting'),
            ),
            TextButton(
              onPressed: () {
                // Tambahkan aksi untuk "don't show again"
                print('Don\'t show again pressed');
              },
              child: Text('Don\'t show again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Later'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 141, 156), // Warna abu-abu lebih gelap
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Tambahkan aksi untuk tombol back
            Navigator.pop(context);
            print("navigate up");
          },
          tooltip: 'Navigate Up', // Menambahkan tooltip
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
              icon: Icon(Icons.color_lens, color: Colors.white),
              onPressed: _openColorPicker,
              tooltip: 'Colour of this note',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: PopupMenuButton(
              icon:  Icon(Icons.more_vert, color: Colors.white),
              tooltip: 'Opsi Lainnya',
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 'reminder',
                  child: Text('Reminder'),
                ),
                PopupMenuItem(
                  value: 'undo_edit',
                  child: Text('Undo Edit'),
                ),
                PopupMenuItem(
                  value: 'to_the_end',
                  child: Text('To the End'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                PopupMenuItem(
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
      body: Container(
        color: backgroundColor, // Mengubah warna background
      ), // Halaman kosong
    );
  }
}
