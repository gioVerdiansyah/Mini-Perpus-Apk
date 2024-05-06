import 'package:flutter/material.dart';
import 'package:mini_perpus_up/routes/AppRoute.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}
class MainApp extends StatelessWidget{
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Mini Perpus",
      initialRoute: AppRoute.INITIAL,
      routes: AppRoute.routes,
    );
  }
}