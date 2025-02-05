import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/Service/formservice.dart';
import 'package:myproject/app/main/secureStorage.dart';

class InfoProfile extends StatefulWidget {
  const InfoProfile({super.key});

  @override
  State<InfoProfile> createState() => _InfoProfileState();
}

class _InfoProfileState extends State<InfoProfile> {
  String hideEmail = '-';
  String hidePhone = '-';
  String studentID = '-';
  String name = '-';
  String faculty = '-';
  String department = '-';
  String classyear = '-';
  String address = '-';
  Future<void> getDataUser() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return const Center(
    //       child: SizedBox(
    //         height: 90.0, // กำหนดความสูง
    //         width: 90.0, // กำหนดความกว้าง
    //         child: CircularProgressIndicator(
    //           color: Color(0XFFE35205),
    //           strokeWidth: 12.0, // ปรับความหนาของวงกลม
    //           strokeCap: StrokeCap.round,
    //         ),
    //       ),
    //     );
    //   },
    // );
    final id = await Securestorage().readSecureData('userId');
    final response = await UserService().getUserById(int.parse(id));
    if (response['success']) {
      final userData = response['data'];
      setState(() {
        var phoneNumber = userData['mobile'];
        var email = userData['email'];
        hidePhone = '${phoneNumber.substring(0, 3)}-***-${phoneNumber.substring(6)}';
        hideEmail = '${email.substring(0, 3)}***${email.substring(6)}';
        studentID = '${email.substring(0, 8)}';
        name = userData['name'];
        faculty = userData['faculty'];
        department = userData['department'];
        classyear = userData['classyear'];
        address = userData['address'];
      });
    }
    // if (mounted) {
    //     Navigator.pop(context);
    //   }
  }

  @override
  void initState() {
    super.initState(); // กำหนดค่าเริ่มต้นให้ userData เป็น Future ที่ว่าง
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลส่วนตัว"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/a.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hideEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hidePhone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add buttons for Buyer and Seller
          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          //   child: Row(
          //     children: [
          //       // Buyer Button
          //       Expanded(
          //         child: ElevatedButton(
          //           onPressed: () {
          //             setState(() {
          //               isBuyerSelected = true;
          //               isSellerSelected = false;
          //             });
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: isBuyerSelected
          //                 ? const Color(0xFFE35205)
          //                 : const Color(0xFFFCEEEA), // Background color
          //             foregroundColor: isBuyerSelected
          //                 ? Colors.white
          //                 : const Color(0xFFE35205), // Text color
          //             padding: const EdgeInsets.symmetric(vertical: 16),
          //           ),
          //           child: const Text(
          //             'คนซื้อ',
          //             style: TextStyle(fontSize: 16),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 8), // Add spacing between buttons
          //       // Seller Button
          //       Expanded(
          //         child: ElevatedButton(
          //           onPressed: () {
          //             setState(() {
          //               isBuyerSelected = false;
          //               isSellerSelected = true;
          //             });
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: isSellerSelected
          //                 ? const Color(0xFFE35205)
          //                 : const Color(0xFFFCEEEA), // Background color
          //             foregroundColor: isSellerSelected
          //                 ? Colors.white
          //                 : const Color(0xFFE35205), // Text color
          //             padding: const EdgeInsets.symmetric(vertical: 16),
          //           ),
          //           child: const Text(
          //             'คนขาย',
          //             style: TextStyle(fontSize: 16),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            height: 8.0,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFDFE2EC),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('ข้อมูลพื้นฐาน', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Color(0xFFA5A9B6)),
                  title: const Text(
                    'เบอร์โทรศัพท์',
                    style: TextStyle(fontSize: 13.0, color: Color(0xFFA5A9B6)),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  hidePhone,
                  style: const TextStyle(fontSize: 13.0),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.email_outlined, color: Color(0xFFA5A9B6)),
                  title: const Text(
                    'อีเมลหลัก',
                    style: TextStyle(fontSize: 13.0, color: Color(0xFFA5A9B6)),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  hideEmail,
                  style: const TextStyle(fontSize: 13.0),
                ),
              )
            ],
          ),
          Container(
            height: 8.0,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFDFE2EC),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('ข้อมูลส่วนตัว', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ชื่อ', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'ภูมิ',
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('นามสกุล', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'ไพรศรี',
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('คณะ', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    faculty,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ภาควิชา', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    department,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ชั้นปี', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    classyear,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('รหัสนักศึกษา', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    studentID,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 8.0,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFDFE2EC),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('ข้อมูลส่วนตัว', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ที่อยู่', style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 8.0,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFDFE2EC),
          ),
          const SizedBox(height: 10.0),
          // TextButton(
          //   onPressed: () {
          //     // Navigator.pushNamed(context, '/login');
          //     showModalBottomSheet(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Container(
          //           padding: const EdgeInsets.all(16),
          //           height: 150,
          //           width: MediaQuery.of(context).size.width,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               const Text(
          //                 'คุณต้องการออกจากระบบใช่หรือไม่',
          //                 style: TextStyle(
          //                     fontSize: 24, fontWeight: FontWeight.w500),
          //               ),
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   ElevatedButton(
          //                     onPressed: () {
          //                       Navigator.pushNamed(context, '/login');
          //                     },
          //                     style: ElevatedButton.styleFrom(
          //                       foregroundColor: Colors.white,
          //                       backgroundColor:
          //                           const Color(0xFFE35205), // Text color
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 70, vertical: 20),
          //                       textStyle: const TextStyle(
          //                           fontSize: 16, fontWeight: FontWeight.w500),
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(
          //                             15), // ทำให้ปุ่มโค้งมน
          //                       ),
          //                     ),
          //                     child: const Text('ยืนยัน'),
          //                   ),
          //                   const SizedBox(width: 20.0),
          //                   ElevatedButton(
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                     style: ElevatedButton.styleFrom(
          //                       foregroundColor: const Color(0xFFE35205),
          //                       backgroundColor:
          //                           const Color(0xFFFCEEEA), // Text color
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 70, vertical: 20),
          //                       textStyle: const TextStyle(
          //                           fontSize: 16, fontWeight: FontWeight.w500),
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(
          //                             15), // ทำให้ปุ่มโค้งมน
          //                       ),
          //                     ),
          //                     child: const Text('ยกเลิก'),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   child: const Center(
          //     child: Text(
          //       'ออกจากระบบ',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Color(0xFFE35205),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
