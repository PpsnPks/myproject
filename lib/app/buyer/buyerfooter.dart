import 'package:flutter/material.dart';

BottomAppBar buyerFooter(BuildContext context, String selected) {
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
                  color: selected == 'home'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              Text(
                'หน้าหลัก',
                style: TextStyle(
                  color: selected == 'home'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Favorite Button
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: selected == 'like'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/like');
                },
              ),
              Text(
                'ชื่นชอบ',
                style: TextStyle(
                  color: selected == 'like'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Cart Button
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: selected == 'cart-buyer'
                      ? const Color(0xFFFA5A2A)
                      : const Color(0xFFA5A9B6),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart-buyer');
                },
              ),
              Text(
                'รายการ',
                style: TextStyle(
                  color: selected == 'cart-buyer'
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
