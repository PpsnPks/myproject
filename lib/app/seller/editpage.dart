import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/Service/addservice.dart';
import 'package:myproject/Service/dropdownservice.dart';
import 'package:myproject/Service/uploadimgservice.dart';
import 'package:myproject/environment.dart';
// import 'package:myproject/app/seller/sellerfooter.dart';
// import 'package:myproject/Service/editservice.dart'; // ปรับเป็น path ที่ถูกต้อง

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSelling = true;
  bool isRenting = false;
  bool isPreOrder = false;
  int quantity = 1;
  String? defect;
  String? product_years;
  String? product_cate;
  String? selectedCondition; // สำหรับ สภาพสินค้า
  String? selectedUsageTime;
  String? selectedUsagePeriod; // สำหรับ ระยะเวลาการใช้งาน
  String? selectedPickupLocation;
  String? selectedPickupCategory;

  List<Uint8List> _imageBytesList = []; // เก็บภาพในรูปแบบ Uint8List
  List<dynamic> tagList = [];
  String? selectedTag;
  int currentIndex = 0; // ตัวแปรเพื่อเก็บตำแหน่งภาพที่กำลังแสดง
  final PageController _pageController = PageController();
  final TextEditingController _productNameController = TextEditingController();
  List<dynamic> imagesPath = [];
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

  List category = [];

  // resetData() {
  //   _productNameController.clear();
  //   _productImagesController.clear();
  //   _productQtyController.clear();
  //   _productPriceController.clear();
  //   _productDescriptionController.clear();
  //   _productCategoryController.clear();
  //   _dateExpController.clear();
  //   _productLocationController.clear();
  //   _productConditionController.clear();
  //   _productDefectController.clear();
  //   _productYearsController.clear();
  //   _tagController.clear();
  //   quantity = 1;
  // }

  List<XFile> files = [];
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> pickedFiles = await picker.pickMultiImage(); // เลือกหลายภาพได้

    if (_imageBytesList.length + pickedFiles.length + imagesPath.length > 5) {
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
        // _imageBytesList = [];
        files.addAll(pickedFiles);
        _imageBytesList.addAll(newImageBytes); // เพิ่มภาพที่เลือกใหม่
      });
    }
  }

  Future<void> _update() async {
    Map<String, dynamic> uploadResponse = await UploadImgService().uploadImgs(files);
    List<dynamic> imagesPathLocal = [];
    if (uploadResponse['success']) {
      List newImagesPath = imagesPath.map((url) {
        return url.replaceFirst('${Environment.imgUrl}/', ''); // เอาส่วน baseUrl ออก
      }).toList();
      print('111 $imagesPathLocal');
      imagesPathLocal.addAll(newImagesPath);
      print('222 $imagesPathLocal');
      imagesPathLocal.addAll(uploadResponse['images']);
      // print('333 $imagesPath');
      // imagesPath.add(imagesPathLocal[0]);
      // print('444 $imagesPath');

      print('all_url_images = ${uploadResponse['images']}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอัปโหลดรูปภาพเป็น jpeg, jpg, png เท่านั้น')),
      );
      print('upload error = ${uploadResponse['message']}');
      return;
    }

    // กำหนดราคาเป็น 0 หากเลือก "แจก" (isRenting == true)
    final productPrice = isRenting ? '0' : _productPriceController.text;

    final productCon = isPreOrder ? 'มือหนึ่ง' : _productConditionController.text;
    final productDefect = isPreOrder || productCon == 'มือหนึ่ง' ? '' : _productDefectController.text;
    final productYear = isPreOrder || productCon == 'มือหนึ่ง' ? '' : _productYearsController.text;

    final result = await ProductService().updateProduct(
      widget.productId,
      _productNameController.text,
      imagesPathLocal, //imagesPath, //_productImagesController.text,
      quantity, // _productQtyController.text
      productPrice,
      _productDescriptionController.text,
      _productCategoryController.text,
      _productTypeController.text,
      _dateExpController.text,
      _productLocationController.text,
      productCon, //_productConditionController.text,
      productDefect, //_productDefectController.text,
      productYear, //_productYearsController.text,
      _tagController.text,
    );

    if (result['success']) {
      print("เพิ่มสินค้าสำเร็จ");
      Navigator.pushReplacementNamed(context, '/seller'); // Navigate to /seller after completion
    } else {
      print(result['message']);
    }
  }

  getDropdown() async {
    category = await Dropdownservice().getCategory();
    print('category $category');
  }

  bool isLoading = true;
  void getProductData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> response = await ProductService().getProductById(widget.productId);
    if (response['success'] == true) {
      Product data = response['data'];
      print(data.product_images);
      if (data.product_type == 'พรีออร์เดอร์') {
        isPreOrder = true;
        isRenting = false;
        isSelling = false;
      } else if (data.product_type == 'แจก') {
        isPreOrder = false;
        isRenting = false;
        isSelling = true;
      } else if (data.product_type == 'ขาย') {
        isPreOrder = false;
        isRenting = false;
        isSelling = true;
      }
      setState(() {
        _productNameController.text = data.product_name;
        imagesPath = data.product_images;
        quantity = int.tryParse(data.product_qty) ?? 1;
        _productPriceController.text = (int.parse(data.product_price.replaceAll(',', '')).toInt()).toString();
        _productDescriptionController.text = data.product_description;
        _productCategoryController.text = data.product_category;
        product_cate = data.product_category;
        _productTypeController.text = data.product_type; // ***************
        _dateExpController.text = data.date_exp; // ***************
        _productLocationController.text = data.product_location;
        selectedPickupLocation = data.product_location;
        _productConditionController.text = data.product_condition;
        selectedCondition = data.product_condition;
        _productDefectController.text = data.product_defect;
        _productYearsController.text = data.product_years;
        product_years = data.product_years;
        _tagController.text = data.tag;
        isLoading = false;
        selectedTag = data.tag;
      });
      return;
    } else {
      setState(() {
        isLoading = false;
      });
      print(response['message']);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _productTypeController.text = 'sell'; // หรือค่าเริ่มต้นที่เหมาะสม
    getDropdown();
    getProductData();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อสินค้า';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกหมวดหมู่สินค้า';
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

  String? validateDetail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรายละเอียดสินค้า';
    }
    return null;
  }

  String? validateTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือก Tag สินค้า';
    }
    return null;
  }

  String? validateExp(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกระยะเวลา';
    }
    return null;
  }

  String? validateCondition(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกสภาพของสินค้า';
    }
    return null;
  }

  String? validateProductYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกอายุการใช้งานสินค้า';
    }
    return null;
  }

  String? validateDefect(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาระบุตำหนิของสินค้า';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกสถานที่นัดรับสินค้า';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไข"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0XFFE35205),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _productTypeController.text = 'ขาย';
                                  isSelling = true;
                                  isRenting = false;
                                  isPreOrder = false;
                                  // resetData();
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
                                  _productTypeController.text = 'แจก';
                                  isSelling = false;
                                  isRenting = true;
                                  isPreOrder = false;
                                  // resetData();
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
                                  _productTypeController.text = 'พรีออร์เดอร์';
                                  isSelling = false;
                                  isRenting = false;
                                  isPreOrder = true;
                                  // resetData();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPreOrder ? const Color(0xFFFA5A2A) : const Color(0xFFFCEEEA),
                                foregroundColor: isPreOrder ? Colors.white : const Color(0xFFFA5A2A),
                              ),
                              child: const Text('Pre Order'),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              itemCount: _imageBytesList.isEmpty ? imagesPath.length + 1 : imagesPath.length + _imageBytesList.length + 1,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                if (index >= imagesPath.length + _imageBytesList.length) {
                                  return GestureDetector(
                                    onTap: _pickImages,
                                    child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.grey)),
                                          ],
                                        )),
                                  );
                                } else if (index < imagesPath.length) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: double.infinity, // ป้องกัน no size error
                                          child: Image.network(
                                            imagesPath[index],
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(0XFFE35205),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons.error, color: Colors.red, size: 50),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            imagesPath.length + _imageBytesList.length,
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
                                          '${currentIndex + 1}/${imagesPath.length + _imageBytesList.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            backgroundColor: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              imagesPath.removeAt(index); // ลบรูปเมื่อกดปุ่ม
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(143, 97, 97, 97), // พื้นหลังเทา
                                              shape: BoxShape.circle, // รูปแบบวงกลม
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image.memory(
                                              _imageBytesList[index - imagesPath.length],
                                              fit: BoxFit.cover,
                                            ),
                                          )),
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
                                          '${currentIndex + 1}/${imagesPath.length + _imageBytesList.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            backgroundColor: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _imageBytesList.removeAt(index - imagesPath.length); // ลบรูปเมื่อกดปุ่ม
                                              files.removeAt(index - imagesPath.length);
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(143, 97, 97, 97), // พื้นหลังเทา
                                              shape: BoxShape.circle, // รูปแบบวงกลม
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      // Image upload section
                      //
                      const SizedBox(height: 8),
                      const Text('* รูปสินค้าควรมีขนาดใหญ่และชัดเจนเพื่อให้ลูกค้ามองเห็นรายละเอียดสินค้าได้',
                          style: TextStyle(color: Colors.grey)),

                      // Product form fields
                      const SizedBox(height: 16),
                      TextFormField(
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
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        validator: validateName,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        items: [
                          for (var item in category)
                            DropdownMenuItem<String>(
                              value: item['category_name'], // ป้องกัน null
                              child: Text(item['category_name']), // แสดงค่าเริ่มต้นหากเป็น null
                            ),
                        ],
                        onChanged: (value) async {
                          if (value == null || value.isEmpty) return; // ป้องกันการตั้งค่าเป็น null

                          setState(() {
                            product_cate = value;
                            _productCategoryController.text = value;
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกหมวดหมู่" : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (!isRenting)
                            Expanded(
                              child: TextFormField(
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red), // สีแดงเมื่อ error และโฟกัส
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  errorStyle: const TextStyle(
                                    fontSize: 10,
                                    // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                                  ),
                                ),
                                validator: validatePrice,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        controller: _productDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'รายละเอียดสินค้า',
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
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        validator: validateDetail,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        items: [
                          for (var tag in tagList)
                            DropdownMenuItem<String>(
                              value: tag['name'], // ป้องกัน null
                              child: Text(tag['name']),
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
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกแท็ก" : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _dateExpController,
                        decoration: InputDecoration(
                          labelText: 'ระยะเวลา',
                          suffixIcon: const Icon(Icons.calendar_today),
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
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode()); // Hide the keyboard when tapping the TextField
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            // Format the selected date to a string
                            _dateExpController.text = "${selectedDate.toLocal()}".split(' ')[0];
                          }
                        },
                        validator: validateExp,
                      ),
                      // Quantity section
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      !isPreOrder
                          ? Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  items: const [
                                    DropdownMenuItem(value: 'มือหนึ่ง', child: Text('มือหนึ่ง')),
                                    DropdownMenuItem(value: 'มือสอง', child: Text('มือสอง')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCondition = value;
                                      // Set value in _productConditionController when "มือหนึ่ง" or "มือสอง" is selected
                                      _productConditionController.text = value!;

                                      // When "มือหนึ่ง" is selected, clear defect and years data
                                      if (selectedCondition == 'มือหนึ่ง') {
                                        _productDefectController.clear();
                                        _productYearsController.clear();
                                      } else {
                                        product_years = 'น้อยกว่า 1 ปี';
                                        _productYearsController.text = 'น้อยกว่า 1 ปี';
                                      }
                                    });
                                  },
                                  value: selectedCondition,
                                  hint: const Text('สภาพสินค้า'),
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
                                    errorStyle: const TextStyle(
                                      fontSize: 10,
                                      // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                                    ),
                                  ),
                                  validator: validateCondition,
                                ),
                                const SizedBox(height: 8),
                              ],
                            )
                          : const SizedBox(height: 0),
                      // Show defect and usage years fields only if "มือสอง" is selected
                      selectedCondition == 'มือสอง'
                          ? Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  items: const [
                                    DropdownMenuItem(value: 'น้อยกว่า 1 ปี', child: Text('น้อยกว่า 1 ปี')),
                                    DropdownMenuItem(value: '1-3 ปี', child: Text('1-3 ปี')),
                                    DropdownMenuItem(value: '3-5 ปี', child: Text('3-5 ปี')),
                                    DropdownMenuItem(value: 'มากกว่า 5 ปี', child: Text('มากกว่า 5 ปี')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      product_years = value;
                                      _productYearsController.text = value!;
                                    });
                                  },
                                  value: product_years,
                                  hint: const Text('อายุการใช้งานสินค้า'),
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
                                    errorStyle: const TextStyle(
                                      fontSize: 10,
                                      // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                                    ),
                                  ),
                                  validator: validateProductYear,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _productDefectController,
                                  onChanged: (value) {
                                    setState(() {
                                      defect = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'ระบุตำหนิของสินค้า',
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
                                    errorStyle: const TextStyle(
                                      fontSize: 10,
                                      // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                                    ),
                                  ),
                                  validator: validateDefect,
                                ),
                                const SizedBox(height: 8),
                              ],
                            )
                          : const SizedBox(height: 0),

                      DropdownButtonFormField<String>(
                        items: const [
                          DropdownMenuItem(value: 'เกกี', child: Text('เกกี')),
                          DropdownMenuItem(value: 'RNP', child: Text('RNP')),
                          DropdownMenuItem(value: 'FBT', child: Text('FBT')),
                          DropdownMenuItem(value: 'จินดา', child: Text('จินดา')),
                          DropdownMenuItem(value: 'ตึกโหล', child: Text('ตึกโหล')),
                          DropdownMenuItem(value: 'ตึก HM', child: Text('ตึก HM')),
                          DropdownMenuItem(value: 'ร้านนางคาเฟ่', child: Text('ร้านนางคาเฟ่')),
                          DropdownMenuItem(value: 'โรงอาหารพระเทพ', child: Text('โรงอาหารพระเทพ')),
                          DropdownMenuItem(value: 'คลินิคสจล', child: Text('คลินิคสจล')),
                          DropdownMenuItem(value: 'สนามกีฬา', child: Text('สนามกีฬา')),
                          DropdownMenuItem(value: 'หอใน', child: Text('หอใน')),
                          DropdownMenuItem(value: 'โรงอาหารคณะวิทย์', child: Text('โรงอาหารคณะวิทย์')),
                          DropdownMenuItem(value: 'โรงอาหารคณะครุ', child: Text('โรงอาหารคณะครุ')),
                          DropdownMenuItem(value: 'หอสมุด', child: Text('หอสมุด')),
                          DropdownMenuItem(value: 'หอประชุม (วร บุนนาค)', child: Text('หอประชุม (วร บุนนาค)')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPickupLocation = value;
                            _productLocationController.text = value!;
                          });
                        },
                        value: selectedPickupLocation,
                        hint: const Text('สถานที่นัดรับสินค้า'),
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
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                          ),
                        ),
                        validator: validateLocation,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await _update(); // Wait for the action to complete
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFA5A2A),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('บันทึกการเปลี่ยนแปลง', style: TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      // bottomNavigationBar: sellerFooter(context, 'seller'),
    );
  }
}

