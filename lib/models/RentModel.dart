import 'dart:convert';

import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';
import 'package:aplikasi_perpustakaan/utils/HandleResponse.dart';
import 'package:http/http.dart' as http;

class RentModel {
  static Future getRent(Uri? paginateUrl, String? value) async {
    try {
      Uri url = paginateUrl ?? ApiRoute.getRentRoute;
      if(value != null) url = Uri.parse("${url}?query=${value}");
      var response = await http.get(url, headers: {"Content-Type": 'application/json', "x-api-key": ApiRoute.API_KEY});

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future getRentDataNeeded() async {
    try {
      Uri url = ApiRoute.getRentDataNeededRoute;

      var response = await http.get(url, headers: {"Content-Type": 'application/json', "x-api-key": ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future deleteRent(String rentID) async {
    print(rentID);
    try {
      Uri url = ApiRoute.deleteRentRoute;

      var response = await http.delete(url,
          headers: {"Content-Type": 'application/json', "x-api-key": ApiRoute.API_KEY}, body: json.encode({"id": rentID}));

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future storeRent(
      String no_pelanggan, String kode_buku, String tglSewa, String tglPengembalian, int jumlah, int tax) async {
    try {
      Uri url = ApiRoute.storeRentRoute;

      var response = await http.post(url,
          headers: {"Content-Type": 'application/json', "x-api-key": ApiRoute.API_KEY},
          body: json.encode({
            "no_pelanggan": no_pelanggan,
            "kode_buku": kode_buku,
            "tanggal_sewa": tglSewa,
            "tanggal_pengembalian": tglPengembalian,
            "total": jumlah,
            "denda": tax
          }));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e);
      return HandleResponse.failResponse(e.toString());
    }
  }
}
