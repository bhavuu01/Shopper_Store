  import 'package:flutter/material.dart';

  import '../Cart/CartScreen.dart';

  class CartPage extends StatefulWidget {
    const CartPage({super.key});

    @override
    State<CartPage> createState() => _CartPageState();
  }

  class _CartPageState extends State<CartPage> {
    @override
    Widget build(BuildContext context) {
      return AddToCartScreen();
    }
  }
