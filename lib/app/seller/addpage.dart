import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart'; // เพิ่มการนำเข้า
import 'package:myproject/auth_service.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isSelling = true;
  bool isRenting = false;
  bool isPreOrder = false;
  String? selectedCondition;
  String? selectedUsageTime;
  String? defect;
  int quantity = 1;
 // สำหรับ สภาพสินค้า
  String? selectedUsagePeriod; // สำหรับ ระยะเวลาการใช้งาน
  String? selectedPickupLocation;

  List<Uint8List> _imageBytesList = []; // เก็บภาพในรูปแบบ Uint8List
  int currentIndex = 0; // ตัวแปรเพื่อเก็บตำแหน่งภาพที่กำลังแสดง
  final PageController _pageController = PageController();
  final TextEditingController _product_nameController = TextEditingController();
  final TextEditingController _product_imagesController = TextEditingController();
  final TextEditingController _product_qtyController = TextEditingController();
  final TextEditingController _product_priceController = TextEditingController();
  final TextEditingController _product_descriptionController = TextEditingController();
  final TextEditingController _product_categoryController = TextEditingController();
  final TextEditingController _product_typeController = TextEditingController();
  final TextEditingController _date_expController = TextEditingController();
  final TextEditingController _product_locationController = TextEditingController();
  final TextEditingController _product_conditionController = TextEditingController();
  final TextEditingController _product_defectController = TextEditingController();
  final TextEditingController _product_yearsController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();// ตัวควบคุม PageView

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(); // เลือกหลายภาพได้

    if (pickedFiles != null) {
      if (_imageBytesList.length + pickedFiles.length > 5) {
        // ถ้าภาพรวมกันแล้วเกิน 5 รูป ให้แสดงข้อความแจ้งเตือน
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คุณสามารถเลือกได้สูงสุด 5 รูป')),
        );
      } else {
        // อ่านภาพเป็น bytes และเพิ่มลงในรายการ
        final List<Uint8List> newImageBytes = await Future.wait(
          pickedFiles.map((file) => file.readAsBytes()),
        );

        setState(() {
          _imageBytesList.addAll(newImageBytes); // เพิ่มภาพที่เลือกใหม่
        });
      }
    }
  }

  Future<void> _add() async {
      final addService = AddService();
      final result = await addService.addproduct(
        _product_nameController.text,
        _product_imagesController.text,
        _product_qtyController.text,
        _product_priceController.text,
        _product_descriptionController.text,
        _product_typeController.text,
        _product_categoryController.text,
        _date_expController.text,
        _product_locationController.text,
        _product_conditionController.text,
        _product_defectController.text,
        _product_yearsController.text,
        _tagController.text,
      );

      if (result['success']) {
        print("โพสต์สำเร็จ");
      } else {
        print(result['message']);
      }
    }

  void updateProductType(String type) {
    setState(() {
      _product_typeController.text = type;
    });
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
                        updateProductType('ขาย');
                        setState(() {
                          isSelling = true;
                          isRenting = false;
                          isPreOrder = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelling
                            ? const Color(0xFFFA5A2A)
                            : const Color(0xFFFCEEEA),
                        foregroundColor: isSelling ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('ขาย'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateProductType('แจก');
                        setState(() {
                          isSelling = false;
                          isRenting = true;
                          isPreOrder = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRenting
                            ? const Color(0xFFFA5A2A)
                            : const Color(0xFFFCEEEA),
                        foregroundColor: isRenting ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('แจก'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateProductType('Pre Order');
                        setState(() {
                          isSelling = false;
                          isRenting = false;
                          isPreOrder = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPreOrder
                            ? const Color(0xFFFA5A2A)
                            : const Color(0xFFFCEEEA),
                        foregroundColor: isPreOrder ? Colors.white : const Color(0xFFFA5A2A),
                      ),
                      child: const Text('Pre Order'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image upload section
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imageBytesList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _imageBytesList.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    _imageBytesList[index],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _imageBytesList.length,
                                  (index) => Container(
                                    margin: EdgeInsets.only(right: 8),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: index == currentIndex
                                          ? Color(0xFFFA5A2A)
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 16,
                              child: Text(
                                '${currentIndex + 1}/${_imageBytesList.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                  '* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้',
                  style: TextStyle(color: Colors.grey)),

              // Product form fields
              const SizedBox(height: 16),
              TextField(
                controller: _product_nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _product_categoryController,
                decoration: InputDecoration(
                  labelText: 'หมวดหมู่',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (!isRenting)
                    Expanded(
                      child: TextField(
                        controller: _product_priceController,
                        decoration: InputDecoration(
                          labelText: 'ราคา',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                controller: _product_descriptionController,
                decoration: InputDecoration(
                  labelText: 'รายละเอียดสินค้า',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: 'แท็ก',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _date_expController,
                decoration: InputDecoration(
                  labelText: 'ระยะเวลา',
                  suffixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
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
                            if (quantity > 1) {
                              quantity--;
                              _product_qtyController.text = quantity.toString(); // อัปเดตค่าของ controller
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                            _product_qtyController.text = quantity.toString(); // อัปเดตค่าของ controller
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('สภาพสินค้า', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'มือหนึ่ง', child: Text('มือหนึ่ง')),
                  DropdownMenuItem(value: 'มือสอง', child: Text('มือสอง')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCondition = value;
                    // เมื่อเลือก "มือสอง", ให้ตั้งค่า selectedUsagePeriod เป็น null หรือค่าพื้นฐาน
                    selectedUsagePeriod = null;
                  });
                },
                value: selectedCondition,
                hint: const Text('เลือกรายการ'),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),

              // แสดงช่องระยะเวลาการใช้งานเฉพาะเมื่อเลือก 'มือสอง'
              if (selectedCondition == 'มือสอง') ...[
                const Text('ระยะเวลาการใช้งาน', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('น้อยกว่า1 ปี')),
                    DropdownMenuItem(value: '2', child: Text('มากกว่า 1 ปี')),
                    DropdownMenuItem(value: '3', child: Text('2-3 ปี')),
                    DropdownMenuItem(value: '4', child: Text('มากกว่า 5 ปี')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUsagePeriod = value;
                    });
                  },
                  value: selectedUsagePeriod,
                  hint: const Text('เลือกรายการ'),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _product_defectController,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                ),
              ],

              // สถานที่นัดรับสินค้า
              const SizedBox(height: 8),
              const Text('สถานที่นัดรับสินค้า', style: TextStyle(fontSize: 16)),
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
                    selectedPickupLocation = value;
                  });
                },
                value: selectedPickupLocation,
                hint: const Text('เลือกรายการ'),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _add,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA5A2A),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('เพิ่ม', style: TextStyle(color: Colors.white, fontSize: 16)),
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
