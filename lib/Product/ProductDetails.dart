import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Models/ProductModel.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel selectedProduct;

  const ProductDetails({
    Key? key,
    required this.selectedProduct,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  CollectionReference productRef = FirebaseFirestore.instance.collection('Products');

  Future<List<ProductModel>> readProduct() async {
    try {
      // Query Firestore for all products
      QuerySnapshot response = await productRef.get();

      // Convert QuerySnapshot to a list of ProductModel
      List<ProductModel> products =
      response.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

      // Filter products based on the selected subcategory
      List<ProductModel> filteredProducts = products
          .where((element) => element.productName == widget.selectedProduct.productName)
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
        title: Text('Details'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: readProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final productDocs = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productDocs.map((product) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            // autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items: product.images!.map((image[0]) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: Image.network(
                                    image,
                                    // fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
            
                          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
                              child: Text('Add to Cart',style: TextStyle(color: Colors.black),)
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
            
                          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              child: Text('Buy Now',style: TextStyle(color: Colors.black),)
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.productName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.productPrice,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.newPrice,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.color,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.discount,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.title1,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.product1,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.title2,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.product2,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.title3,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.product3,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.title4,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.product4,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product.productDescription,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// class ItemDetails extends StatelessWidget {
//   final ProductModel product;
//
//   const ItemDetails({Key? key, required this.product}): super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Expanded(
//         child: Container(
//           width: 150,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 child: ListView.builder(
//                   itemCount: product.images!.length,
//                   itemBuilder: (context, index) {
//                     return SizedBox(
//                       height: 150,
//                       child: Image.network(
//                         product.images![index],
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.productName,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.productPrice,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.newPrice,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.color,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.discount,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.title1,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.product1,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.title2,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.product2,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.title3,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.product3,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.title4,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.product4,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 product.productDescription,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//             // return Scaffold(
//             //   appBar: AppBar(
//             //     title: Text('Item Details'),
//             //   ),
//             //   body: Padding(
//             //     padding: const EdgeInsets.all(8.0),
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.center,
//             //       children: [
//             //         Container(
//             //           height: 150,
//             //           width: double.infinity,
//             //           child: ListView.builder(
//             //             itemCount: product.images!.length,
//             //             itemBuilder: (context, index) {
//             //               return SizedBox(
//             //                 height: 150,
//             //                 child: Image.network(
//             //                   product.images![index],
//             //                   fit: BoxFit.cover,
//             //                 ),
//             //               );
//             //             },
//             //           ),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.productName,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.productPrice,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.newPrice,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.color,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.discount,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.title1,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.product1,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.title2,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.product2,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.title3,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.product3,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.title4,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.product4,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //         SizedBox(height: 20),
//             //         Text(
//             //           product.productDescription,
//             //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //         ),
//             //
//             //       ],
//             //     ),
//             //   ),
//             // );
//           }
// }


