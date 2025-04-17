import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Notes',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Database db;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'notes.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT)');
      },
    );
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final data = await db.query('notes');
    setState(() {
      _notes = data;
    });
  }

  Future<void> _addNote() async {
    String title = _controller.text.trim();
    if (title.isNotEmpty) {
      await db.insert('notes', {'title': title});
      _controller.clear();
      _fetchNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Notes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Enter note'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(_notes[i]['title']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNote(_notes[i]['id']),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.2
  path: ^1.9.0
  path_provider: ^2.1.2
*/