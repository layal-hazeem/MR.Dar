import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum ReservationStatus {
  pending,
  accepted,
  rejected,
  blocked,
  canceled,
  previous,
}

extension ReservationStatusExtension on ReservationStatus {
  static ReservationStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ReservationStatus.pending;
      case 'accepted':
        return ReservationStatus.accepted;
      case 'rejected':
        return ReservationStatus.rejected;
      case 'blocked':
        return ReservationStatus.blocked;
      case 'canceled':
      case 'cancelled':
        return ReservationStatus.canceled;
      default:
        return ReservationStatus.previous;
    }
  }

  String get displayName {
    switch (this) {
      case ReservationStatus.pending:
        return 'Pending'.tr;
      case ReservationStatus.accepted:
        return 'accepted'.tr;
      case ReservationStatus.rejected:
        return 'Rejected'.tr;
      case ReservationStatus.blocked:
        return 'Blocked'.tr;
      case ReservationStatus.canceled:
        return 'Canceled'.tr;
      case ReservationStatus.previous:
        return 'Previous'.tr;
    }
  }
}
