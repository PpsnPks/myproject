import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/cartbpage.dart';
import 'package:myproject/app/main/forgotpassword.dart';
import 'package:myproject/app/main/formPage.dart';
import 'package:myproject/app/main/infoprofile.dart';
import 'package:myproject/app/main/login.dart';
import 'package:myproject/app/main/message.dart';
import 'package:myproject/app/main/postdetailpage.dart';
import 'package:myproject/app/main/productdetailpage.dart';
import 'package:myproject/app/main/register.dart';
import 'package:myproject/app/main/otp.dart';
import 'package:myproject/app/seller/addpostpage.dart';
import 'package:myproject/app/seller/cartspage.dart';
import 'package:myproject/app/buyer/category.dart';
import 'package:myproject/app/buyer/confirm.dart';
import 'package:myproject/app/buyer/homepage.dart';
import 'package:myproject/app/buyer/likepage.dart';
import 'package:myproject/app/main/chatPage.dart';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/app/seller/confirm.dart';
import 'package:myproject/app/seller/editpage.dart';
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
    onGenerateRoute: (settings) {
      if (settings.name!.startsWith('/editproduct/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: EditProductPage(
            productId: id,
          ),
        );
      }
      else if (settings.name!.startsWith('/productdetail/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: ProductDetailPage(
            productId: id,
          ),
        );
      }
      else if (settings.name!.startsWith('/postdetail/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: PostDetailPage(
            postId: id,
          ),
        );
      }
      return null;
      
    },
    initialRoute: '/',
    routes: {
      '/home': (context) => const HomePage(),
      '/like': (context) => const LikePage(),
      '/cart-buyer': (context) => const CartBPage(),
      '/cart-seller': (context) => const CartSPage(),
      '/post': (context) => const PostPage(),
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
      '/infoform': (context) => const PersonalInfoForm(),
      '/infoprofile': (context) => const InfoProfile(),
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

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
