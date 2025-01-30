import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myproject/Service/postservice.dart'; // เพิ่มการนำเข้า
import 'package:myproject/auth_service.dart'; 
import 'package:myproject/app/seller/sellerfooter.dart'; // นำเข้าฟุตเตอร์
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // String? _image;
  final TextEditingController _imageController = TextEditingController();

  // ฟังก์ชันที่จะเรียกใช้เมื่อกดปุ่มโพสต์
  Future<void> _post() async {
    final postService = PostService();
    

    // เรียกใช้ฟังก์ชัน addpost
    final result = await postService.addpost(
      _imageController.text, // ใช้ค่า image ที่ผู้ใช้เลือก
      _detailController.text,
      _categoryController.text,
      _tagController.text,
      _priceController.text,
    );

    if (result['success']) {
      // ถ้าประสบความสำเร็จให้แสดงข้อความ
      print("โพสต์สำเร็จ");
    } else {
      // ถ้าล้มเหลวแสดงข้อความผิดพลาด
      print(result['message']);
    }
  }

  String? _base64Image; // Store base64 image data for web

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read image as bytes and encode it to base64
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Image upload section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _base64Image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('เพิ่มรูปภาพ',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(_base64Image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้', style: TextStyle(color: Colors.grey)),
              
              // Product form fields
              const SizedBox(height: 16),
              TextField(
                controller: _detailController,
                maxLines: 3,
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _categoryController,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),

              const SizedBox(height: 16),
              // Button to post
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _post, // เรียกใช้ฟังก์ชัน _post เมื่อกดปุ่ม
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
      bottomNavigationBar: sellerFooter(context, 'post'),
    );
  }
}
