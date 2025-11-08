import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:instagramer/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/post_card.dart';

class FeedPageScrean extends StatefulWidget {
  const FeedPageScrean({super.key});

  @override
  State<FeedPageScrean> createState() => _FeedPageScreanState();
}

class _FeedPageScreanState extends State<FeedPageScrean> {
  late double deviceHeight;
  late double deviceWidth;
  int lenght = 13;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: title(),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () async {
                await Provider.of<userdataprovider>(context, listen: false)
                    .signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              color: Colors.black,
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];

                return PostCard(
                  snap: post,
                );
              },
            );
          },
        ));
  }

  Widget title() {
    return SizedBox(
        height: deviceHeight * 0.06,
        width: deviceWidth * 0.3,
        child: SvgPicture.asset('assets/Instagram_logo.xml'));
  }
}
