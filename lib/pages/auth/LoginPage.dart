import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_perpus_up/models/AuthenticationModel.dart';
import 'package:mini_perpus_up/pages/admin/AdminBase.dart';
import 'package:mini_perpus_up/routes/AppRoute.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static const String routeName = "/login";

  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginView();
}

class _LoginView extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 170),
                              child: const Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Selamat Datang di",
                                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Mini Perpus",
                                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Login dahulu~",
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1), fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2), blurRadius: 20.0, offset: Offset(0, 10))
                                ]),
                            child: FormBuilder(
                              key: widget._formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                                    child: FormBuilderTextField(
                                      name: "Username",
                                      controller: widget.username,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email or Phone number",
                                          hintStyle: TextStyle(color: Colors.grey[700])),
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FormBuilderTextField(
                                      name: "Password",
                                      obscureText: true,
                                      controller: widget.password,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey[700])),
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: TextButton(
                              onPressed: () async {
                                if (widget._formKey.currentState?.saveAndValidate() ?? false) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Processing "
                                        "Data"),
                                    backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                  ));

                                  var response =
                                      await AuthenticationModel.login(widget.username.text, widget.password.text);
                                  print(response);
                                  if(response['meta']['success']){
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoute.adminHomeRoute,
                                          (route) => false,
                                    );
                                  }else{
                                    ArtSweetAlert.show(context: context, artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.danger,
                                      title: "Ups, Something wrong!",
                                      text: response['meta']['message']
                                    ));
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("User Mode",
                                style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1))),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
