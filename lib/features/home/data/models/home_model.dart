class HomeModel {
  final bool status;
  final String message;
  final HomeDataModel data;

  HomeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: HomeDataModel.fromJson(json['data'] ?? {}),
    );
  }
}


class HomeDataModel {
  final List<CategoryModel> categories;
  final List<BestView> bestView;
  final List<Ads> ads;

  HomeDataModel({
    required this.categories,
    required this.bestView,
    required this.ads,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),

      bestView: (json['bestView'] as List? ?? [])
          .map((e) => BestView.fromJson(e))
          .toList(),

      ads: (json['ads'] as List? ?? [])
          .map((e) => Ads.fromJson(e))
          .toList(),
    );
  }
}


class CategoryModel {
  final int id;
  final String name;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}


class BestView {
  final int id;
  final String name;
  final String desc;
  final String price;
  final String image;
  final List<ProductImage> images;
  final dynamic rate;
  final int countComments;
  final List<CommentModel> comments;
  final bool isFavourite;
  final String model;
  final String marka;
  final String type;
  final String createdAt;

  BestView({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.images,
    required this.rate,
    required this.countComments,
    required this.comments,
    required this.isFavourite,
    required this.model,
    required this.marka,
    required this.type,
    required this.createdAt,
  });

  factory BestView.fromJson(Map<String, dynamic> json) {
    return BestView(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image'] ?? '',

      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),

      rate: json['rate'],

      countComments: json['countCommenets'] ?? 0,

      comments: (json['commenets'] as List? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),

      isFavourite: json['isFavourite'] ?? false,
      model: json['model'] ?? '',
      marka: json['marka'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class Ads {
  final int id;
  final String name;
  final String desc;
  final String price;
  final String image;
  final List<ProductImage> images;
  final dynamic rate;
  final int countComments;
  final List<CommentModel> comments;
  final bool isFavourite;
  final String model;
  final String marka;
  final String type;
  final String createdAt;

  Ads({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.images,
    required this.rate,
    required this.countComments,
    required this.comments,
    required this.isFavourite,
    required this.model,
    required this.marka,
    required this.type,
    required this.createdAt,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image'] ?? '',

      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),

      rate: json['rate'],

      countComments: json['countCommenets'] ?? 0,

      comments: (json['commenets'] as List? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),

      isFavourite: json['isFavourite'] ?? false,
      model: json['model'] ?? '',
      marka: json['marka'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}


class ProductImage {
  final int id;
  final String image;

  ProductImage({
    required this.id,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}

class CommentModel {
  final int id;
  final dynamic rate;
  final String comment;
  final String user;

  CommentModel({
    required this.id,
    required this.rate,
    required this.comment,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      rate: json['rate'],
      comment: json['commenet'] ?? '',
      user: json['user'] ?? '',
    );
  }
}