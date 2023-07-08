import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ogchat/models/user.dart' as model;
import 'package:ogchat/providers/user_provider.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/widgets/post_card.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Rucades',
          style: TextStyle(
              fontSize: 30,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        height: 50,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 0
                      ? Color.fromARGB(255, 51, 122, 31)
                      : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 1
                      ? Color.fromARGB(255, 51, 122, 31)
                      : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.message,
                  color: _page == 2
                      ? Color.fromARGB(255, 51, 122, 31)
                      : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 3
                      ? Color.fromARGB(255, 51, 122, 31)
                      : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
