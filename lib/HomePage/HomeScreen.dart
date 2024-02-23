import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/BottomNavigation/BottomNavigation.dart';
import 'package:shopperstoreuser/Brand/BrandScreen.dart';
import 'package:shopperstoreuser/HomePage/ProductHome.dart';


import '../Models/CategoryModel.dart';
import '../Sales/SalesModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _fetchImages() async {
    final QuerySnapshot querySnapshot = await _firestore.collection('Sales').get();
    return querySnapshot.docs.map((doc) => doc['image'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopperStore',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.cyan],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CategoryList(),
                SizedBox(height: 20),
                FutureBuilder<List<String>>(
                  future: _fetchImages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final carouselImages = snapshot.data;
                    if (carouselImages == null || carouselImages.isEmpty) {
                      return const SizedBox();
                    }
                    return CarouselSlider.builder(
                      itemCount: carouselImages.length,
                      itemBuilder: (context, index, realIndex) {
                        final imageUrl = carouselImages[index];
                        return Image.network(
                          imageUrl,
                          // fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.9,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                ProductHome(),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

Widget buildBannerSlider(List<SalesModel> sales) {
  return CarouselSlider.builder(
    itemCount: sales.length,
    itemBuilder: (context, index, realIndex) {
      final sale = sales[index];
      return SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            sale.image,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    },
    options: CarouselOptions(
      autoPlay: true,
      aspectRatio: 2.0,
      enlargeCenterPage: true,
    ),
  );
}


class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final categoryDocs = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryDocs.map((doc) {
              final category = CategoryModel.fromSnapshot(doc);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CategoryCard(category: category),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}


class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrandScreen(selectedcategory: category),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ClipOval(
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                category.category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}