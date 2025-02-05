import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class UploadImgService {
  // URL ของ API
  final String url = "${Environment.baseUrl}/uploadimage";

  // ฟังก์ชันสำหรับ register
  Future<Map<String, dynamic>> uploadImg(
    List<XFile> pickedFiles,
  ) async {
    String? token = await AuthService().getAccessToken();
    try {
      List allImgPath = [];
      for (var file in pickedFiles) {
        // var body = {"image": file, "image_path": "/images"};
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath('image', file.path));
        request.fields['image_path'] = '/images';

        try {
          http.Response response = await http.Response.fromStream(await request.send());

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            allImgPath.add(data['image_path']);
          } else {
            return {
              "success": false,
              "message": "อัปโหลดรูปภาพล้มเหลว ${response.statusCode}",
            };
            // print('Failed to upload. Status code: ${response.statusCode}');
          }
        } catch (e) {
          return {
            "success": false,
            "message": "ไม่สามารถอัปโหลดรูปภาพ",
          };
          // print('Error occurred during upload: $e');
        }
      }
      return {
        "success": true,
        "images": allImgPath,
      };
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดทั่วไป
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
      };
    }
  }
}
