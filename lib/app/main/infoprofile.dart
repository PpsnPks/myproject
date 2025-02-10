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
  String pic = '-';
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
        pic = userData['pic'];
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
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(pic)
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
          Padding(
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
                    name,
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
        ],
      ),
    );
  }
}
