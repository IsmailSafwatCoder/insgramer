import 'package:flutter/material.dart';
import 'package:instagramer/custom/customfornfiled.dart';
import 'package:instagramer/resources/auth_methods.dart';
import 'package:instagramer/screens/homepage.dart';
import 'package:instagramer/screens/singup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  late double deviceHeight;
  late double deviceWidth;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _logoWidget(),
                SizedBox(height: deviceHeight * 0.08),
                _formWidget(),
                SizedBox(height: deviceHeight * 0.02),
                _loginButton(),
                SizedBox(height: deviceHeight * 0.02),
                _SingInButtonWithGoogle(),
                SizedBox(height: deviceHeight * 0.02),
                _forgotPasswordWidget(),
                SizedBox(height: deviceHeight * 0.04),
                _dividerWithOr(),
                SizedBox(height: deviceHeight * 0.04),
                _signUpWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoWidget() {
    return Image.network(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Instagram_logo_2022.svg/2048px-Instagram_logo_2022.svg.png',
      height: deviceHeight * 0.16,
    );
  }

  Widget _formWidget() {
    return Column(
      children: [
        CustomTextFormFieldAuth(
          hint: 'Enter email',
          obscureText: false,
          controller: emailController,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Email cannot be empty';
            }
            return null;
          },
        ),
        SizedBox(height: deviceHeight * 0.02),
        CustomTextFormFieldAuth(
          hint: 'Enter password',
          obscureText: true,
          controller: passwordController,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Password cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () async {
        String res = await AuthMethods().login(
            email: emailController.text, password: passwordController.text);
        if (res == 'succeed') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Homepage()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res)),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        minimumSize: Size(deviceWidth * 0.88, deviceHeight * 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Log In',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _SingInButtonWithGoogle() {
    return ElevatedButton(
      onPressed: () async {
        String res = await AuthMethods().signinWithGoogle(context);
        if (res == 'succeed') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Homepage()));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signed In With Google successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res)),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        minimumSize: Size(deviceWidth * 0.88, deviceHeight * 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'SingIn With Google',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _forgotPasswordWidget() {
    return GestureDetector(
      onTap: () {
        // Handle forgot password logic here
      },
      child: const Text(
        'Forgot password?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget _dividerWithOr() {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('OR'),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget _signUpWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SingUpPage()));
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
