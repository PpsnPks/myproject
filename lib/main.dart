import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/cartbpage.dart';
import 'package:myproject/app/main/forgotpassword.dart';
import 'package:myproject/app/main/login.dart';
import 'package:myproject/app/main/register.dart';
import 'package:myproject/app/seller/cartspage.dart';
import 'package:myproject/app/buyer/category.dart';
import 'package:myproject/app/buyer/confirm.dart';
import 'package:myproject/app/buyer/homepage.dart';
import 'package:myproject/app/buyer/likepage.dart';
import 'package:myproject/app/buyer/selectproduct.dart';
import 'package:myproject/app/main/chatPage.dart';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/app/seller/confirm.dart';
import 'package:myproject/app/seller/notification.dart';
import 'package:myproject/app/seller/seller.dart';
import 'package:myproject/app/seller/addpage.dart';

import 'app/buyer/profilepage.dart';

void main() {
  //runApp(const MyApp());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "KMITL APP",
    home: const LoginPage(),
    routes: {
      '/home': (context) => const HomePage(),
      '/like': (context) => const LikePage(),
      '/cart-buyer': (context) => const CartBPage(),
      '/cart-seller': (context) => const CartSPage(),
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
      '/noti': (context) => const NotiPage(),
      '/chat': (context) => const Chatpage(),
      '/profile': (context) => const ProfilePage(),
      '/confirm-seller': (context) => const ConfirmSeller(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/forgotpassword': (context) => const ForgotPasswordPage(),
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
