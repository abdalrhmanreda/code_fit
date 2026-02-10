import 'form_definition.dart';

class FormSchema {
  final int id;
  final String identifier;
  final String slug;
  final FormDefinition definition;
  final String? name;
  final String? description;
  final int? version;
  final String? status;

  const FormSchema({
    required this.id,
    required this.identifier,
    required this.slug,
    required this.definition,
    this.name,
    this.description,
    this.version,
    this.status,
  });

  factory FormSchema.fromJson(Map<String, dynamic> json) {
    return FormSchema(
      id: json['id'] as int? ?? 0,
      identifier: json['identifier'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      definition: FormDefinition.fromJson(
        json['definition'] as Map<String, dynamic>? ?? {},
      ),
      name: json['name'] as String?,
      description: json['description'] as String?,
      version: json['version'] as int?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'slug': slug,
      'definition': definition.toJson(),
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (version != null) 'version': version,
      if (status != null) 'status': status,
    };
  }
}
