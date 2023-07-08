import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ogchat/models/user.dart' as model;
import 'package:ogchat/providers/user_provider.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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
      body: PageView(
        children: HomeScreenItems,
        controller: pageController,
        onPageChanged: onPageChange,
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
