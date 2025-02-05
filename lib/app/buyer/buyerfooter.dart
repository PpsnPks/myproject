import 'package:flutter/material.dart';

BottomNavigationBar buyerFooter(BuildContext context, String selected) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, // ป้องกันขยับเมื่อเลือก
    currentIndex: _getSelectedIndex(selected), // กำหนด index ตามหน้าที่เลือก
    selectedItemColor: const Color(0xFFFA5A2A), // กำหนดสีของ label และ icon เมื่อ selected
    unselectedItemColor: const Color(0xFFA5A9B6),
    onTap: (index) {
      _onItemTapped(index, context);
    },
    items: [
      _buildNavItem(Icons.home_outlined, 'หน้าหลัก', 'home', selected),
      _buildNavItem(Icons.favorite_border, 'ชื่นชอบ', 'like', selected),
      _buildNavItem(Icons.shopping_cart_outlined, 'รายการ', 'cart-buyer', selected),
      _buildNavItem(Icons.sms_outlined, 'แชท', 'chat', selected),
      _buildNavItem(Icons.person_outline_rounded, 'โปรไฟล์', 'profile', selected),
    ],
  );
}

/// แปลงชื่อเป็น index
int _getSelectedIndex(String selected) {
  switch (selected) {
    case 'home':
      return 0;
    case 'like':
      return 1;
    case 'cart-buyer':
      return 2;
    case 'chat':
      return 3;
    case 'profile':
      return 4;
    default:
      return 0;
  }
}

/// Handle การเปลี่ยนหน้า
void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/home');
      break;
    case 1:
      Navigator.pushNamed(context, '/like');
      break;
    case 2:
      Navigator.pushNamed(context, '/cart-buyer');
      break;
    case 3:
      Navigator.pushNamed(context, '/chat');
      break;
    case 4:
      Navigator.pushNamed(context, '/profile');
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
