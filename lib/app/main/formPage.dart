import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/Service/uploadimgservice.dart';
import 'package:myproject/app/main/categoryform.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:myproject/app/main/role.dart';
import 'package:myproject/Service/formservice.dart';
import 'package:myproject/app/main/secureStorage.dart';

class PersonalInfoForm extends StatefulWidget {
  final String data;
  const PersonalInfoForm({super.key, required this.data});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isChecked = false;

  String? selectedFaculty;
  String? selectedDepartment;
  String? selectedYear;
  dynamic data = '';
  String tClass = '';
  String tFaculty = '';

  loadDepartment(String twoDigit) {
    dynamic temp = [];
    if (twoDigit == '01') {
      temp = departmentPerFaculty01;
    } else if (twoDigit == '02') {
      temp = departmentPerFaculty02;
    } else if (twoDigit == '03') {
      temp = departmentPerFaculty03;
    } else if (twoDigit == '04') {
      temp = departmentPerFaculty04;
    } else if (twoDigit == '05') {
      temp = departmentPerFaculty05;
    } else if (twoDigit == '07') {
      temp = departmentPerFaculty07;
    } else if (twoDigit == '08') {
      temp = departmentPerFaculty08;
    } else if (twoDigit == '09') {
      temp = departmentPerFaculty09;
    } else if (twoDigit == '10') {
      temp = departmentPerFaculty10;
    } else if (twoDigit == '11') {
      temp = departmentPerFaculty11;
    } else if (twoDigit == '12') {
      temp = departmentPerFaculty12;
    } else if (twoDigit == '13') {
      temp = departmentPerFaculty13;
    } else if (twoDigit == '14') {
      temp = departmentPerFaculty14;
    } else if (twoDigit == '15') {
      temp = departmentPerFaculty15;
    } else if (twoDigit == '16') {
      temp = departmentPerFaculty16;
    } else if (twoDigit == '17') {
      temp = departmentPerFaculty17;
    } else if (twoDigit == '18') {
      temp = departmentPerFaculty18;
    } else if (twoDigit == '20') {
      temp = departmentPerFaculty20;
    } else if (twoDigit == '21') {
      temp = departmentPerFaculty21;
    } else if (twoDigit == '22') {
      temp = departmentPerFaculty22;
    } else if (twoDigit == '23') {
      temp = departmentPerFaculty23;
    } else if (twoDigit == '95') {
      temp = departmentPerFaculty95;
    } else if (twoDigit == '42') {
      temp = departmentPerFaculty42;
    }
    setState(() {
      departments = temp;
    });
  }

