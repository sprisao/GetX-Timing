import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style/theme.dart';

class AppbarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWithLogo({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Image.asset('assets/logo.png', height: 32, fit: BoxFit.cover),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: ColorTheme.inactiveIcon, width: 0.2),
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: ColorTheme.activeIcon,
            weight: 0.5,
          ),
        ),
        const SizedBox(width: 16)
      ],
    );
  }
}

class AppbarWithOutLogo extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;

  const AppbarWithOutLogo({
    Key? key,
    required this.leading,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: leading,
    );
  }
}
