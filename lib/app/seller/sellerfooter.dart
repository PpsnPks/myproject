import 'package:flutter/material.dart';

BottomNavigationBar sellerFooter(BuildContext context, String selected) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, // ป้องกันขยับเมื่อเลือก
    currentIndex: _getSelectedIndex(selected), // กำหนด index ตามหน้าที่เลือก
    selectedItemColor: const Color(0xFFFA5A2A), // กำหนดสีของ label และ icon เมื่อ selected
    unselectedItemColor: const Color(0xFFA5A9B6),
    onTap: (index) {
      _onItemTapped(index, context);
    },
    items: [
      _buildNavItem(Icons.home_outlined, 'หน้าหลัก', 'post', selected),
      _buildNavItem(Icons.all_inbox_rounded, 'คลัง', 'seller', selected),
      _buildNavItem(Icons.shopping_cart_outlined, 'รายการ', 'cart-seller', selected),
      _buildNavItem(Icons.sms_outlined, 'แชท', 'chat', selected),
      _buildNavItem(Icons.person_outline_rounded, 'โปรไฟล์', 'profile', selected),
    ],
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
      Navigator.pushNamed(context, '/post');
      break;
    case 1:
      Navigator.pushNamed(context, '/seller');
      break;
    case 2:
      Navigator.pushNamed(context, '/cart-seller');
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