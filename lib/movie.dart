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