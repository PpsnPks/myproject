import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart';
import 'package:myproject/app/buyer/allpostpage.dart';
import 'package:myproject/app/buyer/cartbpage.dart';
import 'package:myproject/app/buyer/searchpage.dart';
import 'package:myproject/app/main/categoryform.dart';
import 'package:myproject/app/main/forgotpassword.dart';
import 'package:myproject/app/main/formPage.dart';
import 'package:myproject/app/main/fullimage.dart';
import 'package:myproject/app/main/info1.dart';
import 'package:myproject/app/main/info2.dart';
import 'package:myproject/app/main/info3.dart';
import 'package:myproject/app/main/infoprofile.dart';
import 'package:myproject/app/main/login.dart';
import 'package:myproject/app/main/message.dart';
import 'package:myproject/app/main/newpassword.dart';
import 'package:myproject/app/main/postdetailpage.dart';
import 'package:myproject/app/main/productdetailpage.dart';
import 'package:myproject/app/main/register.dart';
import 'package:myproject/app/main/otp.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/app/main/tagform.dart';
import 'package:myproject/app/main/waitinglogin.dart';
import 'package:myproject/app/seller/addpostpage.dart';
import 'package:myproject/app/seller/cartspage.dart';
import 'package:myproject/app/buyer/category.dart';
// import 'package:myproject/app/buyer/confirm.dart';
import 'package:myproject/app/buyer/homepage.dart';
import 'package:myproject/app/buyer/likepage.dart';
import 'package:myproject/app/main/chatPage.dart';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/app/seller/confirm.dart';
// import 'package:myproject/app/seller/confirm.dart';
import 'package:myproject/app/seller/editpage.dart';
import 'package:myproject/app/seller/notification.dart';
import 'package:myproject/app/seller/postpage.dart';
import 'package:myproject/app/seller/seller.dart';
import 'package:myproject/app/seller/addpage.dart';
import 'package:myproject/app/main/viewprofile.dart';
import 'app/buyer/profilepage.dart';

Future<void> loadUserData() async {
  await Securestorage().printAllSecureData();
}

void main() async {
  //runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  // โหลดข้อมูลจาก Secure Storage
  String? email = await Securestorage().readSecureData('email');
  String? password = await Securestorage().readSecureData('password');
  String role = await Securestorage().readSecureData('role') ?? 'buy';
  String firstpage = '';
  if (email != null && password != null) {
    print('start');
    final result = await LoginService().login(email, password);
    print('stop');
    if (result['success']) {
      if (result['first']) {
        print("First Time");
        firstpage = '/login'; //firstpage = '/infoform';
      } else {
        print("NOt First Time");
        firstpage = '/role';
      }
    }
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "KMITL Exchange",
    home: firstpage == '/infoform'
        ? const PersonalInfoForm(data: '')
        : firstpage == '/role'
            ? const RolePage()
            : const LoginPage(),
    onGenerateRoute: (settings) {
      if (settings.name!.startsWith('/editproduct/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: EditProductPage(
            productId: id,
          ),
        );
      } else if (settings.name!.startsWith('/productdetail/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: ProductDetailPage(
            productId: id,
          ),
        );
      } else if (settings.name!.startsWith('/postdetail/')) {
        final id = settings.name!.split('/').last; // ดึง id จาก URL
        // final product = settings.arguments;
        return SlidePageRoute(
          page: PostDetailPage(
            postId: id,
          ),
        );
      } else if (settings.name!.startsWith('/message/')) {
        final receiverId = settings.name!.split('/').last; // ดึง id จาก URL
        final args = settings.arguments as Map<String, String>;
        return SlidePageRoute(
          page: Messagepage(receiverId: receiverId, name: args['name'] ?? 'Chat'),
        );
      } else if (settings.name!.startsWith('/fullimage')) {
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (context) => FullScreenImageView(image: args['image'] ?? 'Chat'),
        );
      } else if (settings.name!.startsWith('/confirm')) {
        final args = settings.arguments as Map<String, String>;
        return SlidePageRoute(
          page: ConfirmSellerPage(data: args['data'] ?? ''),
        );
      } else if (settings.name!.startsWith('/newpassword')) {
        final args = settings.arguments as Map<String, String>;
        return SlidePageRoute(
          page: NewPasswordPage(data: args['data'] ?? ''),
        );
      }
      return null;
    },
    initialRoute: '/',
    routes: {
      '/home': (context) => const HomePage(),
      '/like': (context) => const LikePage(),
      '/cart-buyer': (context) => const CartBPage(),
      '/cart-seller/1': (context) => const CartSPage(tab: 0),
      '/cart-seller/2': (context) => const CartSPage(tab: 1),
      '/post': (context) => const PostPage(),
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
      '/chat': (context) => Chatpage(role: role!),
      '/profile': (context) => const ProfilePage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/forgotpassword': (context) => const ForgotPasswordPage(),
      '/otp': (context) => const OtpPage(),
      '/infoform': (context) => const PersonalInfoForm(data: ''),
      '/infoprofile': (context) => const InfoProfile(),
      '/viewprofile': (context) => const ViewProfilePage(),
      '/allpost': (context) => const AllPostPage(),
      '/categoryform': (context) => const CategoryFormPage(
            userData: {},
          ),
      '/tagform': (context) => const TagFormPage(userData: {}, selectedCategoryIds: []),
      '/info1': (context) => const Info1Page(),
      '/info2': (context) => const Info2Page(),
      '/info3': (context) => const Info3Page(),
      '/search': (context) => const SearchPage(),
      '/waitinglogin': (context) => WaitingLogin(email: email!, password: password!),
      // '/confirm': (context) => const ConfirmSellerPage(),
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
