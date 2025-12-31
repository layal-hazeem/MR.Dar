class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String dateOfBirth;
  final String? profileImage;
  final String? idImage;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.dateOfBirth,
    required this.profileImage,
    required this.idImage,
  });

  // من JSON

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parseImages(dynamic image) {
      if (image == null || image.toString().trim().isEmpty) {
        return "";
      }

      if (image is Map && image['url'] != null) {
        String url = image['url'].toString();
        // تأكد من الرابط كامل
        if (url.isNotEmpty && !url.startsWith('http')) {
          if (url.startsWith('/storage/')) {
            url = 'http://10.0.2.2:8000$url';
          } else if (url.startsWith('storage/')) {
            url = 'http://10.0.2.2:8000/storage/${url.substring(8)}';
          }
        }
        return url;
      }

      return image.toString();
    }

    return UserModel(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? '',
      lastName: json["last_name"] ?? '',
      phone: json["phone"] ?? '',
      role: json["role"] ?? '',
      dateOfBirth: json["date_of_birth"] ?? '',
      profileImage: parseImages(json['profile_image']),
      idImage: parseImages(json['id_image']),
    );
  }

  // ✅ أضيفي هاد
  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
    String? dateOfBirth,
    String? profileImage,
    String? idImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      idImage: idImage ?? this.idImage,
    );
  }
}
