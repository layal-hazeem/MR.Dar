import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class MyAccountController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      // طباعة كل البيانات المخزنة للتشخيص
      print("📱 SharedPreferences Data (MyAccount):");
      final allKeys = prefs.getKeys();
      for (var key in allKeys) {
        if (key != "token") {
          print("   $key: ${prefs.getString(key)}");
        } else {
          final token = prefs.getString("token");
          print("   token: ${token?.substring(0, 20)}...");
        }
      }

      final userData = {
        "id": prefs.getString("id") ?? "0",
        "first_name": prefs.getString("first_name") ?? "Unknown",
        "last_name": prefs.getString("last_name") ?? "",
        "phone": prefs.getString("phone") ?? "",
        "role": prefs.getString("role") ?? "renter",
        "date_of_birth": prefs.getString("date_of_birth") ?? "",
        "profile_image_url": prefs.getString("profile_image_url") ?? "",
        "id_image_url": prefs.getString("id_image_url") ?? "",
      };

      user.value = UserModel.fromPrefs(userData);
      isLoading.value = false;

      print("✅ User loaded: ${user.value?.firstName} ${user.value?.lastName}");
      print("✅ Profile Image URL: ${user.value?.profileImageUrl}");
      print("✅ ID Image URL: ${user.value?.idImageUrl}");
    } catch (e) {
      isLoading.value = false;
      print("❌ Error loading user: $e");
    }
  }

  // دالة للتحديث
  Future<void> refreshUser() async {
    await loadUser();
  }
}
