import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playtorium_assignment/common/utils/colors.dart';
import 'package:playtorium_assignment/common/utils/global_variable.dart';
import 'package:playtorium_assignment/modules/home/pages/home_page.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: HomePage(),
        
      ),
    );
  }
}
