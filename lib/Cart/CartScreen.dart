import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/ProductModel.dart';

class AddToCartScreen extends StatefulWidget {
  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  List<ProductModel> _cartItems = [];
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserCartProducts();
  }

  Future<void> _fetchUserCartProducts() async {
    try {
      String UID = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ShoppingCart')
          .where('UID', isEqualTo: UID)
          .get();

      List<ProductModel> products = [];
      double subtotal = 0.0;
      querySnapshot.docs.forEach((doc) {
        ProductModel product = ProductModel.fromSnapshot(doc);
        try {
          // Remove commas from the price string
          String priceWithoutCommas = product.newPrice.replaceAll(',', '');
          // Parse the price as a double
          double totalPrice = double.parse(priceWithoutCommas) * int.parse(product.selectedqty);
          // Assign the calculated total price to the product
          product.totalprice = totalPrice.toString();
          subtotal += totalPrice;
        } catch (e) {
          print('Error calculating total price: $e');
        }
        products.add(product);
      });

      setState(() {
        _cartItems = products;
        _subtotal = subtotal;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _deleteProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection('ShoppingCart')
          .doc(product.id)
          .delete();

      // Refresh cart items after deletion
      _fetchUserCartProducts();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void _updateQuantity(ProductModel product, int quantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('ShoppingCart')
          .doc(product.id)
          .update({'quantity': quantity.toString()});

      // Refresh cart items after updating quantity
      _fetchUserCartProducts();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          ProductModel product = _cartItems[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0), // Added this line
                leading: Image.network(
                  product.images![0],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(product.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M.R.P: ${product.newPrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Price: ${product.totalprice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                int newQuantity =
                                    int.parse(product.selectedqty) - 1;
                                if (newQuantity >= 0) {
                                  _updateQuantity(product, newQuantity);
                                }
                              },
                            ),
                            Text(product.selectedqty.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                int newQuantity =
                                    int.parse(product.selectedqty) + 1;
                                _updateQuantity(product, newQuantity);
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(product);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal: $_subtotal',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            ElevatedButton(
              onPressed: () {
                // Navigate to checkout screen or perform checkout logic
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(product);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}