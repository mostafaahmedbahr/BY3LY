class CategoryModel {
  final int id;
  final String name;
  final String image;
  final List<String> subCategories;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
    required this.subCategories,
  });
}
