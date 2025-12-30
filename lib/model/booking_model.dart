class Booking {
  final int id;
  final int houseId;
  final String startDate;
  final String endDate;
  final int duration;
  final String status;

  Booking({
    required this.id,
    required this.houseId,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.status,
  });

  factory Booking.fromJson(
      Map<String, dynamic> json, {
        required int houseId, // 👈 نمرّره من برا
      }) {
    return Booking(
      id: json['id'],
      houseId: houseId, // 👈 ثابت
      startDate: json['start_date'],
      endDate: json['end_date'],
      duration: int.parse(json['duration'].toString()),
      status: json['status'].toString().toLowerCase(),
    );
  }
}
