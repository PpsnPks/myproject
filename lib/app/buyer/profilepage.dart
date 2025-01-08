import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isBuyerSelected = true; // Default to Buyer tab
  bool isGridSelected = true; // Default to Grid view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ฉัน"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
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
              ],
            ),
          ),
          // Tab Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Buyer Tab
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBuyerSelected ? const Color(0xFFE35205) : const Color(0xFFFCEEEA),
                      foregroundColor: isBuyerSelected ? Colors.white : const Color(0xFFE35205),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'คนซื้อ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Seller Tab
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBuyerSelected ? const Color(0xFFFCEEEA) : const Color(0xFFE35205),
                      foregroundColor: isBuyerSelected ? const Color(0xFFE35205) : Colors.white,
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
          // Grid and History Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Grid View Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      isGridSelected = true;
                    });
                  },
                  icon: Icon(
                    Icons.grid_view,
                    color: isGridSelected ? const Color(0xFFE35205) : Colors.grey,
                  ),
                ),
                // History View Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      isGridSelected = false;
                    });
                  },
                  icon: Icon(
                    Icons.history,
                    color: isGridSelected ? Colors.grey : const Color(0xFFE35205),
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: isBuyerSelected
                ? (isGridSelected ? buildBuyerGridView() : buildBuyerHistoryView())
                : (isGridSelected ? buildSellerGridView() : buildSellerHistoryView()),
          ),
        ],
      ),
      // Footer changes based on role
      bottomNavigationBar: isBuyerSelected
          ? buyerFooter(context, 'profile')
          : sellerFooter(context, 'profile'),
    );
  }

  // Buyer Grid View
  Widget buildBuyerGridView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: 3, // Replace with your dynamic data count
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/sample_item.png', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item ${index + 1}', // Replace with your dynamic data
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Buyer History View
  Widget buildBuyerHistoryView() {
    return Center(
      child: const Text(
        'ยังไม่มีประวัติการซื้อ',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // Seller Grid View
  Widget buildSellerGridView() {
    return Center(
      child: const Text(
        'ยังไม่มีรายการที่คุณขาย',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // Seller History View
  Widget buildSellerHistoryView() {
    return Center(
      child: const Text(
        'ยังไม่มีประวัติการขาย',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
