import 'package:flutter/material.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:myproject/Service/editservice.dart'; // ปรับเป็น path ที่ถูกต้อง

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductService _productService = ProductService();
  late Future<Product> _productFuture;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // เรียกใช้ Future เพื่อดึงข้อมูลสินค้าเมื่อหน้าโหลด
    _productFuture = _productService.getProductById(widget.productId);
  }

  Future<void> _updateProduct() async {
    // ฟังก์ชันอัปเดตข้อมูลสินค้า
    final product = Product(
      id: widget.productId,
      name: _nameController.text,
      type: _typeController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      description: _descriptionController.text,
    );

    await _productService.updateProduct(product);
    // ไปยังหน้าหรือแสดงข้อความว่าอัปเดตสำเร็จ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขสินค้า"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          // ดึงข้อมูลจาก snapshot
          final product = snapshot.data!;
          
          // กำหนดค่าให้กับ TextEditingController
          _nameController.text = product.name;
          _typeController.text = product.type;
          _priceController.text = product.price.toString();
          _descriptionController.text = product.description;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ช่องกรอกข้อมูลสินค้า
                TextField(
                  controller: _nameController,
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
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    labelText: 'ประเภท',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียดสินค้า',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateProduct(); // เรียกใช้ฟังก์ชันอัปเดต
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA5A2A),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('บันทึกการเปลี่ยนแปลง', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: sellerFooter(context, 'editproduct'),
    );
  }
}
