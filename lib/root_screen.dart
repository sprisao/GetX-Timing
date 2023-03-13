import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timing/style/theme.dart';
import 'package:timing/view/home_screen.dart';
import 'package:timing/view/like_screen.dart';
import 'package:timing/view/profile_screen.dart';
import 'package:timing/view/swipe_screen.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import 'my_flutter_app_icons.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false).currentUserId();
    Provider.of<TimingViewModel>(context, listen: false).initUser();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const SwipeScreen(),
      const LikeScreen(),
      const ProfileScreen(),
    ];

    return Consumer<TimingViewModel>(builder: (context, model, child) {
      return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcons.navi_icon_home,
                size: 45,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcons.navi_icon_timing,
                size: 45,
              ),
              label: 'Swipe',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcons.navi_icon_likes,
                size: 45,
              ),
              label: 'Like',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcons.navi_home_profile,
                size: 45,
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: ColorTheme.white,
          iconSize: 32,
          selectedItemColor: ColorTheme.activeIcon,
          unselectedItemColor: ColorTheme.inactiveIcon,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      );
    });
  }
}
