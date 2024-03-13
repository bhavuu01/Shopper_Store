import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Brand/BrandDisplay.dart';
import 'package:shopperstoreuser/Models/CategoryModel.dart';
import '../Models/BrandModel.dart';
import '../Product/ProductScreen.dart';

class BrandScreen extends StatefulWidget {
  final CategoryModel selectedcategory;

  const BrandScreen({required this.selectedcategory});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {

  CollectionReference brandRef = FirebaseFirestore.instance.collection('Brands');


  Future<List<BrandModel>> readBrand() async
  {
    QuerySnapshot response = await brandRef.get();
    return response.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brands'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<BrandModel>>(
          future: readBrand().then((value) => value.where((element) => element.category == widget.selectedcategory.category).toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }

            final brandDocs = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: brandDocs.map((brand) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BrandCard(brand: brand),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20), // Add spacing between brand cards and products
                ProductHome(selectedCategory: widget.selectedcategory.category)
              ],
            );
          },
        ),
      ),
    );
  }
}


class BrandCard extends StatelessWidget {

  final BrandModel brand;

  const BrandCard({Key? key, required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 150,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductScreen(seletedBrand: brand,products: [],)
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
                      brand.image,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Text(
                  brand.brand,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
