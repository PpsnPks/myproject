import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/cartbpage.dart';
import 'package:myproject/app/seller/cartspage.dart';
import 'package:myproject/app/buyer/category.dart';
import 'package:myproject/app/buyer/confirm.dart';
import 'package:myproject/app/buyer/homepage.dart';
import 'package:myproject/app/buyer/likepage.dart';
import 'package:myproject/app/buyer/selectproduct.dart';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/app/seller/seller.dart';
import 'package:myproject/app/seller/addpage.dart';

import 'app/buyer/profilepage.dart';

void main() {
  //runApp(const MyApp());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "KMITL APP",
    home: const RolePage(),
    routes: {
      '/home': (context) => const HomePage(),
      '/like': (context) => const LikePage(),
      '/cart-buyer': (context) => const CartBPage(),
      '/cart-seller': (context) => const CartSPage(),
      '/profile': (context) => const ProfilePage(),
      '/selectproduct': (context) => const SelectProductPage(),
      '/confirm': (context) => const Confirm(),
      '/category': (context) => const CategoryPage(),
      '/role': (context) => const RolePage(),
      '/seller': (context) => const SellerPage(),
      '/addproduct': (context) => const AddProductPage(),
    },
  ));
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

