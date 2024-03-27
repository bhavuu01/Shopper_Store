import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopperstoreuser/BottomNavigation/BottomNavigation.dart';

class PaymentScreen extends StatefulWidget {
  final String address;
  const PaymentScreen({Key? key, required this.address}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Cash on Delivery';
  double _subtotal = 0.0;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _calculateSubtotal();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _calculateSubtotal() async {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('ShoppingCart')
        .where('UID', isEqualTo: currentUserUID)
        .get();

    double subtotal = 0.0;
    cartSnapshot.docs.forEach((doc) {
      print('Total Price String: ${doc['totalprice']}'); // Add this line for logging
      try {
        double totalprice = double.parse(doc['totalprice']);
        subtotal += totalprice;
      } catch (e) {
        print('Error parsing total price: $e');
      }
    });

    setState(() {
      _subtotal = subtotal;
    });
  }

  void _openRazorpayCheckout() {
    var options = {
      'key': 'rzp_test_nLQYAWuOKvzENb',
      'amount': (_subtotal * 100).toInt(),
      'name': 'Shopper Store',
      'description': 'Payment for Order',
      'prefill': {
        'contact': 'USER_PHONE_NUMBER',
        'email': 'USER_EMAIL',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic
    _placeOrder('Online Payment');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment error logic
    print('Payment error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
    print('External wallet selected: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment via ${response.walletName} is in progress...'),
      ),
    );
  }


  Future<void> _placeOrder(String paymentMethod) async {
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
        'paymentMethod': paymentMethod,
        'products': products,
        'subtotal': _subtotal,
        'timestamp': Timestamp.now(),
        'UID': currentUserUID,
      });

      cartSnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your order has been placed.'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationScreen()),
      );
    } catch (error) {
      // Handle error
      print('Error placing order: $error');
    }
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
                if (_paymentMethod == 'Online Payment') {
                  _openRazorpayCheckout();
                } else {
                  await _placeOrder('Cash on Delivery');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              child: Center(
                child: Container(
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your order has been successfully placed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}