import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Product/ProductDetails.dart';

import '../Models/FavModel.dart';
import '../Models/ProductModel.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  late List<FavModel> favoriteProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    try {
      final UID = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Favorites')
          .where('UID', isEqualTo: UID)
          .get();

      final List<FavModel> products = snapshot.docs.map((doc) {
        return FavModel(
          id: doc.id,
          productName: doc['productName'],
          newPrice: doc['productNewPrice'],
          // productPrice: doc['productPrice'],
          selectedqty: doc['quantity'],
          // totalprice: doc['totalprice'],
          images: List<String>.from(doc['images'] ?? []),
        );
      }).toList();

      setState(() {
        favoriteProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching favorite products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: isLoading
          ? Center(
           child: CircularProgressIndicator(),
      )
          : favoriteProducts.isEmpty
          ? Center(
           child: Text('No favorite products found'),
      )
          : ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
             final product = favoriteProducts[index];
             return Card(
             child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 150,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.images![0],
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(product.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: ${product.newPrice}'),
                    Text('Quantity: ${product.selectedqty}')
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Add the product to the cart and remove from favorites
                    _addToCartAndRemoveFromFavorites(product);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addToCartAndRemoveFromFavorites(FavModel product) async {
    try {
      // Add the product to the cart
      await FirebaseFirestore.instance.collection('ShoppingCart').add({
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'images': product.images,
        'productName': product.productName,
        'productNewPrice': product.newPrice,
        'quantity': product.selectedqty,
        // 'totalprice': product.totalprice,

      });

      await FirebaseFirestore.instance.collection('Favorites').doc(product.id).delete();

      fetchFavoriteProducts();
    } catch (e) {
      print('Error adding to cart and removing from favorites: $e');
    }
  }
}