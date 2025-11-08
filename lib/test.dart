import 'package:flutter/material.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:provider/provider.dart';

class testpage extends StatefulWidget {
  const testpage({super.key});

  @override
  State<testpage> createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<userdataprovider>(context).userdata();

    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          var data = snapshot.data as Map<String, dynamic>;
          return Text(data['username']);
        },
      )),
    );
  }
}
