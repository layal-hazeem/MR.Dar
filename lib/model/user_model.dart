class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String dateOfBirth;
  final String? profileImageUrl; // ⬅️ تغيير الاسم لتوضيح أنه رابط
  final String? idImageUrl;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.dateOfBirth,
    required this.profileImageUrl,
    required this.idImageUrl,
  });

  factory UserModel.fromPrefs(Map<String, String> prefs) {
    return UserModel(
      id: int.tryParse(prefs["id"] ?? "0") ?? 0,
      firstName: prefs["first_name"] ?? "",
      lastName: prefs["last_name"] ?? "",
      phone: prefs["phone"] ?? "",
      role: prefs["role"] ?? "",
      dateOfBirth: prefs["date_of_birth"] ?? "",
      profileImageUrl:
          prefs["profile_image_url"] ?? prefs["profile_image"], // ⬅️
      idImageUrl: prefs["id_image_url"] ?? prefs["id_image"], // ⬅️
    );
  }

  // من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
      firstName: json["first_name"]?.toString() ?? "",
      lastName: json["last_name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      role: json["role"]?.toString() ?? "",
      dateOfBirth: json["date_of_birth"]?.toString() ?? "",
      profileImageUrl:
          json["profile_image_url"]?.toString() ??
          json["profile_image"]?.toString(), // ⬅️
      idImageUrl:
          json["id_image_url"]?.toString() ??
          json["id_image"]?.toString(), // ⬅️
    );
  }
}
