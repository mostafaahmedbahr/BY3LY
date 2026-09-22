class ChooseLocationModel {
  bool? status;
  int? number;
  String? message;

  ChooseLocationModel({this.status, this.number, this.message});

  ChooseLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    number = json['number'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] =  number;
    data['message'] =  message;
    return data;
  }
}

