import 'package:flutter/material.dart';
import 'package:instagramer/custom/customfornfiled.dart';
import 'package:instagramer/resources/auth_methods.dart';
import 'package:instagramer/screens/login_screen.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  late double deviceHeight;
  late double deviceWidth;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();

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
                _SingupButton(),
                SizedBox(height: deviceHeight * 0.02),
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
      height: deviceHeight * 0.12,
    );
  }

  Widget _formWidget() {
    return Column(
      children: [
        CustomTextFormFieldAuth(
          hint: 'Enter userName',
          obscureText: false,
          controller: usernamecontroller,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'username cannot be empty';
            }
            return null;
          },
        ),
        SizedBox(height: deviceHeight * 0.02),
        CustomTextFormFieldAuth(
          hint: 'Enter Email',
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
          hint: 'Enter Password',
          obscureText: true,
          controller: passwordController,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Password cannot be empty';
            }
            return null;
          },
        ),
        SizedBox(height: deviceHeight * 0.02),
        CustomTextFormFieldAuth(
          hint: 'Enter Bio',
          obscureText: false,
          controller: biocontroller,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'bio cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _SingupButton() {
    return ElevatedButton(
      onPressed: () async {
        String res = await AuthMethods().signUp(
            email: emailController.text,
            password: passwordController.text,
            username: usernamecontroller.text,
            bio: biocontroller.text);
        if (res == 'succeed') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          SnackBar(content: Text(res));
        } else {
          SnackBar(content: Text(res));
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
        'SingUp',
        style: TextStyle(color: Colors.white, fontSize: 18),
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
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
