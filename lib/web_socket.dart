import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const WebSocketApp());

class WebSocketApp extends StatelessWidget {
  const WebSocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Echo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WebSocketScreen(),
    );
  }
}

class WebSocketScreen extends StatefulWidget {
  const WebSocketScreen({super.key});

  @override
  State<WebSocketScreen> createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.org'), // Echo server
  );

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket Echo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message'),
              onSubmitted: (_) => _sendMessage(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _sendMessage, child: const Text("Send")),
            const SizedBox(height: 20),
            const Text("Echoed Response:"),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? '${snapshot.data}' : 'Waiting for response...',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
dependencies:
  flutter:
    sdk: flutter
  web_socket_channel: ^2.4.0


Note: wss://echo.websocket.org was discontinued, use a test server like wss://ws.ifelse.io if needed.
*/