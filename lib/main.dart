import 'package:flutter/material.dart';
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
      '/profile': (context) => const ProfilePage(),
      '/selectproduct': (context) => const SelectProductPage(),
      '/confirm': (context) => const Confirm(),
      '/category': (context) => const CategoryPage('หมวดหมู่'),
      '/role': (context) => const RolePage(),
      '/seller': (context) => const SellerPage(),
      '/addproduct': (context) => const AddProductPage(),

      '/general': (context) => const CategoryPage('ของใช้ทั่วไป'),
      '/electronics': (context) => const CategoryPage('อิเล็กทรอนิกส์'),
      '/appliances': (context) => const CategoryPage('เครื่องใช้ไฟฟ้า'),
      '/books': (context) => const CategoryPage('หนังสือ'),
      '/education': (context) => const CategoryPage('การศึกษา'),
      '/furniture': (context) => const CategoryPage('เฟอร์นิเจอร์'),
      '/fashion': (context) => const CategoryPage('แฟชั่น'),
      '/others': (context) => const CategoryPage('อื่นๆ'),

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

