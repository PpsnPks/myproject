import 'package:flutter/material.dart';
import 'package:myproject/Service/dropdownservice.dart';
import 'package:myproject/Service/formservice.dart';

class TagFormPage extends StatefulWidget {
  final Map userData;
  final List selectedCategoryIds;
  const TagFormPage({super.key, required this.userData, required this.selectedCategoryIds});

  @override
  State<TagFormPage> createState() => _TagFormPageState();
}

class _TagFormPageState extends State<TagFormPage> {
  List<dynamic> tags = [];
  List<String> selectedTags = [];
  List<int> selectedCategoryIds = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;
    print("📌 Raw arguments received: $arguments"); // ✅ Debug log
    print('data: ${widget.userData}');
    print('data0: ${widget.selectedCategoryIds}');

    if (widget.selectedCategoryIds.isNotEmpty) {
      selectedCategoryIds = widget.selectedCategoryIds.map((item) => item['id'] as int).toList(); // List<int>.from();
      print("✅ Selected Categories: $selectedCategoryIds"); // ✅ Debug log
      fetchTags(selectedCategoryIds);
    } else {
      print("❌ No valid category IDs found.");
    }
  }

  Future<void> fetchTags(List<int> categoryIds) async {
    print("Fetching tags for categories: $categoryIds"); // ✅ Debug log

    Dropdownservice dropdownService = Dropdownservice();
    try {
      List<dynamic> data = await dropdownService.getTag(categoryIds);

      print("API Response: $data"); // ✅ Debug log

      if (data.isEmpty) {
        print("❌ No tags found for selected categories: $categoryIds");
      }

      setState(() {
        tags = data;
      });
    } catch (e) {
      print("🔥 Error fetching tags: $e");
    }
  }

  void toggleSelection(String tagName) {
    setState(() {
      if (selectedTags.contains(tagName)) {
        selectedTags.remove(tagName);
      } else {
        if (selectedTags.length < 4) {
          selectedTags.add(tagName);
        } else if (selectedTags.length == 4) {
          print('ครบ');
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
              "แท็กสินค้าที่คุณสนใจ",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            tags.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0XFFE35205),
                    strokeWidth: 2.0,
                  ))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map<Widget>((tag) {
                      int tagId = tag['id']; // ✅ ใช้เป็น int โดยตรง
                      String tagName = tag['name'] ?? 'ไม่ระบุ';
                      bool isSelected = selectedTags.contains(tagName);

                      return GestureDetector(
                        onTap: () => toggleSelection(tagName),
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
                            tagName,
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
                onPressed: () async {
                  if (selectedTags.length == 4) {
                    print("Selected Tags: $selectedTags"); // ✅ Debugging log

                    // เก็บค่า selectedTags ไปที่ UserService
                    // UserService userService = UserService();
                    // userService.setGuidetag(selectedTags);
                    String guidetag = selectedTags.join(', ');
                    final result = await UserService().formEdit(
                      widget.userData['name'],
                      widget.userData['imgPath'],
                      widget.userData['email'],
                      widget.userData['phone'],
                      'N/A', // Address field
                      widget.userData['faculty'],
                      widget.userData['department'],
                      widget.userData['year'],
                      widget.userData['role'],
                      guidetag,
                    );

                    if (result['success'] == true) {
                      print('บันทึกข้อมูลสำเร็จ: ${result["data"]}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')), //: ${result["data"]}
                      );
                      // ส่งไปยังหน้าถัดไป
                      Navigator.pushNamed(
                        context,
                        '/role',
                      );
                    } else {
                      print('error: ${result["message"]}');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedTags.length == 4 ? const Color(0XFFE35205) : const Color.fromARGB(255, 237, 187, 161),
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
