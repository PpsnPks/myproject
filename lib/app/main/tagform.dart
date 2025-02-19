import 'package:flutter/material.dart';
import 'package:myproject/Service/dropdownservice.dart';

class TagFormPage extends StatefulWidget {
  const TagFormPage({super.key, required List selectedCategories});

  @override
  _TagFormPageState createState() => _TagFormPageState();
}

class _TagFormPageState extends State<TagFormPage> {
  List<dynamic> tags = [];
  List<int> selectedTags = [];
  List<int> selectedCategoryIds = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;
    print("📌 Raw arguments received: $arguments"); // ✅ Debug log

    if (arguments != null && arguments is List) {
      selectedCategoryIds = List<int>.from(arguments);
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

  void toggleSelection(int tagId) {
    setState(() {
      if (selectedTags.contains(tagId)) {
        selectedTags.remove(tagId);
      } else {
        if (selectedTags.length < 5) {
          selectedTags.add(tagId);
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
                ? const Center(child: CircularProgressIndicator())
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map<Widget>((tag) {
                      int tagId = tag['id']; // ✅ ใช้เป็น int โดยตรง
                      String tagName = tag['name'] ?? 'ไม่ระบุ';
                      bool isSelected = selectedTags.contains(tagId);

                      return GestureDetector(
                        onTap: () => toggleSelection(tagId),
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
                onPressed: selectedTags.isNotEmpty
                    ? () {
                        print("Selected Tags: $selectedTags"); // ✅ Debugging log
                        Navigator.pushNamed(
                          context,
                          '/role',
                          arguments: selectedTags,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFE35205),
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
