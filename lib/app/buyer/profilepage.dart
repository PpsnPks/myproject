import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/homepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isBuyerSelected = false;
  bool isSellerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ฉัน"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ภูมิ ไพรศรี',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '640***@kmitl.ac.th',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '081-375-5536',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'ดูโปรไฟล์',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF26522),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Add buttons for Buyer and Seller
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Buyer Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = true;
                        isSellerSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBuyerSelected ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA), // Background color
                      foregroundColor: isBuyerSelected ? Colors.white : const Color(0xFFFA5A2A), // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'คนซื้อ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between buttons
                // Seller Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = false;
                        isSellerSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSellerSelected ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA), // Background color
                      foregroundColor: isSellerSelected ? Colors.white : const Color(0xFFFA5A2A), // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'คนขาย',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('รายการสั่งสินค้า'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('ตั้งค่าความเป็นส่วนตัว'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('ช่วยเหลือ'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'ออกจากระบบ',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFF26522),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buyerFooter(context, 'profile'),
    );
  }
}
