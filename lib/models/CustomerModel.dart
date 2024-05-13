import 'dart:convert';

import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';
import 'package:aplikasi_perpustakaan/utils/HandleResponse.dart';
import 'package:http/http.dart' as http;

class CustomerModel {
  static Future getCustomer(Uri? paginateUrl, String? value ) async {
    try {
      Uri url = paginateUrl ?? ApiRoute.getCustomerRoute;
      if(value != null) url = Uri.parse("${url}?query=${value}");
      var response = await http.get(url, headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future storeCustomer(String name, String address, String gender) async {
    try {
      Uri url = ApiRoute.storeCustomerRoute;
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "x-api-key": ApiRoute.API_KEY},
          body: json.encode({"nama_pelanggan": name, "alamat": address, "status": gender}));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future deleteCustomer(String customerID) async {
    try {
      Uri url = ApiRoute.deleteCustomerRoute;
      var response = await http.delete(url,
          headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY}, body: json.encode({"id": customerID}));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future showCustomer(String customerID) async {
    try {
      Uri url = Uri.parse("${ApiRoute.showCustomerRoute}$customerID");
      var response = await http.get(url, headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future updateCustomer(String customerID,String name, String address, String gender) async {
    try {
      Uri url = ApiRoute.updateCustomerRoute;
      var response = await http.put(url,
          headers: {"Content-Type": "application/json", "x-api-key": ApiRoute.API_KEY},
          body: json.encode({"id": customerID,"nama_pelanggan": name, "alamat": address, "status": gender}));

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return HandleResponse.failResponse(e.toString());
    }
  }
}
