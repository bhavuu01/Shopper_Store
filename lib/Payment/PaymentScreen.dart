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

  @override
  Widget build(BuildContext context) {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('ShoppingCart')
                    .where('UID', isEqualTo: currentUserUID)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(doc['images'][0]),
                            title: Text(
                              doc['productName'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MRP: ${doc['productPrice']}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  'Product Price: ${doc['productNewPrice']}',

                                ),
                                Text(
                                  'Quantity: ${doc['quantity']}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Text('No Orders Found');
                },
              ),
            ),
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
            ElevatedButton(
              onPressed: () {

                FirebaseFirestore.instance.collection('Orders').add({
                  'paymentMethod': _paymentMethod,

                }).then((value) {
                  // Handle success
                }).catchError((error) {
                  // Handle error
                });
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
