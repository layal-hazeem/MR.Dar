import 'api_config.dart';

class EndPoint {
  static String get baseUrl {
    if (ApiConfig.baseUrl == null) {
      throw Exception("Base URL is not initialized");
    }
    return ApiConfig.baseUrl!;
  }
  //static String baseUrl = "http://192.168.1.110:8000/api/";
  //static String baseUrl = "http://10.0.2.2:8000/api/";

  static String logIn = "login";
  static String signUp = "register";
  static String logout = "logout";
  static const String getApartments = "houses";
  static const String createApartment = "houses";
  static const String getGovernorates = "governorates";
  static const String reservations = "reservations";
  static const String getMyHouses = "houses/my-houses";

  static String getAccount = "profile";
  static String updateAccount = "profile";
  static String deleteAccount = "profile";

  static const String toggleFavorite = "favorites";
  static const String myFavorite = "favorites/my-favorites";

  static const String review = "reviews";
}

class ApiKey {
  static String data = "data";
  static String errorMessage = "message";
  static String errorsList = "errors";
  static String phone = "phone";
  static String password = "password";
}
