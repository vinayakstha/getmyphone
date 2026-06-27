import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String name;
  final String image;

  const CategoryEntity({
    this.categoryId,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [categoryId, name, image];
}
