class AllSubCategoriesProductsModel {
  final bool status;
  final String message;
  final Data data;

  AllSubCategoriesProductsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllSubCategoriesProductsModel.fromJson(Map<String, dynamic> json) {
    return AllSubCategoriesProductsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}
class Data {
  final List<Products> products;

  Data({required this.products});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      products: (json['products'] as List? ?? [])
          .map((e) => Products.fromJson(e))
          .toList(),
    );
  }
}

class Products {
  final int id;
  final String name;
  final String desc;
  final String price;
  final dynamic image;
  final List<ProductImage> images;
  final dynamic rate;
  final dynamic sellerRate;
  final int countComments;
  final List<CommentModel> comments;
  final bool isFavourite;
  final String model;
  final String marka;
  final String type;
  final int view;
  final int sellerId;
  final String sellerName;
  final String sellerImage;
  final String sellerPhone;
  final String lat;
  final String lng;
  final int status;
  final int negotiable;
  final int communication;
  final String address;
  final String createdAt;

  Products({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.images,
    required this.rate,
    required this.sellerRate,
    required this.countComments,
    required this.comments,
    required this.isFavourite,
    required this.model,
    required this.marka,
    required this.type,
    required this.view,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.sellerPhone,
    required this.lat,
    required this.lng,
    required this.status,
    required this.negotiable,
    required this.communication,
    required this.address,
    required this.createdAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image'] ?? '',

      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),

      rate: json['rate'] ?? 0,
      sellerRate: json['seller_rate'] ?? 0,
      countComments: json['countCommenets'] ?? 0,

      comments: (json['commenets'] as List? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),

      isFavourite: json['isFavourite'] ?? false,
      model: json['model'] ?? '',
      marka: json['marka'] ?? '',
      type: json['type'] ?? '',
      view: json['view'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      sellerName: json['seller_name'] ?? '',
      sellerImage: json['seller_image'] ?? '',
      sellerPhone: json['seller_phone'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['long'] ?? '',
      status: json['status'] ?? 0,
      negotiable: json['negotiable'] ?? 0,
      communication: json['communication'] ?? 0,
      address: json['address'] ?? '',
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
  final int rate;
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
      rate: json['rate'] ?? 0,
      comment: json['commenet'] ?? '',
      user: json['user'] ?? '',
    );
  }
}
