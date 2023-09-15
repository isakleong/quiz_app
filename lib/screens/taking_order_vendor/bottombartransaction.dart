import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/information/informasi_main_page.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/retur_main_page.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/payment_main_page.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/report_main_page.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/transaction_main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBartransaction extends StatelessWidget {
  BottomBartransaction({super.key});
final TakingOrderVendorController _takingOrderVendorController =
      Get.put(TakingOrderVendorController());
  List<Widget> _buildScreens() {
    return [
      TakingOrderVendorMainPage(),
      PaymentMainPage(),
      // ReturMainPage(),
      ReportMainPage(),
      InformasiMainPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_bag),
        title: ("Penjualan"),
        // textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: AppConfig.mainCyan,
        activeColorSecondary: AppConfig.mainCyan,
        inactiveColorPrimary: const Color(0XFF3c3c3c),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.payment_rounded),
        title: ("Pembayaran"),
        // textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: AppConfig.mainCyan,
        activeColorSecondary: AppConfig.mainCyan,
        inactiveColorPrimary: const Color(0XFF3c3c3c),
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.change_circle),
      //   title: ("Retur"),
      //   // textStyle: TextStyle(color: Colors.white),
      //   activeColorPrimary: AppConfig.mainCyan,
      //   activeColorSecondary: AppConfig.mainCyan,
      //   inactiveColorPrimary: const Color(0XFF3c3c3c),
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.book),
        title: ("Laporan"),
        activeColorSecondary: AppConfig.mainCyan,
        activeColorPrimary: AppConfig.mainCyan,
        inactiveColorPrimary: const Color(0XFF3c3c3c),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.info),
        title: ("Informasi"),
        activeColorSecondary: AppConfig.mainCyan,
        activeColorPrimary: AppConfig.mainCyan,
        inactiveColorPrimary: const Color(0XFF3c3c3c),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return PersistentTabView(
            context,
            navBarHeight: 0.08 * height,
            controller: _takingOrderVendorController.controllerBar,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor:
                const Color(0xFFeaeaea), // Default is Colors.white.
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
            navBarStyle: NavBarStyle
                .style3, // Choose the nav bar style with this property.
          );
        });
  }
}
