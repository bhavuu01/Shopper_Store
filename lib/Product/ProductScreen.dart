import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Product/ItemDetails.dart';
import 'package:shopperstoreuser/Product/ProductDetails.dart';

import '../Models/BrandModel.dart';
import '../Models/ProductModel.dart';

class ProductScreen extends StatefulWidget {
  final BrandModel seletedBrand;

  ProductScreen({Key? key, required this.seletedBrand, required List<ProductModel> products}): super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  CollectionReference productRef = FirebaseFirestore.instance.collection('Products');

  Future<List<ProductModel>> readProduct() async {
    try {
      QuerySnapshot response = await productRef.get();

      List<ProductModel> products =
      response.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

      List<ProductModel> filteredProducts = products
          .where((element) => element.brand == widget.seletedBrand.brand)
          .toList();

      return filteredProducts;
    } catch (error) {
      print("Error reading products: $error");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: readProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final productDocs = snapshot.data!;

          return SingleChildScrollView(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              shrinkWrap: true,
              itemCount: productDocs.length,
              itemBuilder: (context, index) {
                return ProductCard(product: productDocs[index]);
              },
            ),
          );
        },
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductDetails(product: product)),
          );
        },
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.images![0], // Displaying only the first image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.productName,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(
                      '₹ ${product.productPrice}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'M.R.P ₹ ${product.newPrice}',
                      style: const TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


