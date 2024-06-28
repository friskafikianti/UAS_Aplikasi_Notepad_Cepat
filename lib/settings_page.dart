import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isOn = false;
  String _openLargeNotePosition = 'where the note was viewed before';
  double _textSize = 16.0;
  bool _activeLinks = false;
  bool _showFoldersOnBack = false;

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Password'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To lock your notes either close the notepad via the back button (not home!) or don\'t use it for 1 hour.\n\nIf you set up both password and fingerprint, just one of them will be required to login.',
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
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
                // Handle password set logic here
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFingerprintDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.fingerprint),
              SizedBox(width: 8),
              Text('Fingerprint'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Touch the fingerprint sensor to enable.\n\n'
                  'To lock your notes either close the notepad via the back button (not home!) or don\'t use it for 1 hour. If you set up both fingerprint and password, just one of them will be required to login.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showOpenLargeNotesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Open large notes at position:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text('where the note was viewed before'),
                    value: 'where the note was viewed before',
                    groupValue: _openLargeNotePosition,
                    onChanged: (value) {
                      setState(() {
                        _openLargeNotePosition = value as String;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  RadioListTile(
                    title: const Text('top of the note'),
                    value: 'top of the note',
                    groupValue: _openLargeNotePosition,
                    onChanged: (value) {
                      setState(() {
                        _openLargeNotePosition = value as String;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  RadioListTile(
                    title: const Text('bottom of the note'),
                    value: 'bottom of the note',
                    groupValue: _openLargeNotePosition,
                    onChanged: (value) {
                      setState(() {
                        _openLargeNotePosition = value as String;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Text size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter text size',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _textSize = double.tryParse(value) ?? _textSize;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget for instant notes',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Take notes directly from your lock screen and while using other apps',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: _showPasswordDialog,
              child: const Text(
                'Password',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _showFingerprintDialog,
              child: const Text(
                'Fingerprint',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _showOpenLargeNotesDialog,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Open large notes at position:',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    _openLargeNotePosition,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _showTextSizeDialog,
              child: const Text(
                'Text Size',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Export Notes/Backup',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Links in Notes',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Switch(
                  value: _activeLinks,
                  onChanged: (value) {
                    setState(() {
                      _activeLinks = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Show Folders on Tapping Back',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Tap back twice to quit',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    Switch(
                      value: _showFoldersOnBack,
                      onChanged: (value) {
                        setState(() {
                          _showFoldersOnBack = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.black,
            mini: true,
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

