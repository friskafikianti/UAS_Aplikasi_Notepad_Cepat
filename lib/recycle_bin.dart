import 'package:flutter/material.dart';
import 'note.dart';
import 'edit_note_page.dart';
import 'settings_page.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'search.dart';

class RecycleBinPage extends StatefulWidget {
  const RecycleBinPage({super.key, this.deletedNote});
  final Note? deletedNote;

  @override
  _RecycleBinPageState createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  final List<Note> _notes = [];
  bool _showMenu = false; // Menambahkan variabel untuk menu
  Color backgroundColor = Colors.white;
  Color appBarColor = Colors.blue;
  Color floatingActionButtonColor = Colors.blue;
  bool _darkTheme = false;

  @override
  void initState() {
    super.initState();
    if (widget.deletedNote != null) {
      _notes.add(widget.deletedNote!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _darkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              setState(() {
                _showMenu = !_showMenu; // Toggle menu visibility
              });
            },
          ),
          title:
              const Text('Recycle-bin', style: TextStyle(color: Colors.white)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  _showSearchPopup();
                },
              ),
            ),
          ],
        ),
        body: Container(
          color: _darkTheme ? Colors.black : Colors.white,
          child: Stack(
            children: [
              ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  Note note = _notes[index];
                  return Card(
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: Text(note.date),
                      leading: Container(
                        width: 5,
                        color: note.color,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNotePage(
                              note: note,
                              onSave: (newNote) {
                                setState(() {
                                  _notes[index] = newNote;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        _showPopupMenu(context, index);
                      },
                    ),
                  );
                },
              ),
              if (_showMenu)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 100,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            width: 1, color: Colors.grey), // Add a left border
                      ),
                      color: Colors.white, // Set the background color here
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.star),
                          title: const Text('My Notes'),
                          onTap: () {
                            setState(() {
                              _showMenu = false; // Hide menu
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Recycle-bin'),
                          onTap: () {
                            setState(() {
                              _showMenu = false; // Hide menu
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('New folder'),
                          onTap: () {
                            setState(() {
                              _showMenu = false; // Hide menu
                            });
                             _showNewFolderDialog(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.palette),
                          title: const Text('Theme'),
                          onTap: () {
                            setState(() {
                              _showMenu = false;
                            });
                            _showThemePopup();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            setState(() {
                              _showMenu = false; // Hide menu
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List<Note> deletedNotes =
                List.from(_notes); // Simpan catatan yang dihapus sementara
            setState(() {
              _notes.clear(); // Hapus semua catatan dari Recycle Bin
            });

            // Tampilkan SnackBar dengan aksi undo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Recycle bin cleared'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() {
                      _notes.addAll(
                          deletedNotes); // Kembalikan catatan yang dihapus
                    });
                  },
                ),
              ),
            );
          },
          backgroundColor: floatingActionButtonColor,
          child: const Icon(Icons.delete_sweep, color: Colors.white),
        ),
      ),
    );
  }

  void _showSearchPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController searchController = TextEditingController();
        return AlertDialog(
          title: const Text('Search in all folders'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Enter folder name',
              border: UnderlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchPage(keyword: searchController.text),
                  ),
                );
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () {
                // Tambahkan logika pencarian di sini
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, int index) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        const PopupMenuItem(
          value: 'completed',
          child: Row(
            children: [
              Icon(Icons.check, color: Colors.blue),
              Text('Completed'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, color: Colors.blue),
              Text('Copy'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'ove_to_folder',
          child: Row(
            children: [
              Icon(Icons.folder, color: Colors.blue),
              Text('Move to Folder'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.blue),
              Text('Delete'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'cancel',
          child: Text('CANCEL'),
        ),
      ],
      elevation: 8.0,
    ).then((value) async {
      // <--- Add async here
      if (value == 'completed') {
        setState(() {
          _notes[index].color = Colors.green; // Change the color to green
        });
      } else if (value == 'copy') {
        final textToCopy = _notes[index].content; // Get the text to copy
        ClipboardData data = ClipboardData(text: textToCopy);
        await Clipboard.setData(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      } else if (value == 'ove_to_folder') {
        // Add code to handle moving to folder here
        print('Move to folder clicked');
      } else if (value == 'delete') {
        setState(() {
          _notes.removeAt(index);
        });
      } else if (value == 'cancel') {
        // Add code to handle canceling the action here
        print('Cancel clicked');
      }
    });
  }

  void _showNewFolderDialog(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(
              hintText: 'Enter folder name',
              border: UnderlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan nama folder baru di sini
                print('Folder Name: ${folderNameController.text}');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

   void _showThemePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.25, 
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // adjust column height to fit content
              children: [
                Wrap(
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
                            floatingActionButtonColor = color;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40, // keep color box size fixed
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dark Theme'),
                    Switch(
                      value: _darkTheme,
                      onChanged: (value) {
                        setState(() {
                          _darkTheme = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
