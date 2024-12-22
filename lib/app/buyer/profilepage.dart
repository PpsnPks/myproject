import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isBuyerSelected = false;
  bool isSellerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ฉัน"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile_pic.png'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ภูมิ ไพรศรี',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '640***@kmitl.ac.th',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '081-375-5536',
                      style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
            child: Row(
              children: [
                // Buyer Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = true;
                        isSellerSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBuyerSelected
                          ? const Color(0xFFE35205)
                          : const Color(0xFFFCEEEA), // Background color
                      foregroundColor: isBuyerSelected
                          ? Colors.white
                          : const Color(0xFFE35205), // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'คนซื้อ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between buttons
                // Seller Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = false;
                        isSellerSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSellerSelected
                          ? const Color(0xFFE35205)
                          : const Color(0xFFFCEEEA), // Background color
                      foregroundColor: isSellerSelected
                          ? Colors.white
                          : const Color(0xFFE35205), // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'คนขาย',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
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
            child: Text('ข้อมูลพื้นฐาน',
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
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
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text(
                  '081-***-5536',
                  style: TextStyle(fontSize: 13.0),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.email_outlined,
                      color: Color(0xFFA5A9B6)),
                  title: const Text(
                    'อีเมลหลัก',
                    style: TextStyle(fontSize: 13.0, color: Color(0xFFA5A9B6)),
                  ),
                  onTap: () {},
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text(
                  '640***@kmitl.ac.th',
                  style: TextStyle(fontSize: 13.0),
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
            child: Text('ข้อมูลส่วนตัว',
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ชื่อ',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
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
                  child: Text('นามสกุล',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
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
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('คณะ',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'วิศวกรรมศาสตร์',
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
                  child: Text('ภาควิชา',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'คอมพิวเตอร์',
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
                  child: Text('ชั้นปี',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    '4',
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('รหัสนักศึกษา',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    '64010681',
                    style: TextStyle(fontSize: 14.0),
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
            child: Text('ข้อมูลส่วนตัว',
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ที่อยู่',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFFA5A9B6))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'Rnp',
                    style: TextStyle(fontSize: 14.0),
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
          TextButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/login');
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'คุณต้องการออกจากระบบใช่หรือไม่',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color(0xFFE35205), // Text color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 20),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // ทำให้ปุ่มโค้งมน
                                ),
                              ),
                              child: const Text('ยืนยัน'),
                            ),
                            const SizedBox(width: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFE35205),
                                backgroundColor:
                                    const Color(0xFFFCEEEA), // Text color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 20),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // ทำให้ปุ่มโค้งมน
                                ),
                              ),
                              child: const Text('ยกเลิก'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Center(
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFE35205),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buyerFooter(context, 'profile'),
    );
  }
}
