import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:instagramer/screens/feed_page_screan.dart';
import 'package:instagramer/screens/profile_screan.dart';
import 'package:instagramer/screens/saveposts_screen.dart';
import 'package:instagramer/screens/search_screan.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_page.dart';

List<Widget> pages = [
  const FeedPageScrean(),
  const SearchScrean(),
  const AddPostScreen(),
  const SavedPageScrean(),
  ProfileScrean(
    uid: FirebaseAuth.instance.currentUser?.uid ?? '',
  )
];
