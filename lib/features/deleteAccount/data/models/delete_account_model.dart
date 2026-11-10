String? _asString(dynamic v) => v?.toString();

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
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

/// API envelope for the delete-account request. Tolerant of the usual
/// Laravel variants (`status: true|1|"1"`, numeric `number`, missing `message`).
class DeleteAccountModel {
  bool? status;
  int? number;
  String? message;

  DeleteAccountModel({this.status, this.number, this.message});

  DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json['status']);
    number = _asInt(json['number']);
    message = _asString(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] = number;
    data['message'] = message;
    return data;
  }
}
