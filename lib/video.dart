import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Simple Video Player',
        theme: ThemeData.dark(),
        home: const VideoPlayerScreen(),
        debugShowCheckedModeBanner: false,
      );
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
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )..initialize().then((_) => setState(() {}));

    _controller.addListener(() {
      setState(() {}); // Rebuild UI on video state changes
    });
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          onPressed: () => setState(() =>
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play()),
                          child: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      );
}
