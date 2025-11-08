import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/test_provider.dart';
import '../utils/pages.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late double deviceHeight;
  late double deviceWidth;
  int currentpage = 0;
  bool isloading = true;
  Map<String, dynamic>? userData;

  String photo =
      'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1114445501.jpg';

  @override
  void initState() {
    super.initState();
    loaduserdata();
  }

  loaduserdata() async {
    try {
      // ignore: await_only_futures
      final user = await Provider.of<userdataprovider>(context, listen: false)
          .userdata();

      setState(() {
        userData = user as Map<String, dynamic>;
        isloading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    if (isloading) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Show loading spinner while data is loading
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Handle case where no data is available
      );
    }
    photo = userData!['photoUrl'];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pages[currentpage],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentpage,
          onTap: (value) {
            currentpage = value;
            setState(() {});
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buttomUserPhoto(photo),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget buttomUserPhoto(String photo) {
    return CircleAvatar(
      radius: 12,
      backgroundImage: NetworkImage(photo),
    );
  }

  Future<bool> _onWillPop() async {
    // Show a confirmation dialog or perform other actions
    // Returning true will close the app, false will prevent it
    bool shouldExit = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Exit'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return shouldExit;
  }
}
