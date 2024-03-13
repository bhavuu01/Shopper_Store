import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/BottomNavigation/BottomNavigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Models/FavModel.dart';
import '../Models/ProductModel.dart';


class ProductDetails extends StatefulWidget {
  final ProductModel product;


  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool favorite = false;
  int activeIndex = 0;
  String? selectedColl;
  String selectedqty = '1';
  var quantity = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    // 'Qty: 8',
    // 'Qty: 9',
    // 'Qty: 10',
  ];
  bool timer = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        timer = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !timer
        ? Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        ))
        : Scaffold(
        appBar: AppBar(
          title: Text("${widget.product.brand.toString()} Products"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Visit the ${widget.product.brand} Store",
                    style: const TextStyle(color: Colors.cyan),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 10),
                child: Text(
                  widget.product.productName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[200],
                    ),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 350,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index),
                      ),
                      itemCount: widget.product.images!.length,
                      itemBuilder: (context, index, realIndex) {
                        final allItems =
                        widget.product.images![index];
                        return buildImage(allItems, index);
                      },
                    ),
                  ),
                  IconButton(
                    color: favorite ? Colors.pinkAccent : Colors.grey,
                    onPressed: () async {
                      setState(() {
                        favorite = !favorite;
                      });
                      // Add the product to favorites when the button is pressed
                      if (favorite) {
                        await _addToFavorites(widget.product);
                      }
                    },
                    icon: Icon(Icons.favorite,size: 30,),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(child: buildIndicator()),
                  ),
                ],
              ),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 1, left: 8),
                          child: Text(
                            "-${widget.product.discount}",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.red[900]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 1),
                          child: Text(
                            "₹${widget.product.newPrice.toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 1, left: 8),
                      child: Text(
                        "M.R.P.: ${widget.product.productPrice.toString()}",
                        style: const TextStyle(
                            fontSize: 14,
                            decoration:
                            TextDecoration.lineThrough,color: Colors.red,
                        decorationColor: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 8),
                      child: Text(
                        "In stock.",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          buttonDecoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10.0),
                              color: Colors.grey.shade400
                                  .withOpacity(0.2)),
                          hint: Text(
                            quantity.first,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            ),
                          ),
                          items: quantity
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style:
                                  const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                          value: selectedqty.toString(),
                          onChanged: (value) {
                            setState(() {
                              selectedqty = (value.toString());
                            });
                            print(
                                "quantity..$selectedqty");
                          },
                          buttonHeight: 40,
                          buttonWidth: 75,
                          itemHeight: 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20),
                      child: SizedBox(
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(
                                    Colors.yellow[700]),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          25.0),
                                    ))),
                            onPressed: () async {
                              // Call the method to add the product to the cart
                              await _addToCart(widget.product);
                              // Show a snackbar to indicate success
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Successfully added to Cart')),
                              );
                              // Optionally, navigate to another screen or update the UI
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationHome(),
                                  ),
                                      (route) => false);
                            },
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                  color: Colors.black),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20),
                      child: SizedBox(
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(
                                  Colors.orange[600],
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          25.0),
                                    ))),
                            onPressed: () async {
                              await _addToCart(widget.product);
                              // Navigate to buy now screen or perform other actions
                            },
                            child: const Text(
                              "Buy Now ",
                              style: TextStyle(
                                  color: Colors.black),
                            )),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 8),
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(widget.product.title1,
                                    style: const TextStyle(
                                        fontSize:
                                        16)),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.all(
                                    8.0),
                                child: Text("Model"),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.all(
                                    8.0),
                                child: Text("Colour"),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(widget.product.title2),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(widget.product.title3),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(widget.product.title4),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.all(
                                    8.0),
                                child: Text(
                                    "Description"),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.product1.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.productName.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.color.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.product2.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.product3.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.product4.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: Text(widget.product.productDescription.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding:
                EdgeInsets.only(top: 10, left: 8),
                child: Text(
                  "About this item",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  widget.product.productDescription
                      .toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildImage(String allItems, int index) =>
      Image.network(allItems, fit: BoxFit.contain);

  Widget buildIndicator() =>
      AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.product.images!.length,
      );


  Future<void> _addToCart(ProductModel product) async {
    try {
      await FirebaseFirestore.instance.collection('ShoppingCart').add({
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'images': product.images,
        'productName': product.productName,
        'productPrice': product.productPrice,
        'productNewPrice': product.newPrice,
        'discount': product.discount,
        'quantity': selectedqty,
        'totalprice': product.totalprice,
      });
      print('Product added to cart successfully!');
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> _addToFavorites(ProductModel product) async {
    try {
      await FirebaseFirestore.instance.collection('Favorites').add({
        'productName': product.productName,
        'images': product.images,
        // 'productPrice': product.productPrice,
        'productNewPrice': product.newPrice,
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'quantity': selectedqty,
        // 'totalprice': product.totalprice,
        // Add any other fields you want to store in favorites
      });
      print('Product added to favorites successfully!');
    } catch (e) {
      print('Error adding product to favorites: $e');
    }
  }


}