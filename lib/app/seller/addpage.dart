import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isSelling = true;
  bool isRenting = false;
  bool isPreOrder = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่ม"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSelling = true;
                          isRenting = false;
                          isPreOrder = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelling ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA),
                        foregroundColor: isSelling ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('ขาย'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSelling = false;
                          isRenting = true;
                          isPreOrder = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRenting ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA),
                        foregroundColor: isRenting ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('แจก'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSelling = false;
                          isRenting = false;
                          isPreOrder = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPreOrder ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA),
                        foregroundColor: isPreOrder ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('Pre Order'),
                    ),
                  ),
                ],
              ),
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'ชื่อสินค้า', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
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
                  labelText: 'ประเภท', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'ขนาด',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อน
                          borderRadius: BorderRadius.circular(12), // ขอบมน
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อนเมื่อ focus
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // เพิ่มระยะห่างระหว่างช่องกรอก
                  
                  // ตรวจสอบสถานะ isRenting เพื่อแสดงหรือซ่อนช่องราคา
                  if (!isRenting)
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'ราคา',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อน
                            borderRadius: BorderRadius.circular(12), // ขอบมน
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อนเมื่อ focus
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'ระยะเวลา',
                  suffixIcon: Icon(Icons.calendar_today), // ไอคอนปฏิทินด้านขวา
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

              // Quantity section
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('จำนวน', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Status dropdown
              const SizedBox(height: 8),
              const Text('สถานที่นัดรับสินค้า', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'ready', child: Text('ยังจัดส่งได้ปกติ')),
                  DropdownMenuItem(value: 'out_of_stock', child: Text('สินค้าหมดชั่วคราว')),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              // Add to list button
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
                      padding: const EdgeInsets.symmetric(vertical: 12), // Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text('เพิ่มรายการ', style: TextStyle(color: Colors.white, fontSize: 16)), // Button text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}