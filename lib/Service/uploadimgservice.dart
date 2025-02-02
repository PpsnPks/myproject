// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:myproject/auth_service.dart';
// import 'package:myproject/environment.dart';

// class UploadImgService {
//   // URL ของ API
//   final String url = "${Environment.baseUrl}/uploadimage";

//   // ฟังก์ชันสำหรับ register
//   Future<Map<String, dynamic>> uploadImg(
//     List<XFile> pickedFiles,
//   ) async {
//     String? token = await AuthService().getAccessToken();
//     try {
//       // Header
//       // Map<String, String> headers = {
//       //   "Accept": "application/json",
//       //   "Content-Type": "application/json",
//       // };

//       // Body
//       // List allImgPath = [];
//       for (var file in pickedFiles) {
//         // var body = {"image": file, "image_path": "/images"};

//         var request = http.MultipartRequest('POST', Uri.parse(url));
//         request.headers['Authorization'] = 'Bearer $token';
//         // Add the file with the key 'image'
//         request.files.add(await http.MultipartFile.fromPath('image', file.path));
//         // Add the image_path with the key 'image_path'
//         request.fields['image_path'] = '/images';

//         try {
//           var response = await request.send();

//           if (response.statusCode == 200) {
//             print('8888 $response');
//             // allImgPath.add(response.body);
//             // print('Upload successful');
//           } else {
//             return {
//               "success": false,
//               "message": "อัปโหลดรูปภาพล้มเหลว",
//             };
//             // print('Failed to upload. Status code: ${response.statusCode}');
//           }
//         } catch (e) {
//           return {
//             "success": false,
//             "message": "ไม่สามารถอัปโหลดรูปภาพ",
//           };
//           // print('Error occurred during upload: $e');
//         }
//       }
//       return {
//         "success": false,
//         "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
//       };
//       // POST Request
//       //   final response = await http.post(
//       //     Uri.parse(url),
//       //     headers: headers,
//       //     body: jsonEncode(body),
//       //   );

//       //   // ตรวจสอบสถานะของ Response
//       //   if (response.statusCode == 200) {
//       //     // แปลง JSON เป็น Map
//       //     final data = jsonDecode(response.body);
//       //     return {
//       //       "success": true,
//       //       // "data": jsonDecode(response.body),
//       //       "data": data, // รับข้อมูล user_id และอื่นๆ จาก API
//       //     };
//       //   } else {
//       //     // กรณีเกิดข้อผิดพลาดจาก API
//       //     return {
//       //       "success": false,
//       //       "message": jsonDecode(response.body)['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
//       //     };
//       //   }
//     } catch (e) {
//       // กรณีเกิดข้อผิดพลาดทั่วไป
//       return {
//         "success": false,
//         "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
//       };
//     }
//   }
// }
