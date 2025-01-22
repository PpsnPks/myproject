import 'package:flutter/material.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isSelling = true;
  bool isRenting = false;
  bool isPreOrder = false;
  String? selectedCondition;
  String? selectedUsageTime;
  String? defect;
  int quantity = 1;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController =
      TextEditingController(); // check form isSelling, isRenting, isPreOrder ได้
  final TextEditingController _dateExpController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  //ระยะเวลา กับ ตำหนิสินค้า หาย
  resetData() {
    selectedCondition = 'new';
    selectedUsageTime = '';
    defect = '';
    quantity = 1;
    _nameController.clear();
    _categoryController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _typeController.clear(); // check form isSelling, isRenting, isPreOrder ได้
    _dateExpController.clear();
    _locationController.clear();
    _conditionController.clear();
  }

  Future<void> addProduct() async {
    if (_nameController.text != '' &&
        _descriptionController.text != '' &&
        _categoryController.text != '' &&
        _typeController.text != '' &&
        _dateExpController.text != '' &&
        _locationController.text != '' &&
        _conditionController.text != '') {
      // สร้างข้อมูลที่จะส่งไปยัง API
      Map<String, dynamic> userData = {
        "product_name": _nameController.text,
        "product_images": ["test1", "test2"],
        "product_qty": 1,
        "product_price": 0,
        "product_description": "string",
        "product_category": "string",
        "product_type": "string",
        "seller_id": 1, // ใช้ user_id เลยช้ะ
        "date_exp": "2024-12-12",
        "location": "string",
        "condition": "string"
      };

      final Uri url = Uri.parse('http://localhost:8000/api/auth/register');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        // ตรวจสอบสถานะของ response
        if (response.statusCode == 200) {
          // หากการลงทะเบียนสำเร็จ
          print('ลงทะเบียนสำเร็จ');
          // แสดงข้อความแจ้ง หรือนำผู้ใช้ไปหน้าอื่น
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
          );
        } else {
          // หากการลงทะเบียนล้มเหลว
          print('การลงทะเบียนล้มเหลว: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('การลงทะเบียนล้มเหลว')),
          );
          // แสดงข้อความแจ้ง error
          // setState(() {
          //   _errorMessage = 'การลงทะเบียนล้มเหลว: ${response.body}';
          // });
        }
      } catch (error) {
        // Handle network or other errors
        print('เกิดข้อผิดพลาด: $error');
        // setState(() {
        //   _errorMessage = 'เกิดข้อผิดพลาด: $error';
        // });
      }
    }
  }

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
          child: Form(
            key: _formKey,
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
                            resetData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelling
                              ? const Color(0xFFFA5A2A)
                              : const Color(0xFFFCEEEA),
                          foregroundColor: isSelling
                              ? Colors.white
                              : const Color(0xFFFA5A2A),
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
                            resetData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRenting
                              ? const Color(0xFFFA5A2A)
                              : const Color(0xFFFCEEEA),
                          foregroundColor: isRenting
                              ? Colors.white
                              : const Color(0xFFFA5A2A),
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
                            resetData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPreOrder
                              ? const Color(0xFFFA5A2A)
                              : const Color(0xFFFCEEEA),
                          foregroundColor: isPreOrder
                              ? Colors.white
                              : const Color(0xFFFA5A2A),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                    '* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้',
                    style: TextStyle(color: Colors.grey)),

                // Product form fields
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText:
                        'ชื่อสินค้า', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0)), // สีขอบเป็นเทาอ่อน
                      borderRadius:
                          BorderRadius.circular(12), // โค้งมน 12 หน่วย
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0)), // สีขอบตอน focus
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12), // ช่องว่างภายใน
                  ),
                  controller: _nameController,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'ประเภท', // สามารถเปลี่ยนข้อความได้ตามที่ต้องการ
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0)), // สีขอบเป็นเทาอ่อน
                      borderRadius:
                          BorderRadius.circular(12), // โค้งมน 12 หน่วย
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0)), // สีขอบตอน focus
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12), // ช่องว่างภายใน
                  ),
                  controller: _categoryController,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Add spacing between fields
                    // Check if the item is not for giving away (แจก) before showing the 'ราคา' field
                    if (!isRenting)
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'ราคา',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color:
                                      Color(0xFFE0E0E0)), // Light grey border
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(
                                      0xFFE0E0E0)), // Light grey border when focused
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                          ),
                          controller: _priceController,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียดสินค้า',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อน
                      borderRadius:
                          BorderRadius.all(Radius.circular(12)), // ขอบมน
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อนเมื่อ focus
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12), // เพิ่ม padding ภายใน
                  ),
                  controller: _descriptionController,
                ),

                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'ระยะเวลา',
                    suffixIcon:
                        Icon(Icons.calendar_today), // ไอคอนปฏิทินด้านขวา
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อน
                      borderRadius:
                          BorderRadius.all(Radius.circular(12)), // ขอบมน
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE0E0E0)), // ขอบสีเทาอ่อนเมื่อ focus
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12), // เพิ่ม padding ภายใน
                  ),
                  controller: _dateExpController,
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
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.grey),
                        ),
                        Text(quantity.toString(),
                            style: const TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                // Status dropdown
                const SizedBox(height: 16),
                const Text('สถานที่นัดรับสินค้า',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: 'เกกี 1', child: Text('เกกี 1')),
                    DropdownMenuItem(value: 'เกกี 2', child: Text('เกกี 2')),
                    DropdownMenuItem(value: 'เกกี 3', child: Text('เกกี 3')),
                    DropdownMenuItem(value: 'เกกี 4', child: Text('เกกี 4')),
                    DropdownMenuItem(value: 'ตึกโหล', child: Text('ตึกโหล')),
                    DropdownMenuItem(value: 'ECC', child: Text('ECC')),
                    DropdownMenuItem(value: 'หอสมุด', child: Text('หอสมุด')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _locationController.text =
                          value ?? ''; // อัพเดตค่า controller
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Show สภาพสินค้า only when selling or giving away
                if (isSelling || isRenting) const SizedBox(height: 16),
                if (isSelling || isRenting)
                  const Text('สภาพสินค้า', style: TextStyle(fontSize: 16)),
                if (isSelling || isRenting) const SizedBox(height: 8),
                if (isSelling || isRenting)
                  DropdownButtonFormField<String>(
                    value: selectedCondition,
                    items: const [
                      DropdownMenuItem(value: 'new', child: Text('มือหนึ่ง')),
                      DropdownMenuItem(value: 'old', child: Text('มือสอง')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCondition = value;
                        _conditionController.text =
                            value ?? ''; // อัพเดตค่า controller
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                // Show ระยะเวลาการใช้งาน and ตำหนิสินค้า only when มือสอง is selected
                if (selectedCondition == 'old') const SizedBox(height: 16),
                if (selectedCondition == 'old')
                  const Text('ระยะเวลาการใช้งาน',
                      style: TextStyle(fontSize: 16)),
                if (selectedCondition == 'old') const SizedBox(height: 8),
                if (selectedCondition == 'old')
                  DropdownButtonFormField<String>(
                    value: selectedUsageTime,
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('ต่ำกว่า 1 ปี')),
                      DropdownMenuItem(value: '2', child: Text('1-3 ปี')),
                      DropdownMenuItem(value: '3', child: Text('4-5 ปี')),
                      DropdownMenuItem(value: '4', child: Text('มากกว่า 5 ปี')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedUsageTime = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (selectedCondition == 'old') const SizedBox(height: 16),
                if (selectedCondition == 'old')
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        defect = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'ตำหนิสินค้า',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action when the add button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFA5A2A), // Background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 18), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      child: const Text('เพิ่มรายการ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)), // Button text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: sellerFooter(context, 'addproduct'),
    );
  }
}
