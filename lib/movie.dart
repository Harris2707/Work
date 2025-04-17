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
