import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:instagramer/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class CommentScrean extends StatefulWidget {
  final userdata;
  const CommentScrean({super.key, this.userdata});

  @override
  State<CommentScrean> createState() => _CommentScreanState();
}

class _CommentScreanState extends State<CommentScrean> {
  bool isloading = true;
  Map<String, dynamic>? userData;
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
  void initState() {
    super.initState();
    loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.userdata['postid'])
            .collection('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var user = snapshot.data!.docs[index].data();

                bool commentliked =
                    (user['likes'] as List).contains(userData!['uid']);

                int commentslikes = (user['likes'] as List).length;
                return ListTile(
                  trailing: Column(
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: commentliked
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          onPressed: () async {
                            await FirestoreMethods().likecomment(
                                widget.userdata['postid'],
                                user['commentid'],
                                userData!['uid'],
                                user['likes']);
                          },
                        ),
                      ),
                      Text(commentslikes.toString())
                    ],
                  ),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 8),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user['userphoto']),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              user['username'],
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blue[400]),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              textAlign: TextAlign.start,
                              user['caption'],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 40, 71, 97)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: bottumnavigationbar(userData, widget.userdata['postid']),
      ),
    );
  }
}

Widget bottumnavigationbar(Map<String, dynamic>? userData, String postid) {
  TextEditingController captioncontroller = TextEditingController();

  if (userData == null) {
    return const Center(
      child: Text('loading user data'),
    );
  }
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            userData['photoUrl'],
          ),
        ),
      ),
      Expanded(
        flex: 9,
        child: TextField(
          controller: captioncontroller,
          decoration: const InputDecoration(hintText: 'enter comment'),
        ),
      ),
      Expanded(
        flex: 1,
        child: IconButton(
          onPressed: () async {
            await FirestoreMethods().addcomment(postid, userData['username'],
                userData['photoUrl'], captioncontroller.text);
          },
          icon: const Icon(Icons.send),
        ),
      )
    ],
  );
}
