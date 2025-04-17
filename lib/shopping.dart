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
