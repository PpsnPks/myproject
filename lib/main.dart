import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/cartbpage.dart';
import 'package:myproject/app/main/forgotpassword.dart';
import 'package:myproject/app/main/formPage.dart';
import 'package:myproject/app/main/login.dart';
import 'package:myproject/app/main/message.dart';
import 'package:myproject/app/main/register.dart';
import 'package:myproject/app/main/otp.dart';
import 'package:myproject/app/seller/addpostpage.dart';
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
import 'package:myproject/app/seller/postpage.dart';
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
      '/post': (context) => const PostPage(),
      '/selectproduct': (context) => const SelectProductPage(),
      '/confirm': (context) => const Confirm(),
      '/category': (context) => const CategoryPage('หมวดหมู่'),
      '/role': (context) => const RolePage(),
      '/seller': (context) => const SellerPage(),
      '/addproduct': (context) => const AddProductPage(),
      '/addpost': (context) => const AddPostPage(),
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
      '/message': (context) => const Messagepage(),
      '/profile': (context) => const ProfilePage(),
      '/confirm-seller': (context) => const ConfirmSeller(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/forgotpassword': (context) => const ForgotPasswordPage(),
      '/otp': (context) => const OtpPage(),
      '/infoform': (context) => const PersonalInfoForm()
    },
  ));
}
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: "KMITL APP",
//     home: LoginPage(),
//     onGenerateRoute: (settings) {
//         // ตรวจสอบเงื่อนไขของ Guards ที่จะต้องมีการตรวจสอบการล็อกอิน
//       if (settings.name == '/home' || settings.name == '/profile' || settings.name == '/seller') {
//         // ตัวอย่างการตรวจสอบว่าผู้ใช้ล็อกอินหรือไม่
//         bool isLoggedIn = false; // เปลี่ยนให้เป็นการตรวจสอบจริง
//         if (isLoggedIn) {
//           return MaterialPageRoute(builder: (context) => const HomePage());
//         } else {
//           // ถ้าไม่ได้ล็อกอินให้ไปที่หน้า Login
//           return MaterialPageRoute(builder: (context) => LoginPage());
//         }
//       }

//       // ถ้าไม่ต้องการการรักษาความปลอดภัย (NoGuards)
//       if (settings.name == '/login' ||
//           settings.name == '/register' ||
//           settings.name == '/forgotpassword' ||
//           settings.name == '/otp') {
//         return MaterialPageRoute(builder: (context) {
//           if (settings.name == '/login') return LoginPage();
//           if (settings.name == '/register') return RegisterPage();
//           if (settings.name == '/forgotpassword') return ForgotPasswordPage();
//           return OtpPage();
//         });
//       }

//       return null; // กรณีที่ไม่มีการกำหนดเส้นทาง
//     },
//     routes: {
//       '/like': (context) => const LikePage(),
//       '/cart-buyer': (context) => const CartBPage(),
//       '/cart-seller': (context) => const CartSPage(),
//       '/post': (context) => const PostPage(),
//       '/selectproduct': (context) => const SelectProductPage(),
//       '/confirm': (context) => const Confirm(),
//       '/category': (context) => const CategoryPage('หมวดหมู่'),
//       '/role': (context) => const RolePage(),
//       '/addproduct': (context) => const AddProductPage(),
//       '/addpost': (context) => const AddPostPage(),
//       '/general': (context) => const CategoryPage('ของใช้ทั่วไป'),
//       '/electronics': (context) => const CategoryPage('อิเล็กทรอนิกส์'),
//       '/appliances': (context) => const CategoryPage('เครื่องใช้ไฟฟ้า'),
//       '/books': (context) => const CategoryPage('หนังสือ'),
//       '/education': (context) => const CategoryPage('การศึกษา'),
//       '/furniture': (context) => const CategoryPage('เฟอร์นิเจอร์'),
//       '/fashion': (context) => const CategoryPage('แฟชั่น'),
//       '/others': (context) => const CategoryPage('อื่นๆ'),
//       '/noti': (context) => const NotiPage(),
//       '/chat': (context) => const Chatpage(),
//       '/message': (context) => const Messagepage(),
//       '/confirm-seller': (context) => const ConfirmSeller(),
//     },
//   ));
// }

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
