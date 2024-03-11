import 'package:cloud_firestore/cloud_firestore.dart';

class FavModel {
  final String id;
  List<String>? images;
  final String productName;
  final String newPrice;
  // final String productPrice;
  String selectedqty;
  // String totalprice;

  FavModel({required this.id,
    required this.images,
    required this.productName,
    required this.newPrice,
    // required this.productPrice,
    required this.selectedqty,
    // required this.totalprice,
  });

  factory FavModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FavModel(
      id: snapshot.id,
      images: List<String>.from(data['images'] ?? []),
      productName: data['productName']?? '',
      newPrice: data['newPrice']?? '',
      // productPrice: data['productPrice']?? '',
      selectedqty: data['quantity']?? '',
      // totalprice: data['totalprice']?? '',
    );
  }
}