// Center(
//   child: SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: () {
//         // _updateProduct(); // เรียกใช้ฟังก์ชันอัปเดต
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFFA5A2A),
//         padding: const EdgeInsets.symmetric(vertical: 18),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       child: const Text('บันทึกการเปลี่ยนแปลง', style: TextStyle(color: Colors.white, fontSize: 16)),
//     ),
//   ),
// ),

// ClipRRect(
//   borderRadius: BorderRadius.circular(8),
//   child: CachedNetworkImage(
//     imageUrl: imagesPath.isNotEmpty
//         ? imagesPath[index]
//         : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
//     placeholder: (context, url) => const SizedBox(
//       child: Center(
//         child: CircularProgressIndicator(
//           color: Color(0XFFE35205),
//           strokeCap: StrokeCap.round,
//         ),
//       ),
//     ),
//     imageBuilder: (context, ImageProvider) {
//       return Container(
//         width: 300,
//         height: 200, // ให้ height เท่ากับ width
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: ImageProvider,
//             fit: BoxFit.fill, // ปรับขนาดภาพให้เต็ม
//           ),
//         ),
//       );
//     },
// errorWidget: (context, url, error) => LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Container(
//                       width: 300,
//                       height: 200,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/notfound.png"), // รูปจาก assets
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//   ),
// );
