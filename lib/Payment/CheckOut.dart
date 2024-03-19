import 'package:flutter/material.dart';

import '../Models/ProductModel.dart';

class CheckOutScreen extends StatefulWidget {
  final List<ProductModel> cartItems;

  const CheckOutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    double totalDiscount = 0;
    double deliveryCharges = 0;


    widget.cartItems.forEach((product) {
      double productPrice = double.parse(product.productPrice.replaceAll(',', ''));
      double newPrice = double.parse(product.newPrice.replaceAll(',', ''));
      totalPrice += productPrice;
      totalDiscount += (productPrice - newPrice);
    });

    double subtotal = totalPrice - totalDiscount + deliveryCharges;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
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
                    padding: EdgeInsets.all(20.0),
                    child: ListTile(
                      leading: Image.network(
                        product.images![0],
                        width: 100,
                        height: 100,
                      ),
                      title: Text(
                        product.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product.productPrice}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text('MRP ${product.totalprice}'),
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
            padding: EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Price Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product Price:'),
                        Text('₹$totalPrice'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Discount:'),
                        Text('₹$totalDiscount'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Charges:'),
                        Text('₹$deliveryCharges'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$subtotal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}