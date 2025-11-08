import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramer/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../providers/like_provider.dart';
import '../providers/save_provider.dart';
import '../screens/comment_screan.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late double deviceHeight;
  late double deviceWidth;
  int commentlength = 0;

  loadcomment() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      commentlength = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  @override
  void initState() {
    super.initState();
    loadcomment();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    String uid = widget.snap['uid'];
    String username = widget.snap['username'];
    String userphoto = widget.snap['userphoto'];
    List<dynamic> likes = widget.snap['likes'];
    String postid = widget.snap['postid'];
    bool isliked = likes.contains(FirebaseAuth.instance.currentUser!.uid);
    bool saved = widget.snap['saved'];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userphoto),
                ),
              ),
              Text(username),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  )
                ],
                onSelected: (value) async {
                  if (uid == FirebaseAuth.instance.currentUser!.uid) {
                    if (value == 'delete') {
                      await FirestoreMethods().deletepost(postid);
                    }
                  }
                },
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.91,
                padding: const EdgeInsets.only(left: 25, top: 6, right: 6),
                child: Text(
                  widget.snap['caption'],
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: deviceWidth,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  widget.snap['postphoto'],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              colum(
                likes.length,
                isliked ? Icons.favorite : Icons.favorite_border,
                () async {
                  await Provider.of<LikeProvider>(context, listen: false)
                      .likepost(FirebaseAuth.instance.currentUser!.uid, postid,
                          likes);
                },
              ),
              colum(commentlength, Icons.flutter_dash, () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScrean(
                          userdata: widget.snap,
                        )));
              }),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      await Provider.of<SaveProvider>(context, listen: false)
                          .savepost(saved, postid);
                    },
                    icon: saved
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_border),
                  ),
                  const Text(
                    '',
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget colum(int number, IconData icon, Function()? onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 30,
          ),
        ),
        const SizedBox(
          height: 0,
        ),
        Text(number.toString(), textScaler: const TextScaler.linear(1))
      ],
    );
  }
}
