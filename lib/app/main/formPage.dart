import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/Service/uploadimgservice.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/Service/formservice.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  String? selectedFaculty;
  String? selectedDepartment;
  String? selectedYear;

  String? _base64Image;

  final List<String> faculties = [
  'คณะวิศวกรรมศาสตร์',
  'คณะสถาปัตยกรรม ศิลปะและการออกแบบ / คณะสถาปัตยกรรมศาสตร์',
  'คณะครุศาสตร์อุตสาหกรรมและเทคโนโลยี',
  'คณะเทคโนโลยีการเกษตร',
  'คณะวิทยาศาสตร์',
  'คณะเทคโนโลยีสารสนเทศ',
  'คณะอุตสาหกรรมอาหาร',
  'คณะบริหารธุรกิจ',
  'วิทยาลัยเทคโนโลยีและนวัตกรรมวัสดุ',
  'วิทยาลัยนวัตกรรมการผลิตขั้นสูง',
  'วิทยาลัยอุตสาหกรรมการบินนานาชาติ',
  'คณะศิลปศาสตร์',
  'คณะแพทยศาสตร์',
  'วิทยาลัยวิศวกรรมสังคีต',
  'คณะทันตแพทยศาสตร์',
  'วิทยาลัยการจัดการนวัตกรรมและอุตสาหกรรม',
  'วิทยาเขตชุมพรเขตรอุดมศักดิ์',
  'สถาบันโคเซ็นแห่งสถาบันเทคโนโลยีพระจอมเกล้าเจ้าคุณทหารลาดกระบัง',
  'นักศึกษาแลกเปลี่ยน',
  '42 Bangkok',
];
  final List<String> departments = [
    'วิศวกรรมการวัดและควบคุม', 
    'วิศวกรรมคอมพิวเตอร์',
    'วิศวกรรมเครื่องกล',
    'วิศวกรรมเคมี',
    'วิศวกรรมไฟฟ้า',
    'วิศวกรรมอุตสาหการ',
    'วิศวกรรมอาหาร',
    'วิศวกรรมอิเล็กทรอนิกส์',
    'วิศวกรรมโทรคมนาคม',
    'วิศวกรรมโยธา',
    'วิศวกรรมเกษตร',
    'Biomedical Engineering',
    'Computer Engineering',
    'Mechanical Engineering',
    'Chemical Engineering',
    'Civil Engineering',
    'Industrial Engineering',
    'Multidisciplinary Engineering'
    ];
  final List<String> years = ['ปี 1', 'ปี 2', 'ปี 3', 'ปี 4'];

  int currentStep = 0;
  late final XFile image;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = (await picker.pickImage(source: ImageSource.gallery))!;

    if (image != null) {
      final Uint8List bytes = await image!.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _submitForm() async {
  var response = await UploadImgService().uploadImg(image);
  var imgPath = '';
  if (response['success']) {
    imgPath = response['image'];
  }
  if (_validateForm()) {
    UserService formService = UserService();
    String role = 'buy';
    String guidetag = '';
    final result = await formService.form(
      '${firstNameController.text} ${lastNameController.text}',
      imgPath,
      emailController.text,
      phoneController.text,
      'N/A', // Address field
      selectedFaculty ?? '',
      selectedDepartment ?? '',
      selectedYear ?? '',
      role,
      guidetag,
    );

    if (result['success'] == true) {
      print('บันทึกข้อมูลสำเร็จ: ${result["data"]}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกข้อมูลสำเร็จ: ${result["data"]}')),
      );

      // 🔹 เปลี่ยนเส้นทางไปที่ tagform พร้อมส่งข้อมูล
      Navigator.pushNamed(
        context,
        '/tagform',
        arguments: {
          'name': '${firstNameController.text} ${lastNameController.text}',
          'imgPath': imgPath,
          'email': emailController.text,
          'phone': phoneController.text,
          'faculty': selectedFaculty ?? '',
          'department': selectedDepartment ?? '',
          'year': selectedYear ?? '',
          'role': role,
        },
      );
    } else {
      print('เกิดข้อผิดพลาด: ${result["message"]}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${result["message"]}')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
    );
  }
}


  bool _validateForm() {
    return phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        selectedFaculty != null &&
        selectedDepartment != null &&
        selectedYear != null;
  }

  void _nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      print('before submit form');
      _submitForm(); // Navigate to role selection at the final step
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กรอกข้อมูลส่วนตัว'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Color(0XFFE35205)),
          // sliderTheme: StepperThemeData(
          //   connectorColor: MaterialStateProperty.all(Color(0XFFE35205)),
          // ),
        ),
        child: Stepper(
          currentStep: currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: currentStep == 2 ? const EdgeInsets.only(top: 20.0, right: 48.0) : const EdgeInsets.only(top: 20.0), //
              child: Row(
                mainAxisAlignment: currentStep == 2 ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  if (currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('ย้อนกลับ'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0XFFE35205),
                        side: const BorderSide(color: Color(0XFFE35205)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFE35205),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(currentStep == 2 ? 'เริ่มต้นใช้งาน' : 'ถัดไป'),
                  ),
                ],
              ),
            );
          },
          stepIconBuilder: (stepIndex, stepState) {
            return CircleAvatar(
              backgroundColor: const Color(0XFFE35205), // เปลี่ยนสีพื้นหลังของตัวเลข
              child: Text(
                '${stepIndex + 1}',
                style: const TextStyle(color: Colors.white), // เปลี่ยนสีตัวเลขเป็นสีขาว
              ),
            );
          },
          steps: [
            Step(
              title: const Text('ข้อมูลติดต่อ'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('กรุณากรอกข้อมูลติดต่อ'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'เบอร์โทรศัพท์*',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              isActive: currentStep >= 0,
            ),
            Step(
              title: const Text('ข้อมูลส่วนตัว'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('กรุณากรอกข้อมูลส่วนตัว'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อ*',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'นามสกุล*',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedFaculty,
                    items: faculties.map((faculty) => DropdownMenuItem(value: faculty, child: Text(faculty))).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFaculty = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'คณะ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDepartment,
                    items: departments.map((department) => DropdownMenuItem(value: department, child: Text(department))).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'ภาควิชา',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedYear,
                    items: years.map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'ชั้นปี',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              isActive: currentStep >= 1,
            ),
            Step(
              title: const Text('โปรไฟล์'),
              content: Padding(
                padding: const EdgeInsets.only(right: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('กรุณาอัปโหลดรูปโปรไฟล์'),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _base64Image == null
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                                size: 50,
                              ),
                            )
                          : ClipOval(
                              child: Image.memory(
                                base64Decode(_base64Image!),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              isActive: currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}
