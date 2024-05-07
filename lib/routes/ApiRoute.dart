import 'package:mini_perpus_up/env.dart';

class ApiRoute{
  static final String API_KEY = Env.API_KEY;

  // Auth
  static final Uri loginRoute = Uri.parse("${Env.API_URL}auth/login");
  static final Uri loginCustomerRoute = Uri.parse("${Env.API_URL}auth/login/customer");
  static final Uri logoutRoute = Uri.parse("${Env.API_URL}auth/logout");

  // Main
  // GET
  static final Uri getBookRoute = Uri.parse("${Env.API_URL}get/book");
  static final Uri getCustomerRoute = Uri.parse("${Env.API_URL}get/customer");
  static final Uri getRentRoute = Uri.parse("${Env.API_URL}get/rent");
  static final Uri getRentDataNeededRoute = Uri.parse("${Env.API_URL}get/rent/data");

  // STORE
  static final Uri storeBookRoute = Uri.parse("${Env.API_URL}store/book");
  static final Uri storeCustomerRoute = Uri.parse("${Env.API_URL}store/customer");
  static final Uri storeRentRoute = Uri.parse("${Env.API_URL}store/rent");

  // SHOW
  static final Uri showBookRoute = Uri.parse("${Env.API_URL}show/book/");
  static final Uri showCustomerRoute = Uri.parse("${Env.API_URL}show/customer/");

  // UPDATE
  static final Uri updateBookRoute = Uri.parse("${Env.API_URL}update/book");
  static final Uri updateCustomerRoute = Uri.parse("${Env.API_URL}update/customer");

  // DELETE
  static final Uri deleteBookRoute = Uri.parse("${Env.API_URL}destroy/book");
  static final Uri deleteCustomerRoute = Uri.parse("${Env.API_URL}destroy/customer");
}