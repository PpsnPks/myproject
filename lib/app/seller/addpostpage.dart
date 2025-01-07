import 'package:flutter/material.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่มโพสต์"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle buttons for "ขาย", "แจก", "Pre Order"
              
              const SizedBox(height: 16),
              
              // Image upload section
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้', style: TextStyle(color: Colors.grey)),
              
              // Product form fields
              const SizedBox(height: 16),
              
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'รายละเอียดสินค้า',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อน
                    borderRadius: BorderRadius.all(Radius.circular(12)), // ขอบมน
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อนเมื่อ focus
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // เพิ่ม padding ภายใน
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'หมวดหมู่', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบเป็นเทาอ่อน
                    borderRadius: BorderRadius.circular(12), // โค้งมน 12 หน่วย
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบตอน focus
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // ช่องว่างภายใน
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'แท็ก', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบเป็นเทาอ่อน
                    borderRadius: BorderRadius.circular(12), // โค้งมน 12 หน่วย
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบตอน focus
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // ช่องว่างภายใน
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ราคา', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบเป็นเทาอ่อน
                    borderRadius: BorderRadius.circular(12), // โค้งมน 12 หน่วย
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // สีขอบตอน focus
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // ช่องว่างภายใน
                ),
              ),


              // Quantity section
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action when the add button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA5A2A), // Background color
                      padding: const EdgeInsets.symmetric(vertical: 18), // Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text('โพสต์', style: TextStyle(color: Colors.white, fontSize: 16)), // Button text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: sellerFooter(context, 'post'),
    );
  }
}
