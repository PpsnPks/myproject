import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart';

class WaitingLogin extends StatefulWidget {
  final String email;
  final String password;
  const WaitingLogin({super.key, required this.email, required this.password});

  @override
  State<WaitingLogin> createState() => _WaitingLoginState();
}

class _WaitingLoginState extends State<WaitingLogin> {
  void _login() async {
    print('start');
    final result = await LoginService().login(widget.email, widget.password);
    print('stop');
    if (result['success']) {
      if (result['first']) {
        print("First Time");
        Navigator.pushReplacementNamed(context, '/infoform');
      } else {
        print("NOt First Time");
        Navigator.pushReplacementNamed(context, '/role');
      }

      // Navigator.pushNamed(context, '/role'); // แก้ไขตาม route ของคุณ
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _login();
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
        child: Center(child: Image.asset('assets/images/logo.png', height: 250)),
      ),
    );
  }
}
