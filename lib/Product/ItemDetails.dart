// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../Models/ProductModel.dart';
//
// class ItemDetails extends StatefulWidget {
//   const ItemDetails({super.key});
//
//   @override
//   State<ItemDetails> createState() => _ItemDetailsState();
// }
//
// class _ItemDetailsState extends State<ItemDetails> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<String>> _fetchImages() async {
//     final QuerySnapshot querySnapshot = await _firestore.collection('Products').get();
//     List<String> imageURLs = [];
//     querySnapshot.docs.forEach((doc) {List<dynamic> images = doc['images'];
//       imageURLs.addAll(images.map((image) => image as String));
//     });
//     return imageURLs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Apple Products',style: TextStyle(fontWeight: FontWeight.bold),),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextButton(onPressed: (){
//             },
//                 child: Text('Visit Apple Official Store'),
//             ),
//             SizedBox(height: 10,),
//
//             Text('Iphone 15',style: TextStyle(fontWeight: FontWeight.bold),),
//
//             SizedBox(height: 30,),
//             FutureBuilder<List<String>>(
//               future: _fetchImages(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 final carouselImages = snapshot.data;
//                 if (carouselImages == null || carouselImages.isEmpty) {
//                   return const SizedBox();
//                 }
//                 return CarouselSlider.builder(
//                   itemCount: carouselImages.length,
//                   itemBuilder: (context, index, realIndex) {
//                     final imageUrl = carouselImages[index];
//                     return Card(
//                       child: Image.network(
//                         imageUrl,
//                         // fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     );
//                   },
//                   options: CarouselOptions(
//                     // autoPlay: true,
//                     aspectRatio: 16 / 9,
//                     viewportFraction: 0.9,
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Container(
//                 width: double.infinity,
//                 child: ElevatedButton(onPressed: (){
//
//                 }, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
//                     child: Text('Add to Cart',style: TextStyle(color: Colors.black),)
//                 ),
//               ),
//             ),
//             SizedBox(height: 10,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30,),
//               child: Container(
//                 width: double.infinity,
//                 child: ElevatedButton(onPressed: (){
//
//                 }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                     child: Text('Buy Now',style: TextStyle(color: Colors.black),)
//                 ),
//               ),
//             ),
//             Text('Details')
//           ],
//         ),
//       ),
//     );
//   }
// }
// Widget buildBannerSlider(List<ProductModel> products) {
//   return CarouselSlider.builder(
//     itemCount: products.length,
//     itemBuilder: (context, index, realIndex) {
//       final product = products[index];
//       return SizedBox(
//         height: 200,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Image.network(
//             product.images![0],
//             height: 200,
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     },
//     options: CarouselOptions(
//       autoPlay: false,
//       aspectRatio: 2.0,
//       enlargeCenterPage: true,
//     ),
//   );
// }