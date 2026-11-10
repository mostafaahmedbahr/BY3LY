class PaymentMethodsModel {
  bool? status;
  String? message;
  PaymentMethodsData? data;

  PaymentMethodsModel({this.status, this.message, this.data});

  PaymentMethodsModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json["status"];
    if (rawStatus is bool) {
      status = rawStatus;
    } else if (rawStatus is num) {
      status = rawStatus != 0;
    } else if (rawStatus is String) {
      final v = rawStatus.trim().toLowerCase();
      status = v == 'true' || v == '1';
    }
    message = json["message"]?.toString();
    final raw = json["data"];
    if (raw is Map) {
      data = PaymentMethodsData.fromJson(Map<String, dynamic>.from(raw));
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data?.toJson();
    }
    return map;
  }
}

class PaymentMethodsData {
  List<PaymentMethod>? methods;

  PaymentMethodsData({this.methods});

  PaymentMethodsData.fromJson(Map<String, dynamic> json) {
    final raw = json["methods"];
    if (raw is! List) {
      methods = null;
      return;
    }
    methods = raw
        .whereType<Map>()
        .map((e) => PaymentMethod.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (methods != null) {
      map["methods"] = methods?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class PaymentMethod {
  String? code;
  String? name;
  String? account;

  PaymentMethod({this.code, this.name, this.account});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    code = json["code"]?.toString();
    name = json["name"]?.toString();
    account = json["account"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["code"] = code;
    map["name"] = name;
    map["account"] = account;
    return map;
  }
}
