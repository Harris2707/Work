import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Calculator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const NativeCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NativeCalculator extends StatefulWidget {
  const NativeCalculator({super.key});

  @override
  State<NativeCalculator> createState() => _NativeCalculatorState();
}

class _NativeCalculatorState extends State<NativeCalculator> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  String result = '';

  void calculate(String operation) {
    final double? num1 = double.tryParse(num1Controller.text);
    final double? num2 = double.tryParse(num2Controller.text);

    if (num1 == null || num2 == null) {
      setState(() {
        result = 'Please enter valid numbers';
      });
      return;
    }

    double output;
    switch (operation) {
      case '+':
        output = num1 + num2;
        break;
      case '-':
        output = num1 - num2;
        break;
      case '×':
        output = num1 * num2;
        break;
      case '÷':
        if (num2 == 0) {
          result = 'Cannot divide by zero';
          setState(() {});
          return;
        }
        output = num1 / num2;
        break;
      default:
        result = 'Invalid Operation';
        setState(() {});
        return;
    }

    setState(() {
      result = 'Result: $output';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter first number'),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter second number'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: ['+', '-', '×', '÷'].map((op) {
                return ElevatedButton(
                  onPressed: () => calculate(op),
                  child: Text(op),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';

void main() {
  runApp(const FormValidationApp());
}

class FormValidationApp extends StatelessWidget {
  const FormValidationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Validation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyFormScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFormScreen extends StatefulWidget {
  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Validation")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}


dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.7.0

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Video Player',
      theme: ThemeData.dark(),
      home: const VideoPlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Use a sample video URL or your own
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}


import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Map<String, dynamic>> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _todos.add({'task': _controller.text, 'done': false});
        _controller.clear();
      });
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _todos[index]['done'] = !_todos[index]['done'];
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ToDo List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addTodo, child: const Text("Add")),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      todo['task'],
                      style: TextStyle(
                        decoration: todo['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo['done'],
                      onChanged: (_) => _toggleDone(index),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


//Web socket
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return MaterialApp(title: title, home: const MyHomePage(title: title));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  final _channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  void _sendMessage() {
    if (_controller.text.isNotEmpty) _channel.sink.add(_controller.text);
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) =>
                    Text(snapshot.hasData ? '${snapshot.data}' : ''),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMessage,
          tooltip: 'Send message',
          child: const Icon(Icons.send),
        ),
      );
}


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

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.0827, 80.2707); // Chennai

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map"), backgroundColor: Colors.teal),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('home'),
            position: _center,
            infoWindow: const InfoWindow(title: 'Chennai'),
          ),
        },
      ),
    );
  }
}


/* 
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0


In android/app/src/main/AndroidManifest.xml, inside the <application> tag, add:

<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>
Replace YOUR_API_KEY with your actual Google Maps API key.
*/

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(const MovieApp());

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Rating App',
      theme: ThemeData.dark(),
      home: const MovieListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Movie {
  final String title;
  double rating;

  Movie({required this.title, this.rating = 0.0});
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final List<Movie> movies = [
    Movie(title: "Inception"),
    Movie(title: "The Dark Knight"),
    Movie(title: "Interstellar"),
    Movie(title: "Avatar"),
    Movie(title: "Titanic"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Movies")),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(movie.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    initialRating: movie.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        movie.rating = rating;
                      });
                    },
                  ),
                  Text("Your Rating: ${movie.rating.toStringAsFixed(1)}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
/*
dependencies:
  flutter:
    sdk: flutter
  flutter_rating_bar: ^4.0.1
*/

import 'package:flutter/material.dart';

void main() => runApp(const ShoppingApp());

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> products = [
    Product("Shoes", 49.99),
    Product("T-shirt", 19.99),
    Product("Watch", 99.99),
    Product("Backpack", 39.99),
    Product("Sunglasses", 29.99),
  ];

  final List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  void showCart() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CartScreen(cart: cart),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: showCart,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              title: Text(product.name),
              subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
              trailing: ElevatedButton(
                child: const Text("Add"),
                onPressed: () => addToCart(product),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Product> cart;
  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.name),
                        trailing: Text("\$${item.price.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
    );
  }
}

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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _movies = [];
  final _controller = TextEditingController();

  Future<void> fetchMovies(int count) async {
    final response = await http.get(
      Uri.parse('https://www.freetestapi.com/api/v1/movies?limit=$count'),
    );
    if (response.statusCode == 200) {
      setState(() => _movies = json.decode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Number of movies'),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => fetchMovies(int.tryParse(_controller.text) ?? 0),
                  child: Text('Show'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder:
                  (_, i) => ListTile(
                    title: Text(_movies[i]['title']),
                    subtitle: Text('Rating: ${_movies[i]['rating']}'),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
