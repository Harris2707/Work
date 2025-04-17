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
