int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return int.tryParse(v.trim());
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final text = v.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

class ChooseLocationModel {
  bool? status;
  int? number;
  String? message;

  ChooseLocationModel({this.status, this.number, this.message});

  ChooseLocationModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json['status']);
    number = _asInt(json['number']);
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['status'] = status;
    jsonData['number'] = number;
    jsonData['message'] = message;
    return jsonData;
  }
}
