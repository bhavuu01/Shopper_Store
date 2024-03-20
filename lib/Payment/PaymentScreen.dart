import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Cash on Delivery';
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateSubtotal();
  }

  void _calculateSubtotal() async {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('ShoppingCart')
        .where('UID', isEqualTo: currentUserUID)
        .get();

    double subtotal = 0.0;
    cartSnapshot.docs.forEach((doc) {
      double totalprice = double.parse(doc['totalprice']);
      subtotal += totalprice;
    });

    setState(() {
      _subtotal = subtotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Cash on Delivery'),
              leading: Radio(
                value: 'Cash on Delivery',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Online Payment'),
              leading: Radio(
                value: 'Online Payment',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Subtotal: $_subtotal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Fetch the user's shopping cart items
                  String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
                  QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
                      .collection('ShoppingCart')
                      .where('UID', isEqualTo: currentUserUID)
                      .get();

                  // Extract product details from the shopping cart
                  List<Map<String, dynamic>> products = [];
                  cartSnapshot.docs.forEach((doc) {
                    Map<String, dynamic> productData = {
                      'productName': doc['productName'],
                      'productPrice': doc['productPrice'],
                      'quantity': doc['quantity'],
                      'totalPrice': doc['totalprice'],
                    };
                    products.add(productData);
                  });

                  // Add the order to the Orders collection
                  await FirebaseFirestore.instance.collection('Orders').add({
                    'paymentMethod': _paymentMethod,
                    'products': products,
                    'subtotal': _subtotal,
                    'timestamp': Timestamp.now(),
                    'UID': currentUserUID,

                  });

                  // Handle success
                } catch (error) {
                  // Handle error
                  print('Error placing order: $error');
                }
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}