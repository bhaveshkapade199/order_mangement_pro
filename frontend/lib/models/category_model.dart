import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String iconName;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconName,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      iconName: json['iconName'] ?? 'plumbing',
      description: json['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, slug];
}
