// import 'package:flutter/material.dart';
// import 'package:myproject/Service/confirmservice.dart';
// import 'package:myproject/app/buyer/buyerfooter.dart';
// import 'package:myproject/app/main/secureStorage.dart';
// import 'package:myproject/service/likeservice.dart';

// class Confirm extends StatefulWidget {
//   const Confirm({super.key});

//   @override
//   State<Confirm> createState() => _ConfirmState();
// }

// class _ConfirmState extends State<Confirm> {
//   late Future<List<ProductLike>> likedProducts;
//   final userId = Securestorage().readSecureData('userId');
//   // late Future<List<Confirm>> confirmData;
// //  final Confirm confirmData = Confirmservice.getConfirm();

//   @override
//   void initState() {
//     super.initState();
//     // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
//     likedProducts = LikeService().getLikedProducts();
//   }

//   Widget buildStatusMessage() {
//     final confirmData = Confirmservice.getConfirm();
//     if (confirmData.status == '1') {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('รออนุมัติ',
//               style: TextStyle(color: Color(0XFFE35205), fontSize: 16)),
//         ),
//       );
//     } else if (confirmData.status == '2') {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('รอนัดรับสินค้า',
//                   style: TextStyle(color: Color(0XFFE35205), fontSize: 16)),
//               const SizedBox(height: 20),
//               const Text('วันนัดรับสินค้า',
//                   style: TextStyle(
//                       color: Color.fromARGB(255, 0, 0, 0),
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold)),
//               Text(
//                 confirmData.date,
//                 style: const TextStyle(color: Color(0XFFE35205), fontSize: 16),
//               ),
//               const SizedBox(height: 20), // เว้นระยะระหว่างบรรทัด
//               const Text('สถานที่นัดรับสินค้า',
//                   style: TextStyle(
//                       color: Color.fromARGB(255, 0, 0, 0),
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold)),
//               Text(
//                 confirmData.place,
//                 style: const TextStyle(color: Color(0XFFE35205), fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (confirmData.status == '3') {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('ยืนยันการรับสินค้า',
//               style: TextStyle(color: Color(0XFFE35205), fontSize: 16)),
//         ),
//       );
//     } else if (confirmData.status == '4') {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('ได้รับสินค้าเเล้ว',
//               style: TextStyle(color: Color(0XFFE35205), fontSize: 16)),
//         ),
//       );
//     } else {
//       return const SizedBox.shrink(); // กรณีไม่ตรงตามสถานะที่กำหนด
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final confirmData = Confirmservice.getConfirm();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("รายละเอียดการสั่งสินค้า"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: FutureBuilder<List<ProductLike>>(
//         future: likedProducts,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('ไม่มีสินค้าที่ถูกใจ'));
//           } else {
//             final product = snapshot.data![0]; // ใช้สินค้าชิ้นแรกเท่านั้น
//             return Column(
//               children: [
//                 // ส่วนแสดงสินค้าที่สั่ง
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 7.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white, // Background color
//                     border: Border.all(
//                         color: Colors.grey.shade300, width: 2), // Gray border
//                     borderRadius: BorderRadius.circular(12), // Rounded corners
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.asset(
//                             product.imageUrl,
//                             width: 105,
//                             height: 105,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Flexible(
//                           fit: FlexFit.loose,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 product.title,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     height: 1.6),
//                                 maxLines: 1,
//                               ),
//                               // const SizedBox(height: 4),
//                               Container(
//                                 constraints:
//                                     const BoxConstraints(minHeight: 57.0),
//                                 child: Text(
//                                   product.detail,
//                                   style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 13,
//                                       height: 1.3),
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 3,
//                                 ),
//                               ),
//                               // const SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     // decoration: BoxDecoration(
//                                     //   color: Colors.grey[200],
//                                     //   borderRadius: BorderRadius.circular(4),
//                                     // ),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 4),
//                                     child: const Text(
//                                       '', // product.category
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.black,
//                                           height: 1.2),
//                                     ),
//                                   ),
//                                   Text(
//                                     '${product.price} ฿',
//                                     style: const TextStyle(
//                                         color: Color(0XFFE35205),
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         height: 1.0),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // // สถานะการสั่งสินค้า
//                 // const Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 //   child: Align(
//                 //     alignment: Alignment.centerLeft,
//                 //     child: Text('สถานะการสั่งสินค้า',
//                 //         style: TextStyle(
//                 //             fontSize: 18, fontWeight: FontWeight.bold)),
//                 //   ),
//                 // ),
//                 const SizedBox(height: 10),

//                 // แถบแสดงสถานะการสั่งสินค้า
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       StepCircle(
//                           number: '1',
//                           isActive: confirmData.status == '1' ||
//                               confirmData.status == '2' ||
//                               confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepLine(
//                           isActive: confirmData.status == '1' ||
//                               confirmData.status == '2' ||
//                               confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepCircle(
//                           number: '2',
//                           isActive: confirmData.status == '2' ||
//                               confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepLine(
//                           isActive: confirmData.status == '2' ||
//                               confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepCircle(
//                           number: '3',
//                           isActive: confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepLine(
//                           isActive: confirmData.status == '3' ||
//                               confirmData.status == '4'),
//                       StepCircle(
//                           number: '4', isActive: confirmData.status == '4'),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('สถานะการสั่งสินค้า',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 buildStatusMessage(),

//                 // if (confirmData.status == '3')
//                 // const Spacer(),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 //     children: [
//                 //       const SizedBox(width: 20),
//                 //       Expanded(
//                 //         child: ElevatedButton(
//                 //           onPressed: () {
//                 //             confirmData.status == '4';
//                 //           },
//                 //           style: ElevatedButton.styleFrom(
//                 //             padding: const EdgeInsets.symmetric(vertical: 20), // เพิ่มความสูงของปุ่ม
//                 //           ),
//                 //           child: const Text('ยกเลิก'),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(width: 20), // เว้นระยะระหว่างปุ่ม
//                 //       Expanded(
//                 //         child: ElevatedButton(
//                 //           onPressed: () {
//                 //             confirmData.status == '5';
//                 //           },
//                 //           style: ElevatedButton.styleFrom(
//                 //             padding: const EdgeInsets.symmetric(vertical: 20), // เพิ่มความสูงของปุ่ม
//                 //           ),
//                 //           child: const Text('ยืนยัน'),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(width: 20),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: buyerFooter(context, 'cart-buyer'),
//     );
//   }
// }

// class StepCircle extends StatelessWidget {
//   final String number;
//   final bool isActive;

//   const StepCircle({super.key, required this.number, required this.isActive});

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 20,
//       backgroundColor: isActive ? Colors.orange : Colors.grey[300],
//       child: Text(
//         number,
//         style: TextStyle(
//           color: isActive ? Colors.white : Colors.grey[600],
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// class StepLine extends StatelessWidget {
//   final bool isActive;

//   const StepLine({super.key, required this.isActive});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: 2,
//         color: isActive ? Colors.orange : Colors.grey[300],
//       ),
//     );
//   }
// }
