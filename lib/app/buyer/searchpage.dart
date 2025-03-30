import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myproject/Service/addservice.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  List<Product> products = [];
  final scrollController = ScrollController();
  int page = 1;
  int perPage = 6;
  bool isLoading = false;
  bool hasMore = true;
  bool hasError = false;
  String category = "";
  String sortPrice = "asc";
  String sortDate = "desc";
  String productCondition = '';
  String productType = '';

  _loadnew(String text) async {
    List<Product> newProduct = [];
    setState(() {
      isLoading = true;
      products = [];
    });
    if (text == '') {
      setState(() {
        isLoading = false;
        products = newProduct;
      });
      return;
    }
    Map<String, dynamic> response =
        await SearchService().searchProduct(page, perPage, category, text, sortPrice, sortDate, productCondition, productType);
    if (response['success'] == true) {
      newProduct = response['data'];
      print('zzz $page, $perPage, $category, $text, $sortPrice, $sortDate, $productCondition, $productType');
      print("11111111111 $newProduct");
      if (newProduct.isEmpty) {
        setState(() {
          isLoading = false;
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          isLoading = false;
          products = newProduct;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
      hasMore = false;
    });
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    // ตั้ง focus ให้กับ TextField เมื่อหน้าจอเริ่ม
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    // อย่าลืม dispose focusNode เมื่อไม่ใช้งาน
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            // ใช้ SingleChildScrollView รอบๆ Column
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          searchInputField(),
          Expanded(
            child: ListView.builder(
              itemCount: products.isEmpty ? 1 : products.length, // จำนวนรายการทั้งหมด
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SizedBox(
                        width: 10.0,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          color: Color(0XFFE35205),
                          strokeWidth: 2.0,
                        ),
                      )),
                      SizedBox(width: 10),
                      Text(
                        'กำลังค้นหารายการสินค้า...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  );
                }
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'ไม่พบรายการสินค้า',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 22.0, right: 22.0),
                      // leading: Icon(Icons.star), // ใส่ไอคอนที่จะแสดง
                      title: Text(
                        products[index].product_name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ), // ข้อความที่จะถูกแสดงในรายการ
                      subtitle: Text(
                        'Subtitle for ${products[index].product_description}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ), // ข้อความย่อย
                      onTap: () {
                        Navigator.pushNamed(context, '/productdetail/${products[index].id}');
                        print('aaa $index');
                      },
                    ),
                    const Divider(height: 0),
                  ],
                );
              },
            ),
            // ListView(children: [
            //   ListTile(
            //     dense: true,
            //     contentPadding: const EdgeInsets.only(left: 20.0),
            //     // leading: const Icon(Icons.edit, color: Colors.grey),
            //     title: const Text(
            //       ' เรียงตามราคา (สูงไปต่ำ)',
            //       style: TextStyle(fontSize: 15, color: Colors.black),
            //       maxLines: 1,
            //     ),
            //     onTap: () {
            //       print('aaa 0');
            //     },
            //   ),
            //   const Divider(height: 0),
            //   ListTile(
            //     dense: true,
            //     contentPadding: const EdgeInsets.only(left: 20.0),
            //     // leading: const Icon(Icons.edit, color: Colors.grey),
            //     title: const Text(
            //       ' เรียงตามราคา (สูงไปต่ำ)',
            //       style: TextStyle(fontSize: 15, color: Colors.black),
            //       maxLines: 1,
            //     ),
            //     onTap: () {
            //       print('aaa 0');
            //     },
            //   ),
            //   const Divider(height: 0),
            // ]),
          )
        ])
            // child: Stack(
            //   children: [
            //     SingleChildScrollView(
            //       child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งให้อยู่บน-ล่าง
            //           children: [
            //         //const SearchInputField()
            //       ]
            //       )
            //     )
            //   ]
            // )
            ));
  }

  Widget searchInputField() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 10),
        child: TextField(
          focusNode: _focusNode,
          onChanged: (value) {
            setState(() {
              print('zzz $value');
              _loadnew(value);
            });
          },
          decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 8.0), // Adjust the padding value as needed
                child: SvgPicture.asset(
                  'assets/icons/search-line.svg',
                  width: 10.0, // Icon width
                  height: 10.0, // Icon height
                ),
              ), // ไอคอนแว่นขยาย
              hintText: 'ค้นหาสิ่งที่คุณต้องการ',
              hintStyle: const TextStyle(
                color: Color(0xFFA5A9B6), // Set the hintText color
                fontSize: 16.0,
              ),
              //enabledBorder: const OutlineInputBorder(
              //  borderSide: BorderSide(width: 2, color: Color(0xFFDFE2EC)), //<-- SEE HERE
              //),
              filled: true, // เปิดใช้งานพื้นหลัง
              fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the border radius
                borderSide: BorderSide(
                  width: 2.0, // Set border width
                  color: Color(0xFFDFE2EC), // Set border color
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Same radius for focused border
                borderSide: BorderSide(
                  width: 2.0,
                  color: Color.fromARGB(255, 174, 180, 192), // Border color when focused
                ),
              )),
        ),
      ),
    );
  }
}
