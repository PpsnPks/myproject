// import 'dart:io';
// import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myproject/Service/postservice.dart'; // เพิ่มการนำเข้า
import 'package:myproject/Service/uploadimgservice.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/Service/dropdownservice.dart';
// import 'package:myproject/auth_service.dart';
import 'package:myproject/app/seller/sellerfooter.dart'; // นำเข้าฟุตเตอร์
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<Uint8List> _imageBytesList = []; // เก็บภาพในรูปแบบ Uint8List
  int currentIndex = 0;
  List category = [];
  List<dynamic> tagList = []; // เก็บแท็กที่ได้จาก API
  String? selectedTag; // เก็บค่า tag ที่เลือก
  String? product_cate; // เก็บค่า category ที่เลือก
  final PageController _pageController = PageController(); // ตัวควบคุม PageView

  XFile? pickedFile;
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery); // เลือกหลายภาพได้
    List<XFile> pickedFiles = [];
    pickedFiles.add(pickedFile!);
    if (_imageBytesList.length > 2) {
      // ถ้าภาพรวมกันแล้วเกิน 5 รูป ให้แสดงข้อความแจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('คุณสามารถเลือกได้สูงสุด 2 รูป')),
      );
    } else {
      // อ่านภาพเป็น bytes และเพิ่มลงในรายการ
      final List<Uint8List> newImageBytes = await Future.wait(
        pickedFiles.map((file) => file.readAsBytes()),
      );

      setState(() {
        _imageBytesList = [];
        _imageBytesList.addAll(newImageBytes); // เพิ่มภาพที่เลือกใหม่
      });
    }
  }

  Future<void> _post() async {
    Map<String, dynamic> uploadResponse = {};
    if (pickedFile != null) {
      uploadResponse = await UploadImgService().uploadImg(pickedFile!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเพิ่มรูปภาพ')),
      );
    }

    String images_path;
    if (uploadResponse['success']) {
      images_path = uploadResponse['image'];
      print('all_url_images = ${uploadResponse['images']}');
    } else {
      print('upload error = ${uploadResponse['message']}');
      return;
    }
    final postService = PostService();

    // เรียกใช้ฟังก์ชัน addpost
    final result = await postService.addPost(
        images_path, // _imageController.text,
        _detailController.text,
        _categoryController.text,
        _tagController.text,
        _priceController.text);

    if (result['success']) {
      print("โพสต์สำเร็จ");
      String role = await Securestorage().readSecureData('role');
      if (role == 'buy') {
        Navigator.pushReplacementNamed(context, '/allpost');
      } else if (role == 'sell') {
        Navigator.pushReplacementNamed(context, '/post');
      } else {
        print('error --> role == $role');
      }
    } else {
      print(result['message']);
    }
  }

  getDropdown() async {
    try {
      List<dynamic> datacategory = await Dropdownservice().getCategory();

      if (datacategory.isEmpty) {
        print("⚠️ ไม่มีหมวดหมู่ที่ได้จาก API");
      } else {
        print("📌 หมวดหมู่ที่ได้: $datacategory");
      }

      setState(() {
        category = datacategory;
      });
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  getTag(List<int> categoryIds) async {
    if (categoryIds.isEmpty) {
      print("⚠️ ต้องเลือกหมวดหมู่ก่อน!");
      return;
    }

    try {
      List<dynamic> tags = await Dropdownservice().getTag(categoryIds);

      if (tags.isEmpty) {
        print("⚠️ ไม่มีแท็กที่ได้จาก API");
      } else {
        print("📌 แท็กที่ได้: $tags");
      }

      setState(() {
        tagList = tags; // อัปเดต state สำหรับ dropdown ของแท็ก
      });
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getDropdown();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
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
                const Text('* รูปสินค้าควรมีความคมชัดเพื่อให้มองเห็นรายละเอียดได้ชัดเจน', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _detailController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียดโพสต์',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: validateDetail,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: [
                    for (var item in category)
                      DropdownMenuItem<String>(
                        value: item['category_name'], // ป้องกัน null
                        child: Text(item['category_name'] ?? "ไม่ระบุ"), // แสดงค่าเริ่มต้นหากเป็น null
                      ),
                  ],
                  onChanged: (value) async {
                    if (value == null || value.isEmpty) return; // ป้องกันการตั้งค่าเป็น null

                    setState(() {
                      product_cate = value;
                      _categoryController.text = value;
                      selectedTag = null; // รีเซ็ต tag ทุกครั้งที่เปลี่ยน category
                      tagList = []; // รีเซ็ต dropdown tag
                    });

                    // 📌 เรียก API ดึงแท็กของหมวดหมู่ที่เลือก
                    List<dynamic> tags =
                        await Dropdownservice().getTag([(category.firstWhere((item) => item['category_name'] == value))['id']]);

                    setState(() {
                      tagList = tags;
                    });
                  },
                  value: product_cate?.isNotEmpty == true ? product_cate : null, // ป้องกันค่า null
                  hint: const Text('หมวดหมู่'),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกหมวดหมู่" : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: [
                    for (var tag in tagList)
                      DropdownMenuItem<String>(
                        value: tag['name'], // ป้องกัน null
                        child: Text(tag['name'] ?? "ไม่มีชื่อแท็ก"),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null || value.isEmpty) return; // ป้องกัน null

                    setState(() {
                      selectedTag = value;
                      _tagController.text = value;
                    });
                  },
                  value: selectedTag?.isNotEmpty == true ? selectedTag : null, // ป้องกันค่า null
                  hint: const Text('แท็ก'),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกแท็ก" : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
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
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: validatePrice,
                ),
                // Add other form fields as needed...
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await _post(); // Wait for the action to complete
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA5A2A),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('โพสต์', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: sellerFooter(context, 'post'),
    );
  }

  String? validateDetail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรายละเอียดโพสต์';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกราคาสินค้า';
    } else if (int.tryParse(value) == null) {
      return 'กรุณากรอกเฉพาะตัวเลข';
    }
    return null;
  }
}
