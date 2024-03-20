

import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Payment/Address.dart';

import '../Models/ProductModel.dart';

class CheckOutScreen extends StatefulWidget {
  final List<ProductModel> cartItems;

  const CheckOutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double totalPrice = 0;
  double totalDiscount = 0;
  double deliveryCharges = 0;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    _calculatePriceDetails();
  }

  void _calculatePriceDetails() {
    totalPrice = 0;
    totalDiscount = 0;
    for (var product in widget.cartItems) {
      double productPrice = double.parse(product.productPrice.replaceAll(',', ''));
      double newPrice = double.parse(product.newPrice.replaceAll(',', ''));
      totalPrice += productPrice * int.parse(product.selectedqty);
      totalDiscount += (productPrice - newPrice) * int.parse(product.selectedqty);
    }

    subtotal = totalPrice - totalDiscount + deliveryCharges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                ProductModel product = widget.cartItems[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                      leading: Image.network(
                        product.images![0],
                        width: 100,
                        height: 150,
                        // fit: BoxFit.cover,
                      ),
                      title: Text(
                        product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product.productPrice}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text('MRP ${product.newPrice}'),
                          Text('Qty: ${product.selectedqty}'),
                          Text('Total Price ${product.totalprice}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Price Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Product Price:'),
                        Text('₹$totalPrice'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Discount:'),
                        Text('₹$totalDiscount'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Charges:'),
                        Text('₹$deliveryCharges'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$subtotal',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(14.0), // Adjust padding as needed
            child: Text(
              'Subtotal: ₹$subtotal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black, // Change color according to your preference
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Address()));
                },
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}