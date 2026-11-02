class SettingsModel {
  bool? status;
  String? message;
  Data? data;

  SettingsModel({this.status, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
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
    settings = json["settings"] == null
        ? null
        : Settings.fromJson(json["settings"]);
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
    contactMethod = json["contact_method"];
    contactMethods = json["contact_methods"] == null
        ? null
        : (json["contact_methods"] as List)
              .map((e) => ContactMethods.fromJson(e))
              .toList();
    canChat = json["can_chat"];
    canCall = json["can_call"];
    contactPhone = json["contact_phone"];
    storeName = json["store_name"];
    storeAddress = json["store_address"];
    notifyNewProducts = json["notify_new_products"];
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
    value = json["value"];
    label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["value"] = value;
    result["label"] = label;
    return result;
  }
}
