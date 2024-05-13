import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:aplikasi_perpustakaan/pages/admin/AdminBase.dart';
import 'package:aplikasi_perpustakaan/pages/auth/LoginPage.dart';
import 'package:aplikasi_perpustakaan/pages/user/UserBase.dart';

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
  static const String userPageRoute = UserBase.routeName;

  static Map<String, WidgetBuilder> routes = {
    loginRoute: (context) => LoginPage(),
    adminHomeRoute: (context) => AdminBase(),
    userPageRoute: (context) => UserBase(),
  };
}