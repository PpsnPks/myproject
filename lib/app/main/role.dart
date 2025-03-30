import 'package:flutter/material.dart';
import 'package:myproject/Service/customerservice.dart';
import 'package:myproject/app/main/secureStorage.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  _saveUserdata() async {
    print('data start');
    await CustomerService().getUserByMyID();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _saveUserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 247, 236), Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'คุณสนใจที่จะเป็น',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.person_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Securestorage().writeSecureData('role', 'buy');
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('คนซื้อ'),
                    ),
                  ),
                  const SizedBox(width: 20), // เพิ่มระยะห่างระหว่างปุ่ม
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Securestorage().writeSecureData('role', 'sell');

                        Navigator.pushNamed(context, '/post');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('คนขาย'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
