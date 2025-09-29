import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../aplication/configs/di/injection_container.dart';
import '../../data/data.dart';

class AppShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final token = sl<HiveLocalSource>().getToken();

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.only(top: 16.h, bottom: 16.h, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: token != null
              ? (navigationShell.currentIndex >= 2
                  ? navigationShell.currentIndex + 1
                  : navigationShell.currentIndex)
              : navigationShell.currentIndex,
          onTap: (index) {
            if (token != null && index == 2) {
              context.go("/posting");
            } else {
              final adjustedIndex =
                  token != null && index > 2 ? index - 1 : index;
              navigationShell.goBranch(adjustedIndex, initialLocation: true);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.tertiary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: const Color(0xff053D31),
              ),
          unselectedLabelStyle:
              Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
          items: [
            _navItem(
              "assets/icons/home.svg",
              "assets/icons/home_active.svg",
              'home'.tr(),
            ),
            _navItem(
              "assets/icons/category.svg",
              "assets/icons/category_active.svg",
              'Catalog'.tr(),
            ),
            if (token != null)
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/add.svg",
                  width: 36.w,
                  height: 36.h,
                ),
                label: "",
              ),
            _navItem(
              "assets/icons/message.svg",
              "assets/icons/message_active.svg",
              'Messages'.tr(),
            ),
            _navItem(
              "assets/icons/profile.svg",
              "assets/icons/profile_active.svg",
              'Profile'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      String iconPath, String activeIconPath, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: SvgPicture.asset(
          width: 24.w,
          height: 24.h,
          iconPath,
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: SvgPicture.asset(
          width: 24.w,
          height: 24.h,
          activeIconPath,
        ),
      ),
      label: label,
    );
  }
}
