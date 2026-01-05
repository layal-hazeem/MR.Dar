class OwnerReservation {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final int duration;

  final House house;
  final Renter user;

  OwnerReservation({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.house,
    required this.user,
  });

  factory OwnerReservation.fromJson(Map<String, dynamic> json) {
    return OwnerReservation(
      id: json['id'],
      status: json['status'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      duration: json['duration'],
      house: House.fromJson(json['house']),
      user: Renter.fromJson(json['user']),
    );
  }
}

/* ================= House ================= */

class House {
  final int id;
  final String title;
  final int rentValue;
  final List<String> images;

  House({
    required this.id,
    required this.title,
    required this.rentValue,
    required this.images,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'],
      title: json['title'],
      rentValue: json['rent_value'],
      images: (json['images'] as List)
          .map((e) => e['url'].toString())
          .toList(),
    );
  }
}

/* ================= Renter ================= */

class Renter {
  final String firstName;
  final String lastName;
  final String phone;

  Renter({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory Renter.fromJson(Map<String, dynamic> json) {
    return Renter(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
    );
  }
}
