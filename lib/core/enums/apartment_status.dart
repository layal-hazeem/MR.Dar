import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum ApartmentStatus { pending, accepted, rejected, blocked, canceled }

extension ApartmentStatusExtension on ApartmentStatus {
  static ApartmentStatus fromString(String? status) {
    return fromDynamic(status);
  }

  String get displayName {
    switch (this) {
      case ApartmentStatus.pending:
        return 'Pending'.tr;
      case ApartmentStatus.accepted:
        return 'accepted'.tr;
      case ApartmentStatus.rejected:
        return 'Rejected'.tr;
      case ApartmentStatus.blocked:
        return 'Blocked'.tr;
      case ApartmentStatus.canceled:
        return 'Canceled'.tr;
    }
  }

  Color get color {
    switch (this) {
      case ApartmentStatus.pending:
        return Colors.orange;
      case ApartmentStatus.accepted:
        return Colors.green;
      case ApartmentStatus.rejected:
        return Colors.red;
      case ApartmentStatus.blocked:
        return Colors.grey;
      case ApartmentStatus.canceled:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case ApartmentStatus.pending:
        return Icons.hourglass_empty;
      case ApartmentStatus.accepted:
        return Icons.check_circle;
      case ApartmentStatus.rejected:
        return Icons.cancel;
      case ApartmentStatus.blocked:
        return Icons.block;
      case ApartmentStatus.canceled:
        return Icons.do_not_disturb_on;
    }
  }

  String get description {
    switch (this) {
      case ApartmentStatus.pending:
        return 'Waiting for admin approval';
      case ApartmentStatus.accepted:
        return 'Approved and available for booking';
      case ApartmentStatus.rejected:
        return 'Not approved by admin';
      case ApartmentStatus.blocked:
        return 'Temporarily unavailable';
      case ApartmentStatus.canceled:
        return 'Booking was canceled';
    }
  }

  static ApartmentStatus fromDynamic(dynamic value) {
    if (value == null) return ApartmentStatus.pending;

    final strValue = value.toString().toLowerCase();

    switch (strValue) {
      case '1':
      case 'pending':
        return ApartmentStatus.pending;
      case '2':
      case 'accepted':
        return ApartmentStatus.accepted;
      case '3':
      case 'rejected':
        return ApartmentStatus.rejected;
      case '4':
      case 'blocked':
        return ApartmentStatus.blocked;
      case '5':
      case 'canceled':
      case 'cancelled':
        return ApartmentStatus.canceled;
      default:
        if (strValue.contains('.')) {
          final parts = strValue.split('.');
          if (parts.length > 1) {
            return fromDynamic(parts.last);
          }
        }
        return ApartmentStatus.pending;
    }
  }

  int get numericValue {
    switch (this) {
      case ApartmentStatus.pending:
        return 1;
      case ApartmentStatus.accepted:
        return 2;
      case ApartmentStatus.rejected:
        return 3;
      case ApartmentStatus.blocked:
        return 4;
      case ApartmentStatus.canceled:
        return 5;
    }
  }
}
