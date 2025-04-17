import 'package:flutter/material.dart';
import 'customer_db.dart';
import 'customer_form.dart';

void main() {
  runApp(CustomerApp());
}

class CustomerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CustomerListScreen(),
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final customers = await CustomerDB.instance.getAllCustomers();
    setState(() {
      _customers = customers;
    });
  }

  void _addCustomer() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomerForm(),
    );

    if (result != null) {
      await CustomerDB.instance.insertCustomer(result);
      _fetchCustomers();
    }
  }

  void _editCustomer(Map<String, dynamic> customer) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomerForm(customer: customer),
    );

    if (result != null) {
      await CustomerDB.instance.updateCustomer(customer['id'], result);
      _fetchCustomers();
    }
  }

  void _deleteCustomer(int id) async {
    await CustomerDB.instance.deleteCustomer(id);
    _fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Manager')),
      body: ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return ListTile(
            title: Text(customer['name']),
            subtitle: Text('Age: ${customer['age']}, Phone: ${customer['phone']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editCustomer(customer),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCustomer(customer['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addCustomer,
      ),
    );
  }
}
