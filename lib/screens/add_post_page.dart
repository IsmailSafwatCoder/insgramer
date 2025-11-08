import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:instagramer/resources/firestore_methods.dart';
import 'package:instagramer/resources/storage_methods.dart';

import 'package:instagramer/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _image;
  bool isloading = false;
  String imageurl = '';
  final TextEditingController _captionController = TextEditingController();
  late double deviceHeight;
  late double deviceWidth;

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        isloading = true;
      });
      imageurl = await StorageMethods().uploadimage(_image);
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    var user = Provider.of<userdataprovider>(context).userdata();
    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data as Map<String, dynamic>;

          return SizedBox(
            height: deviceHeight * 0.83,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(data['photoUrl'],
                            scale: Checkbox.width),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        data['username'],
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                          child: TextField(
                        controller: _captionController,
                        decoration: InputDecoration(
                            hintText: 'caption',
                            hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 173, 183, 173)),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            fillColor: const Color.fromARGB(255, 219, 224, 227),
                            focusColor: Colors.amberAccent),
                      )),
                    ],
                  ),
                ),
                if (_image != null)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
                    child: SizedBox(
                        height: deviceHeight * 0.6,
                        width: deviceHeight * 0.6,
                        child: Image.file(_image!)),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.1,
                      vertical: deviceWidth * 0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_image != null) const Text('Change Photo'),
                      IconButton(
                          icon: const Icon(
                            Icons.photo_library,
                            size: 40,
                          ),
                          onPressed: _pickImage),
                    ],
                  ),
                ),
                isloading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FloatingActionButton(
                        onPressed: () async {
                          if (_image != null) {
                            setState(() {
                              isloading = true;
                            });
                            await FirestoreMethods().uploadPost(
                                data['photoUrl'],
                                _captionController.text,
                                data['username'],
                                imageurl);
                            setState(() {
                              isloading = false;
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Homepage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please pick an image")),
                            );
                          }
                        },
                        child: const Icon(Icons.send),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
