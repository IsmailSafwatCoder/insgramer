import 'package:flutter/material.dart';
import 'package:instagramer/resources/auth_methods.dart';
import 'package:instagramer/screens/login_screen.dart';

class SignoutPage extends StatefulWidget {
  const SignoutPage({super.key});

  @override
  State<SignoutPage> createState() => _SignoutPageState();
}

class _SignoutPageState extends State<SignoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          AuthMethods().singout();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        child: Center(
          child: Title(color: Colors.blueGrey, child: const Text('signoyt ')),
        ),
      ),
    );
  }
}
