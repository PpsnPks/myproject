import 'package:flutter/material.dart';
import 'package:myproject/app/main/chatPage.dart';

Widget buyerFooter(BuildContext context, String selected) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // สีเงา
          blurRadius: 10, // ความเบลอของเงา
          spreadRadius: 2, // การกระจายของเงา
          offset: const Offset(0, -1), // ตำแหน่งเงา (ให้เงาขึ้นด้านบน)
        ),
      ],
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // ป้องกันขยับเมื่อเลือก
      currentIndex: _getSelectedIndex(selected), // กำหนด index ตามหน้าที่เลือก
      selectedItemColor: const Color(0xFFFA5A2A), // กำหนดสีของ label และ icon เมื่อ selected
      unselectedItemColor: const Color(0xFFA5A9B6),
      backgroundColor: Colors.white,
      onTap: (index) {
        _onItemTapped(index, context);
      },
      items: [
        _buildNavItem(Icons.home_outlined, 'หน้าหลัก', 'home', selected),
        _buildNavItem(Icons.web_asset_rounded, 'โพสต์', 'post', selected),
        _buildNavItem(Icons.favorite_border, 'ถูกใจ', 'like', selected),
        _buildNavItem(Icons.shopping_cart_outlined, 'รายการ', 'cart-buyer', selected),
        _buildNavItem(Icons.sms_outlined, 'แชท', 'chat', selected),
        _buildNavItem(Icons.person_outline_rounded, 'โปรไฟล์', 'profile', selected),
      ],
    ),
  );
}

/// แปลงชื่อเป็น index
int _getSelectedIndex(String selected) {
  switch (selected) {
    case 'home':
      return 0;
    case 'post':
      return 1;
    case 'like':
      return 2;
    case 'cart-buyer':
      return 3;
    case 'chat':
      return 4;
    case 'profile':
      return 5;
    default:
      return 0;
  }
}

/// Handle การเปลี่ยนหน้า
void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/home');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/allpost');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/like');
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/cart-buyer');
      break;
    case 4:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Chatpage(role: 'buy'),
        ),
      );
      break;
    case 5:
      Navigator.pushReplacementNamed(context, '/profile');
      break;
  }
}

/// ฟังก์ชันช่วยสร้าง Item
BottomNavigationBarItem _buildNavItem(IconData icon, String label, String page, String selected) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}

// BottomAppBar buyerFooter(BuildContext context, String selected) {
//   return BottomAppBar(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         // Home Button
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.home_outlined,
//                   color: selected == 'home'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/home');
//                 },
//               ),
//               Text(
//                 'หน้าหลัก',
//                 style: TextStyle(
//                   color: selected == 'home'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   fontSize: 9,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Favorite Button
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.favorite_border,
//                   color: selected == 'like'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/like');
//                 },
//               ),
//               Text(
//                 'ชื่นชอบ',
//                 style: TextStyle(
//                   color: selected == 'like'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   fontSize: 9,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Cart Button
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.shopping_cart_outlined,
//                   color: selected == 'cart-buyer'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/cart-buyer');
//                 },
//               ),
//               Text(
//                 'รายการ',
//                 style: TextStyle(
//                   color: selected == 'cart-buyer'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   fontSize: 9,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Chat Button
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.sms_outlined,
//                   color: selected == 'chat'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/chat');
//                 },
//               ),
//               Text(
//                 'แชท',
//                 style: TextStyle(
//                   color: selected == 'chat'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   fontSize: 9,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Profile Button
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.person_outline_rounded,
//                   color: selected == 'profile'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/profile');
//                 },
//               ),
//               Text(
//                 'โปรไฟล์',
//                 style: TextStyle(
//                   color: selected == 'profile'
//                       ? const Color(0xFFFA5A2A)
//                       : const Color(0xFFA5A9B6),
//                   fontSize: 10,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
