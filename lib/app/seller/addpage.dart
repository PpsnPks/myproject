// import 'dart:io';
// import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart'; // เพิ่มการนำเข้า
import 'package:myproject/Service/uploadimgservice.dart';
// import 'package:myproject/auth_service.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:myproject/environment.dart';

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
  // สำหรับ สภาพสินค้า
  String? selectedUsagePeriod; // สำหรับ ระยะเวลาการใช้งาน
  String? selectedPickupLocation;

  final List<Uint8List> _imageBytesList = []; // เก็บภาพในรูปแบบ Uint8List
  int currentIndex = 0; // ตัวแปรเพื่อเก็บตำแหน่งภาพที่กำลังแสดง
  final PageController _pageController = PageController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productImagesController = TextEditingController();
  final TextEditingController _productQtyController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _dateExpController = TextEditingController();
  final TextEditingController _productLocationController = TextEditingController();
  final TextEditingController _productConditionController = TextEditingController();
  final TextEditingController _productDefectController = TextEditingController();
  final TextEditingController _productYearsController = TextEditingController();
  final TextEditingController _tagController = TextEditingController(); // ตัวควบคุม PageView

  resetData() {
    _productNameController.clear();
    _productImagesController.clear();
    _productQtyController.clear();
    _productPriceController.clear();
    _productDescriptionController.clear();
    _productTypeController.clear();
    _productCategoryController.clear();
    _dateExpController.clear();
    _productLocationController.clear();
    _productConditionController.clear();
    _productDefectController.clear();
    _productYearsController.clear();
    _tagController.clear();
  }

  List<XFile> pickedFiles = [];
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    pickedFiles = await picker.pickMultiImage(); // เลือกหลายภาพได้

    if (_imageBytesList.length + pickedFiles.length > 5) {
      // ถ้าภาพรวมกันแล้วเกิน 5 รูป ให้แสดงข้อความแจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('คุณสามารถเลือกได้สูงสุด 5 รูป')),
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

  Future<void> _add() async {
    final addService = AddService();
    Map<String, dynamic> uploadResponse = await UploadImgService().uploadImg(pickedFiles);
    List images_path = [];
    if (uploadResponse['success']) {
      images_path = uploadResponse['images'];
      print('all_url_images = ${uploadResponse['images']}');
    } else {
      print('upload error = ${uploadResponse['message']}');
      return;
    }
    final result = await addService.addproduct(
      _productNameController.text,
      images_path, //_productImagesController.text,
      _productQtyController.text,
      _productPriceController.text,
      _productDescriptionController.text,
      _productTypeController.text,
      _productCategoryController.text,
      _dateExpController.text,
      _productLocationController.text,
      _productConditionController.text,
      _productDefectController.text,
      _productYearsController.text,
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
      _productTypeController.text = type;
    });

    //   Future<String> _uploadImg() async {
    //     final Uri url = Uri.parse('${Environment.baseUrl}/uploadimage');
    //     final request = http.MultipartRequest('POST', url)
    //       ..headers.addAll({
    //         'Authorization': 'Bearer $token', // ใส่ token ของคุณ
    //       })
    //       ..fields['image_path'] = '/images'; // เพิ่ม field อื่นถ้าต้องการ

    //     if (imageFile != null) {
    //       request.files.add(
    //         await http.MultipartFile.fromPath('image', imageFile!.path),
    //       );
    //     }

    //     try {
    //       final streamedResponse = await request.send();
    //       final response = await http.Response.fromStream(streamedResponse);

    //       if (response.statusCode == 200) {
    //         // Success
    //         return jsonDecode(response.body)['message'] ?? 'Uploaded successfully';
    //       } else {
    //         // Error
    //         return 'Error: ${response.statusCode}, ${response.reasonPhrase}';
    //       }
    //     } catch (e) {
    //       return 'Upload failed: $e';
    //     }
    //   }
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
                          resetData();
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
                        updateProductType('แจก');
                        setState(() {
                          isSelling = false;
                          isRenting = true;
                          isPreOrder = false;
                          resetData();
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
                        updateProductType('Pre Order');
                        setState(() {
                          isSelling = false;
                          isRenting = false;
                          isPreOrder = true;
                          resetData();
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
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: index == currentIndex ? const Color(0xFFFA5A2A) : Colors.grey,
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
              const Text('* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้', style: TextStyle(color: Colors.grey)),

              // Product form fields
              const SizedBox(height: 16),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อสินค้า',
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
                controller: _productCategoryController,
                decoration: InputDecoration(
                  labelText: 'หมวดหมู่',
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
              Row(
                children: [
                  if (!isRenting)
                    Expanded(
                      child: TextField(
                        controller: _productPriceController,
                        decoration: InputDecoration(
                          labelText: 'ราคา',
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
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                controller: _productDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียดสินค้า',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                controller: _dateExpController,
                decoration: const InputDecoration(
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                              _productQtyController.text = quantity.toString(); // อัปเดตค่าของ controller
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
                            _productQtyController.text = quantity.toString(); // อัปเดตค่าของ controller
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
                  controller: _productDefectController,
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
      bottomNavigationBar: sellerFooter(context, 'seller'),
    );
  }
}
