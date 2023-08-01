import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/screens/transaction/payment/payment_main_page.dart';
import 'package:sfa_tools/screens/transaction/reporting/report_main_page.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/taking_order_vendor_main_page.dart';

class BottomBartransaction extends StatelessWidget {
  BottomBartransaction({super.key});

  List<Widget> _buildScreens() {
    return [TakingOrderVendorMainPage(), PaymentMainPage(), ReportMainPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_bag),
        title: ("Penjualan"),
        // textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: AppConfig.mainCyan,
        activeColorSecondary: AppConfig.mainCyan,
        inactiveColorPrimary: Color(0XFF3c3c3c),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.payment_rounded),
        title: ("Pembayaran"),
        // textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: AppConfig.mainCyan,
        activeColorSecondary: AppConfig.mainCyan,
        inactiveColorPrimary: Color(0XFF3c3c3c),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.book),
        title: ("Laporan"),
        activeColorSecondary: AppConfig.mainCyan,
        activeColorPrimary: AppConfig.mainCyan,
        inactiveColorPrimary: Color(0XFF3c3c3c),
      ),
    ];
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      navBarHeight: 0.08 * Get.height,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xFFeaeaea), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}
