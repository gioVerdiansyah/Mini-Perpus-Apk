import 'dart:convert';

import 'package:mini_perpus_up/routes/ApiRoute.dart';
import 'package:mini_perpus_up/utils/HandleResponse.dart';
import 'package:http/http.dart' as http;

class BookModel {
  static Future getBook(Uri? paginateUrl) async {
    try {
      Uri url = paginateUrl ?? ApiRoute.getBookRoute;
      var response = await http.get(url, headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future storeBook(String title, String category, String publisher) async {
    try {
      Uri url = ApiRoute.storeBookRoute;
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "x-api-key": ApiRoute.API_KEY},
          body: json.encode({"judul_buku": title, "jenis_buku": category, "produksi": publisher}));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future deleteBook(String bookID) async {
    try {
      Uri url = ApiRoute.deleteBookRoute;
      var response = await http.delete(url,
          headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY}, body: json.encode({"id": bookID}));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future showBook(String bookID) async {
    try {
      Uri url = Uri.parse("${ApiRoute.showBookRoute}$bookID");
      var response = await http.get(url, headers: {"Content-Type": "application/json", 'x-api-key': ApiRoute.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return HandleResponse.failResponse(e.toString());
    }
  }

  static Future updateBook(String bookID, String title, String category, String publisher) async {
    try {
      Uri url = ApiRoute.updateBookRoute;
      var response = await http.put(url,
          headers: {"Content-Type": "application/json", "x-api-key": ApiRoute.API_KEY},
          body: json.encode({"id": bookID, "judul_buku": title, "jenis_buku": category, "produksi": publisher}));

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return HandleResponse.failResponse(e.toString());
    }
  }
}
