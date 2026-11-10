// Tolerant parsing: the API sends the same field as int, String, bool or
// null depending on the endpoint, so every value is normalised.
bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

class AddComplaintModel {
  bool? status;
  int? number;
  String? message;

  AddComplaintModel({this.status, this.number, this.message});

  AddComplaintModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    number = _asInt(json["number"]);
    message = json["message"]?.toString();
  }

  static List<AddComplaintModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(AddComplaintModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["number"] = number;
    jsonData["message"] = message;
    return jsonData;
  }

  AddComplaintModel copyWith({
    bool? status,
    int? number,
    String? message,
  }) => AddComplaintModel(
        status: status ?? this.status,
        number: number ?? this.number,
        message: message ?? this.message,
      );
}
