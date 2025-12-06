import '../api/end_points.dart';

class ErrorModel {
  final String errorMessage;
  final Map<String, dynamic>? errors;

  ErrorModel({required this.errorMessage, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      errorMessage: jsonData[ApiKey.errorMessage],
      errors: jsonData[ApiKey.errorsList],
    );
  }
}
