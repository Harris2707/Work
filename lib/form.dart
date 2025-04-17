import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Form Validation Demo',
        theme: ThemeData(primarySwatch: Colors.blue), // Removed const here
        home: const MyForm(),
      );
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _validateName(String? value) => value?.isEmpty ?? true
      ? 'Please enter your name'
      : value!.contains(RegExp(r'[0-9]'))
          ? 'Name cannot contain numbers'
          : null;

  String? _validateEmail(String? value) => value?.isEmpty ?? true
      ? 'Please enter your email'
      : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)
          ? 'Please enter a valid email'
          : null;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form validated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Form Validation')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _submitForm, child: const Text('Submit')),
              ],
            ),
          ),
        ),
      );
}
