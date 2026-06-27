import 'package:client/features/home/domain/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class CategoryApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String image;

  CategoryApiModel({this.id, required this.name, required this.image});

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  CategoryEntity toEntity() {
    return CategoryEntity(categoryId: id, name: name, image: image);
  }

  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.categoryId,
      name: entity.name,
      image: entity.image,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
