import 'package:flutter/material.dart';
import 'package:ogchat/screens/add_post_screen.dart';
import 'package:ogchat/screens/feed_screen.dart';
import 'package:ogchat/screens/search_screen.dart';

const webScreenSize = 600;

const HomeScreenItems = [
  FeedScreen(),
  AddPostScreen(),
  Text('Chat'),
  SearchScreen(),
];
