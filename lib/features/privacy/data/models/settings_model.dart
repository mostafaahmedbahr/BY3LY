String? _asString(dynamic v) => v?.toString();

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

List<T>? _parseList<T>(dynamic raw, T Function(Map<String, dynamic>) from) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(from(Map<String, dynamic>.from(e)));
  }
  return out;
}

class SettingsModel {
  bool? status;
  String? message;
  Data? data;

  SettingsModel({this.status, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    if (raw is Map) {
      data = Data.fromJson(Map<String, dynamic>.from(raw));
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["status"] = status;
    result["message"] = message;
    if (data != null) {
      result["data"] = data?.toJson();
    }
    return result;
  }
}

class Data {
  Settings? settings;

  Data({this.settings});

  Data.fromJson(Map<String, dynamic> json) {
    final raw = json["settings"];
    settings = raw is Map
        ? Settings.fromJson(Map<String, dynamic>.from(raw))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (settings != null) {
      result["settings"] = settings?.toJson();
    }
    return result;
  }
}

class Settings {
  String? contactMethod;
  List<ContactMethods>? contactMethods;
  bool? canChat;
  bool? canCall;
  String? contactPhone;
  String? storeName;
  String? storeAddress;
  bool? notifyNewProducts;

  Settings({
    this.contactMethod,
    this.contactMethods,
    this.canChat,
    this.canCall,
    this.contactPhone,
    this.storeName,
    this.storeAddress,
    this.notifyNewProducts,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    contactMethod = _asString(json["contact_method"]);
    contactMethods = _parseList(json["contact_methods"], ContactMethods.fromJson);
    canChat = _asBool(json["can_chat"]);
    canCall = _asBool(json["can_call"]);
    contactPhone = _asString(json["contact_phone"]);
    storeName = _asString(json["store_name"]);
    storeAddress = _asString(json["store_address"]);
    notifyNewProducts = _asBool(json["notify_new_products"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["contact_method"] = contactMethod;
    if (contactMethods != null) {
      result["contact_methods"] = contactMethods
          ?.map((e) => e.toJson())
          .toList();
    }
    result["can_chat"] = canChat;
    result["can_call"] = canCall;
    result["contact_phone"] = contactPhone;
    result["store_name"] = storeName;
    result["store_address"] = storeAddress;
    result["notify_new_products"] = notifyNewProducts;
    return result;
  }
}

class ContactMethods {
  String? value;
  String? label;

  ContactMethods({this.value, this.label});

  ContactMethods.fromJson(Map<String, dynamic> json) {
    value = _asString(json["value"]);
    label = _asString(json["label"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["value"] = value;
    result["label"] = label;
    return result;
  }
}
