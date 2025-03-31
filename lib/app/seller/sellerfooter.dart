import 'package:flutter/material.dart';
import 'package:myproject/app/main/chatPage.dart';

Widget sellerFooter(BuildContext context, String selected) {
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
        _buildNavItem(Icons.web_asset_rounded, 'โพสต์', 'post', selected),
        _buildNavItem(Icons.all_inbox_rounded, 'คลัง', 'seller', selected),
        _buildNavItem(Icons.shopping_cart_outlined, 'รายการ', 'cart-seller', selected),
        _buildNavItem(Icons.sms_outlined, 'แชท', 'chat', selected),
        _buildNavItem(Icons.person_outline_rounded, 'โปรไฟล์', 'profile', selected),
      ],
    ),
  );
}

/// แปลงชื่อเป็น index
int _getSelectedIndex(String selected) {
  switch (selected) {
    case 'post':
      return 0;
    case 'seller':
      return 1;
    case 'cart-seller':
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
      Navigator.pushReplacementNamed(context, '/post');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/seller');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/cart-seller/1');
      break;
    case 3:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Chatpage(role: 'sell'),
        ),
      );
      break;
    case 4:
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

// Favorite Button
        // Flexible(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       IconButton(
        //         icon: Icon(
        //           Icons.add_circle_outline_rounded,
        //           color: selected == 'addproduct'
        //               ? const Color(0xFFFA5A2A)
        //               : const Color(0xFFA5A9B6),
        //           size: 24,
        //         ),
        //         onPressed: () {
        //           Navigator.pushNamed(context, '/addproduct');
        //         },
        //       ),
        //       Text(
        //         'เพิ่ม',
        //         style: TextStyle(
        //           color: selected == 'addproduct'
        //               ? const Color(0xFFFA5A2A)
        //               : const Color(0xFFA5A9B6),
        //           fontSize: 9,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Cart Button