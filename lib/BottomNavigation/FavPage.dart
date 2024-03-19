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
          selectedqty: doc['quantity'],
          // product1: doc['productTitleDetail1'],
          // product2: doc['productTitleDetail2'],
          // product3: doc['productTitleDetail3'],
          // product4: doc['productTitleDetail4'],
          // title1: doc['productTitle1'],
          // title2: doc['productTitle2'],
          // title3: doc['productTitle3'],
          // title4: doc['productTitle4'],
          // brand: doc['brand'],
          // category: doc['category'],
          // color: doc['productColor'],
          // discount: doc['discount'],
          // productDescription: doc['productDescription'],
          // productPrice: doc['productPrice'],
          // totalprice: doc['totalprice'],
          // itemdetails: doc['itemdetails'],
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
            return GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: product)));
              },
              child: Card(
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
                   trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {
                          _removeFromFavorites(product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          _addToCartAndRemoveFromFavorites(product);
                        },
                      ),
                    ],
                  ),
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
      await FirebaseFirestore.instance.collection('ShoppingCart').add({
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'images': product.images,
        'productName': product.productName,
        'productNewPrice': product.newPrice,
        'quantity': product.selectedqty,
      });

      await FirebaseFirestore.instance
          .collection('Favorites')
          .doc(product.id)
          .delete();

      fetchFavoriteProducts();
    } catch (e) {
      print('Error adding to cart and removing from favorites: $e');
    }
  }

  Future<void> _removeFromFavorites(FavModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection('Favorites')
          .doc(product.id)
          .delete();
      fetchFavoriteProducts();
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }
}