  _loaddata() async {
    if (widget.data != '') {
      print('kkk11');
      data = jsonDecode(widget.data);
      print(data);
      tClass = data['email'].substring(0, 2); // '64'
      tFaculty = data['email'].substring(2, 4); // '01'
      print('kkk2 ${data['email']}');
      print('kkk3 ${dataFaculty[tFaculty]}');
      // setState(() {
      emailController.text = data['email'];
      selectedFaculty = dataFaculty[tFaculty];
      print('kkk4');
      dynamic tempName = data['name'].split(' ');
      if (tempName.length >= 2) {
        print('kkk33 ${emailController.text}');

        firstNameController.text = tempName[0];
        lastNameController.text = tempName[1];
      } else if (tempName.length == 1) {
        print('kkk44 ${emailController.text}');
        firstNameController.text = tempName[0];
      } else {
        print('kkk55 $tempName');
      }
      // });
      print('kkk5 ${emailController.text}');
      print('kkk6 ${dataFaculty[tFaculty]}');
      loadDepartment(tFaculty);
      if (int.tryParse(tClass) != null) {
        int temp = ((DateTime.now().year + 543) % 100) - int.parse(tClass);
        if (DateTime.now().month < 6 && temp > 0) {
          // print("ขณะนี้เป็นเดือนก่อนมิถุนายน");
          // setState(() {
          selectedYear = years[temp - 1];
          // });
        } else {
          // setState(() {
          selectedYear = years[temp];
          // });
          // print("ขณะนี้เป็นเดือนมิถุนายนหรือหลังจากนั้น");
        }
      }
    } else {
      print('kkk22');
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _loaddata();
  }

  String? _base64Image;
  Map<String, String> dataFaculty = {
    '01': 'คณะวิศวกรรมศาสตร์',
    '02': 'คณะสถาปัตยกรรม ศิลปะและการออกแบบ / คณะสถาปัตยกรรมศาสตร์',
    '03': 'คณะครุศาสตร์อุตสาหกรรมและเทคโนโลยี',
    '04': 'คณะเทคโนโลยีการเกษตร',
    '05': 'คณะวิทยาศาสตร์',
    '07': 'คณะเทคโนโลยีสารสนเทศ',
    '08': 'คณะอุตสาหกรรมอาหาร',
    '09': 'วิทยาลัยนานาชาติ',
    '10': 'คณะบริหารธุรกิจ',
    '11': 'วิทยาลัยเทคโนโลยีและนวัตกรรมวัสดุ',
    '12': 'วิทยาลัยนวัตกรรมการผลิตขั้นสูง',
    '13': 'วิทยาลัยอุตสาหกรรมการบินนานาชาติ',
    '14': 'คณะศิลปศาสตร์',
    '15': 'คณะแพทยศาสตร์',
    '16': 'วิทยาลัยวิศวกรรมสังคีต',
    '17': 'คณะทันตแพทยศาสตร์',
    '18': 'วิทยาลัยการจัดการนวัตกรรมและอุตสาหกรรม',
    '20': 'วิทยาเขตชุมพรเขตรอุดมศักดิ์',
    '21': 'สถาบันโคเซ็นแห่งสถาบันเทคโนโลยีพระจอมเกล้าเจ้าคุณทหารลาดกระบัง',
    '22': 'คณะพยาบาลศาสตร์',
    '23': 'คณะเทคโนโลยีนวัตกรรมบูรณาการ',
    '95': 'นักศึกษาแลกเปลี่ยน',
    '42': '42 Bangkok',
  };
  final List<String> faculties = [
    'คณะวิศวกรรมศาสตร์',
    'คณะสถาปัตยกรรม ศิลปะและการออกแบบ / คณะสถาปัตยกรรมศาสตร์',
    'คณะครุศาสตร์อุตสาหกรรมและเทคโนโลยี',
    'คณะเทคโนโลยีการเกษตร',
    'คณะวิทยาศาสตร์',
    'คณะเทคโนโลยีสารสนเทศ',
    'คณะอุตสาหกรรมอาหาร',
    'วิทยาลัยนานาชาติ',
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
    'คณะพยาบาลศาสตร์',
    'คณะเทคโนโลยีนวัตกรรมบูรณาการ',
    'นักศึกษาแลกเปลี่ยน',
    '42 Bangkok',
  ];
  List<String> departments = [
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
  final List<String> years = ['ปี 1', 'ปี 2', 'ปี 3', 'ปี 4', 'อื่นๆ'];

  int currentStep = 0;
  late final XFile image;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = (await picker.pickImage(source: ImageSource.gallery))!;

    final Uint8List bytes = await image!.readAsBytes();
    setState(() {
      _base64Image = base64Encode(bytes);
    });
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
          const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')), //: ${result["data"]}
        );

        // 🔹 เปลี่ยนเส้นทางไปที่ tagform พร้อมส่งข้อมูล
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryFormPage(
              userData: {
                'name': '${firstNameController.text} ${lastNameController.text}',
                'imgPath': imgPath,
                'email': emailController.text,
                'phone': phoneController.text,
                'faculty': selectedFaculty ?? '',
                'department': selectedDepartment ?? '',
                'year': selectedYear ?? '',
                'role': role,
                'guidetag': null
              },
            ),
          ),
        );
      } else {
        print('เกิดข้อผิดพลาด: ${result["message"]}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${result["message"]}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลและเพิ่มรูปโปรไฟล์ให้ครบถ้วน')),
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

  void _nextStep() async {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      print('before submit form ${_base64Image != null} ${_formKey.currentState?.validate()}');
      if (_base64Image != null && _formKey.currentState!.validate()) {
        await _submitForm(); // Wait for the action to complete
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณากรอกข้อมูลและเพิ่มรูปโปรไฟล์ให้ครบถ้วน')),
        );
      }
      // Navigate to role selection at the final step
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
      body: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0XFFE35205)),
            // sliderTheme: StepperThemeData(
            //   connectorColor: MaterialStateProperty.all(Color(0XFFE35205)),
            // ),
          ),
          child: Stepper(
            currentStep: currentStep,
            onStepContinue: _nextStep,
            onStepCancel: _previousStep,
            controlsBuilder: (context, details) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (currentStep == 2)
                    const SizedBox(
                      height: 15.0,
                    ),
                  if (currentStep == 2)
                    SizedBox(
                      height: 45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 48.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                  // SizedBox(
                                  //   height: 4,
                                  // ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'ฉันตรวจสอบข้อมูลแล้ว',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Flexible(
                            child: Text(
                              '**โปรดตรวจสอบข้อมูลให้ถูกต้อง เนื่องจากไม่สามารถแก้ไขภายหลังได้**',
                              softWrap: true,
                              // maxLines: 2, // จำกัดให้แสดงแค่ 2 บรรทัด
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 8, color: Color(0xFFF44336)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: currentStep == 2 ? const EdgeInsets.only(top: 5.0, right: 30.0) : const EdgeInsets.only(top: 20.0), //
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
                          style: currentStep == 2 && isChecked == false
                              ? ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 227, 133, 82),
                                  foregroundColor: Colors.white,
                                )
                              : ElevatedButton.styleFrom(backgroundColor: const Color(0XFFE35205), foregroundColor: Colors.white),
                          child: Text(currentStep == 2 ? 'เริ่มต้นใช้งาน' : 'ถัดไป'),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'เบอร์โทรศัพท์*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณากรอกเบอร์โทรศัพท์" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
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
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อ*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณากรอกชื่อ" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'นามสกุล*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณากรอกนามสกุล" : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedFaculty,
                      items: faculties.map((faculty) => DropdownMenuItem(value: faculty, child: Text(faculty))).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = null;
                          selectedFaculty = value;
                          String? foundKey = dataFaculty.keys.firstWhere((key) => dataFaculty[key] == value, orElse: () => "ไม่พบ");
                          loadDepartment(foundKey);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'คณะ',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      isExpanded: true,
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกคณะ" : null,
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
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      isExpanded: true,
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกภาควิชา" : null,
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
                        errorStyle: TextStyle(
                          fontSize: 10,
                          // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                        ),
                      ),
                      isExpanded: true,
                      validator: (value) => (value == null || value.isEmpty) ? "กรุณาเลือกชั้นปี" : null,
                    ),
                  ],
                ),
                isActive: currentStep >= 1,
              ),
              Step(
                title: const Text('โปรไฟล์'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('กรุณาอัปโหลดรูปโปรไฟล์'),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: GestureDetector(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isActive: currentStep >= 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> departmentPerFaculty01 = [
    'วิศวกรรมโทรคมนาคม',
    'วิศวกรรมไฟฟ้า',
    'วิศวกรรมอิเล็กทรอนิกส์',
    'วิศวกรรมระบบควบคุม',
    'วิศวกรรมคอมพิวเตอร์',
    'วิศวกรรมเครื่องกล',
    'วิศวกรรมการวัดและควบคุม',
    'วิศวกรรมโยธา',
    'วิศวกรรมเกษตร',
    'วิศวกรรมเคมี',
    'วิศวกรรมอาหาร',
    'วิศวกรรมสารสนเทศ',
    'ยังไม่เลือกภาควิชา',
    'วิศวกรรมอุตสาหการ',
    'วิศวกรรมอัตโนมัติ',
    'วิศวกรรมป้องกันประเทศ',
    'วิศวกรรมการบินและนักบินพาณิชย์',
    'วิศวกรรมแมคคาทรอนิกส์',
    'วิศวกรรมชีวการแพทย์',
    'สำนักงานบริหารหลักสูตรวิศวกรรมสหวิทยาการนานาชาติ',
    'วิศวกรรมพลังงาน',
    'วิศวกรรมและการเป็นผู้ประกอบการ',
    'คณะวิศวกรรมศาสตร์ ไม่ประจำภาควิชา',
    'วิศวกรรมหุ่นยนต์และปัญญาประดิษฐ์',
  ];

  final List<String> departmentPerFaculty02 = [
    'สถาปัตยกรรมและการวางแผน',
    'สถาปัตยกรรมภายใน',
    'ศิลปอุตสาหกรรม',
    'นิเทศศิลป์',
    'วิจิตรศิลป์',
    'ศิลปกรรม',
    'สำนักงานบริหารหลักสูตรสถาปัตยกรรมสหวิทยาการนานาชาติ',
    'สถาปัตยกรรมอัจฉริยะและกระบวนการคิดเชิงออกแบบ',
  ];

  final List<String> departmentPerFaculty03 = [
    'ครุศาสตร์สถาปัตยกรรม',
    'ครุศาสตร์อุตสาหกรรม',
    'ครุศาสตร์วิศวกรรม',
    'ครุศาสตร์เกษตร',
    'ภาษาและสังคม',
    'สำนักงานนานาชาติครุศาสตร์อุตสาหกรรมและเทคโนโลยี',
  ];

  final List<String> departmentPerFaculty04 = [
    'บริหารธุรกิจเกษตร',
    'วิทยาศาสตร์การประมง',
    'พืชสวน',
    'เทคโนโลยีการผลิตพืช',
    'เทคโนโลยีการผลิตสัตว์',
    'นวัตกรรมการสื่อสารและพัฒนาการเกษตร',
    'ปฐพีวิทยา',
    'เทคโนโลยีการจัดการศัตรูพืช',
    'นิเทศศาสตร์เกษตร',
    'เกษตรศาสตร์',
    'พัฒนาการเกษตรและการจัดการทรัพยากร',
    'พัฒนาการเกษตร',
    'นวัตกรรมการสื่อสารและพัฒนาการเกษตร',
    'สำนักงานบริหารหลักสูตรสหวิทยาการเทคโนโลยีการเกษตร',
    'เทคโนโลยีการผลิตสัตว์และประมง',
  ];

  final List<String> departmentPerFaculty05 = [
    'คณิตศาสตร์และวิทยาการคอมพิวเตอร์',
    'เคมี',
    'ชีววิทยา',
    'ฟิสิกส์',
    'สถิติ',
    'วิทยาการคอมพิวเตอร์',
    'คณิตศาสตร์',
    'เทคโนโลยีชีวภาพ',
    'คณิตศาสตร์ประยุกต์',
    'ศูนย์วิเคราะห์ข้อมูลดิจิทัลอัจฉริยะพระจอมเกล้าลาดกระบัง',
  ];

  final List<String> departmentPerFaculty07 = [
    'เทคโนโลยีสารสนเทศ',
  ];

  final List<String> departmentPerFaculty08 = [
    //6
    'อุตสาหกรรมอาหาร',
  ];

  final List<String> departmentPerFaculty09 = [
    'วิทยาลัยนานาชาติ',
    'การจัดการวิศวกรรมและเทคโนโลยี',
    'วิศวกรรมซอฟต์แวร์',
  ];

  final List<String> departmentPerFaculty10 = [
    //12
    'บริหารธุรกิจ',
    'การจัดการ',
  ];

  final List<String> departmentPerFaculty11 = [
    //10
    'นาโนวิทยาและนาโนเทคโนโลยี',
  ];

  final List<String> departmentPerFaculty12 = [
    //11
    'เทคโนโลยีระบบการผลิต',
  ];

  final List<String> departmentPerFaculty13 = [
    //14
    'วิศวกรรมการบิน',
    'นวัตกรรมการจัดการอุตสาหกรรมการบินและการบริการ',
  ];

  final List<String> departmentPerFaculty14 = [
    //15
    'ภาษา',
    'มนุษยศาสตร์และสังคมศาสตร์',
  ];

  final List<String> departmentPerFaculty15 = [
    //16
    'แพทยศาสตรนานาชาติ',
  ];

  final List<String> departmentPerFaculty16 = [
    //18
    'วิศวกรรมดนตรีและสื่อประสม',
  ];

  final List<String> departmentPerFaculty17 = [
    //19
    'ไม่ระบุ',
  ];

  final List<String> departmentPerFaculty18 = [
    //17
    'วิทยาลัยวิจัยนวัตกรรมทางการศึกษา',
  ];

  final List<String> departmentPerFaculty20 = [
    'วิศวกรรมศาสตร์',
    'เทคโนโลยีการเกษตร',
    'พื้นฐานทั่วไป',
    'บริหารธุรกิจ',
  ];
  final List<String> departmentPerFaculty21 = [
    'สถาบันโคเซ็นแห่งสถาบันเทคโนโลยีพระจอมเกล้าเจ้าคุณทหารลาดกระบัง',
  ];
  final List<String> departmentPerFaculty22 = [
    'พยาบาลศาสตร์',
  ];
  final List<String> departmentPerFaculty23 = [
    'เทคโนโลยีระบบการผลิต',
    'นาโนวิทยาและนาโนเทคโนโลยี',
  ];
  final List<String> departmentPerFaculty95 = [
    'นักศึกษาแลกเปลี่ยน',
  ];
  final List<String> departmentPerFaculty42 = [
    '42 Bangkok',
  ];
}
