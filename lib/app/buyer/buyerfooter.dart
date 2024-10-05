import 'package:flutter/material.dart';


BottomAppBar buyerFooter(BuildContext context, String selected){
  return  BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home_rounded,  // ใช้ไอคอน home outline
                    color: selected == 'home'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),  // กำหนดสีเป็น #FA5A2A
                    size: 38,  // ขนาดไอคอน
                  ),
                  onPressed: () {
                    // Handle home button press
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border,  // ใช้ไอคอน home outline
                    //color: Color(0xFFFA5A2A),  // กำหนดสีเป็น #FA5A2A
                    color: selected == 'like'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),
                    size: 34,  // ขนาดไอคอน
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/like');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_outlined,size: 30),
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person_outline_rounded,
                  color: selected == 'profile'? const 
                  Color(0xFFFA5A2A): const Color(0xFFA5A9B6),
                    size: 34,  // ขนาดไอคอน
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          );
}