import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:aplikasi_perpustakaan/env.dart';
import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_perpustakaan/utils/HandleResponse.dart';

class AuthenticationModel{
  static Future login(String username, String password) async{
    GetStorage box = GetStorage();
    try{
      final Uri url = ApiRoute.loginRoute;

      var response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'x-api-key': ApiRoute.API_KEY
      },body: json.encode({
        "email": username,
        "password": password
      }));

      var data = json.decode(response.body);

      if(data?['meta']?['success']){
        print("success");
        box.write('dataLogin', data['data']);
      }

      return data;
    }catch(e){
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future logout() async{
    GetStorage box = GetStorage();
    try{
      final Uri url = ApiRoute.logoutRoute;

      var response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "x-api-key": ApiRoute.API_KEY,
        "Authorization": "Bearer ${box.read('dataLogin')['access_token']}"
      });

      var data = json.decode(response.body);
      return data;
    }catch(e){
      return HandleResponse.failResponse(e.toString());
    }
  }
}