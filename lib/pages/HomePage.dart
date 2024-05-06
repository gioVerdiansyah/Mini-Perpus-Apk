import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget{
  HomePage({super.key});
  static const String routeName = "/";

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Text("Hello ini homepage"),
    );
  }
}