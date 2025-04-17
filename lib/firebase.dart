import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notes',
      theme: ThemeData(primarySwatch: Colors.indigo),
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
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> _addNote() async {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      await _notes.add({'title': text, 'timestamp': Timestamp.now()});
      _controller.clear();
    }
  }

  Future<void> _deleteNote(String id) async {
    await _notes.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Notes")),
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
            child: StreamBuilder(
              stream: _notes.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    var note = docs[i];
                    return ListTile(
                      title: Text(note['title']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteNote(note.id),
                      ),
                    );
                  },
                );
              },
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
  firebase_core: ^2.25.4
  cloud_firestore: ^4.14.0
*/

/*
Go to Firebase Console, create a project.

Add an Android/iOS app to it and download the google-services.json or GoogleService-Info.plist.

Add the file to your Flutter app's android/app or ios/Runner folder.

In android/build.gradle, add:

classpath 'com.google.gms:google-services:4.3.15'

In android/app/build.gradle, add:

apply plugin: 'com.google.gms.google-services'
*/