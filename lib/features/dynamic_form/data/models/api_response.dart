import 'localized_text.dart';
import 'form_schema.dart';

class ApiResponse {
  final String status;
  final int statusCode;
  final String message;
  final ServiceData? data;

  const ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] as String? ?? '',
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ServiceData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class ServiceData {
  final int id;
  final LocalizedText name;
  final String slug;
  final String identifier;
  final FormSchema? form;

  const ServiceData({
    required this.id,
    required this.name,
    required this.slug,
    required this.identifier,
    this.form,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] as int? ?? 0,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
      slug: json['slug'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      form: json['form'] != null
          ? FormSchema.fromJson(json['form'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'slug': slug,
      'identifier': identifier,
      if (form != null) 'form': form!.toJson(),
    };
  }
}
