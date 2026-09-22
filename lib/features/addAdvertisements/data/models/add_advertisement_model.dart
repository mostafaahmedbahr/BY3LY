
class AddAdvertisementModel {
  bool? status;
  int? number;
  String? message;

  AddAdvertisementModel({this.status, this.number, this.message});

  AddAdvertisementModel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["number"] is num) {
      number = (json["number"] as num).toInt();
    }
    if(json["message"] is String) {
      message = json["message"];
    }
  }

  static List<AddAdvertisementModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(AddAdvertisementModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["number"] = number;
    _data["message"] = message;
    return _data;
  }

  AddAdvertisementModel copyWith({
    bool? status,
    int? number,
    String? message,
  }) => AddAdvertisementModel(
    status: status ?? this.status,
    number: number ?? this.number,
    message: message ?? this.message,
  );
}