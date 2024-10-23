import 'package:flutter/material.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 247, 236), Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'คุณสนใจที่จะเป็น',
                style: TextStyle(
                  fontSize: 47,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // ทำให้ปุ่มโค้งมน
                        ),
                      ),
                      child: const Text('ลูกค้า'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/seller');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // ทำให้ปุ่มโค้งมน
                        ),
                      ),
                      child: const Text('คนขาย'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Icon(
                Icons.person_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String role,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // ทำให้มุมโค้งมน
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(20), // ทำให้มุมโค้งมน
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                role == 'ผู้ซื้อ' ? Icons.shopping_cart : Icons.sell,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
