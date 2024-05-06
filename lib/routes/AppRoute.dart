import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_perpus_up/pages/admin/AdminBase.dart';
import 'package:mini_perpus_up/pages/admin/create/BookCreatePage.dart';
import 'package:mini_perpus_up/pages/admin/edit/BookEditPage.dart';
import 'package:mini_perpus_up/pages/auth/LoginPage.dart';

class AppRoute{
  static String INITIAL = hasLogin();
  static GetStorage box = GetStorage();

  static String hasLogin(){
    var dataLogin = box.read('dataLogin');
    if(dataLogin != null){
      return AdminBase.routeName;
    }else{
      return LoginPage.routeName;
    }
  }

  // Routes Name
  static const String loginRoute = LoginPage.routeName;
  static const String adminHomeRoute = AdminBase.routeName;

  static Map<String, WidgetBuilder> routes = {
    loginRoute: (context) => LoginPage(),
    adminHomeRoute: (context) => AdminBase(),
  };
}