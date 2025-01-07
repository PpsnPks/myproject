import 'package:flutter/material.dart';

BottomAppBar sellerFooter(BuildContext context, String selected) {
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Home Button
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: selected == 'post'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/post');
                },
              ),
              Text(
                'หน้าหลัก',
                style: TextStyle(
                  color: selected == 'post'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.all_inbox_rounded ,
                  color: selected == 'seller'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/seller');
                },
              ),
              Text(
                'คลัง',
                style: TextStyle(
                  color: selected == 'seller'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
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
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: selected == 'cart-seller'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart-seller');
                },
              ),
              Text(
                'รายการ',
                style: TextStyle(
                  color: selected == 'cart-seller'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Chat Button
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.sms_outlined,
                  color: selected == 'chat'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
              ),
              Text(
                'แชท',
                style: TextStyle(
                  color: selected == 'chat'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Profile Button
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: selected == 'profile'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              Text(
                'โปรไฟล์',
                style: TextStyle(
                  color: selected == 'profile'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
