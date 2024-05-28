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
        backgroundColor: Color.fromARGB(255, 122, 141, 156),  
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
      body: Container(), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan aksi untuk tombol tambah
          print("Add button pressed");
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Note',
        backgroundColor: Color.fromARGB(255, 122, 141, 156), 
      ),
    );
  }
}
