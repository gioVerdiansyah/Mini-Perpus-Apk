import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_perpus_up/pages/admin/AdminBookPage.dart';
import 'package:mini_perpus_up/pages/admin/AdminHomePage.dart';
import 'package:mini_perpus_up/pages/admin/AdminCustomerPage.dart';
import 'package:mini_perpus_up/pages/admin/AdminRentPage.dart';
import 'package:mini_perpus_up/pages/components/AppBarComponent.dart';
import 'package:mini_perpus_up/pages/lib/CurvedNavigationBar.dart';

class AdminBase extends StatefulWidget {
  AdminBase({super.key});

  static const String routeName = "/";

  @override
  State<AdminBase> createState() => _AdminHomeView();
}

class _AdminHomeView extends State<AdminBase> {
  final _pageController = PageController();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  // @override
  // void dispose() {
  //   _pageController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBarComponent(),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            AdminHomePage(
              navState: _bottomNavigationKey.currentState,
            ),
            AdminPelangganPage(),
            AdminBukuPage(),
            AdminSewaPage()
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: const Color.fromRGBO(115, 68, 255, 1),
          buttonBackgroundColor: const Color.fromRGBO(212, 199, 255, 1),
          color: const Color.fromRGBO(115, 68, 255, 1),
          activeButtonLabelColor: Colors.white,
          activeButtonColor: Colors.white,
          height: 60,
          items: [
            CurvedNavigationBarItem(
              label: "Home",
              icon: const Icon(
                Icons.home,
                size: 35,
                color: Color.fromRGBO(212, 199, 255, 1),
              ),
            ),
            CurvedNavigationBarItem(
              label: "Pelanggan",
              icon: const Icon(
                Icons.person,
                size: 35,
                color: Color.fromRGBO(212, 199, 255, 1),
              ),
            ),
            CurvedNavigationBarItem(
              label: "Buku",
              icon: const Icon(
                Icons.book,
                size: 35,
                color: Color.fromRGBO(212, 199, 255, 1),
              ),
            ),
            CurvedNavigationBarItem(
              label: "Sewa",
              icon: const Icon(
                Icons.collections_bookmark_outlined,
                size: 35,
                color: Color.fromRGBO(212, 199, 255, 1),
              ),
            ),
          ],
          onTap: (index) =>
              {_pageController.animateToPage(index, duration: Duration(milliseconds: 1000), curve: Curves.easeOut)},
        ),
      ),
    );
  }
}
