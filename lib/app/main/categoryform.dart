import 'package:flutter/material.dart';
import 'package:myproject/Service/dropdownservice.dart';
import 'package:myproject/app/main/tagform.dart';

class CategoryFormPage extends StatefulWidget {
  final Map userData;
  const CategoryFormPage({super.key, required this.userData});

  @override
  _CategoryFormPageState createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  List<dynamic> categories = [];
  List<Map<String, dynamic>> selectedCategories = []; // เปลี่ยนเป็น List<Map> เพื่อเก็บ id และ name

  @override
  void initState() {
    super.initState();
    print('data: ${widget.userData}');
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    Dropdownservice dropdownService = Dropdownservice();
    List<dynamic> data = await dropdownService.getCategory();
    setState(() {
      categories = data;
    });
  }

  void toggleSelection(Map<String, dynamic> category) {
    setState(() {
      if (selectedCategories.any((selected) => selected['id'] == category['id'])) {
        selectedCategories.removeWhere((selected) => selected['id'] == category['id']);
      } else {
        if (selectedCategories.length < 2) {
          selectedCategories.add(category);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "หมวดหมู่สินค้าที่คุณสนใจ",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            categories.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0XFFE35205),
                    strokeWidth: 2.0,
                  ))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map<Widget>((category) {
                      String name = category['category_name']?.toString() ?? 'ไม่ระบุ';
                      bool isSelected = selectedCategories.any((selected) => selected['id'] == category['id']);
                      return GestureDetector(
                        onTap: () => toggleSelection(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? const Color(0XFFE35205) : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? const Color(0XFFE35205) : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategories.isNotEmpty) {
                    List<dynamic> selectedCategoryIds = selectedCategories.map((category) => category['id']).toList();
                    print("หมวดหมู่ที่เลือก (ID): $selectedCategoryIds"); // ✅ ล็อก id ที่เลือก

                    Navigator.pushNamed(
                      context,
                      '/tagform',
                      arguments: [widget.userData, selectedCategoryIds], // ส่ง id ไปหน้า /tagform
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagFormPage(userData: widget.userData, selectedCategoryIds: selectedCategories),
                      ),
                    );
                  }
                  // ล็อกข้อมูลที่เลือกก่อนจะส่งไป
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategories.isNotEmpty ? const Color(0XFFE35205) : const Color.fromARGB(255, 237, 187, 161),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'ถัดไป',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
