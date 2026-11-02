/// Response of `pauseAd` / `resumeAd`.
///
/// The backend returns:
/// ```json
/// {"status": true, "message": "...", "data": {"ad_id": 1, "is_paused": true, "status": 1}}
/// ```
/// Values may arrive as `bool`, `int` or `String`, so they are normalised.
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
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

String? _asString(dynamic value) => value?.toString();

class PauseResumeAdModel {
  bool? status;
  String? message;
  PauseResumeAdData? data;

  PauseResumeAdModel({this.status, this.message, this.data});

  PauseResumeAdModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    data = json["data"] == null
        ? null
        : PauseResumeAdData.fromJson(Map<String, dynamic>.from(json["data"]));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (this.data != null) data["data"] = this.data!.toJson();
    return data;
  }
}

class PauseResumeAdData {
  int? adId;
  bool? isPaused;
  int? status;

  PauseResumeAdData({this.adId, this.isPaused, this.status});

  PauseResumeAdData.fromJson(Map<String, dynamic> json) {
    adId = _asInt(json["ad_id"]);
    isPaused = _asBool(json["is_paused"]);
    status = _asInt(json["status"]);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["ad_id"] = adId;
    data["is_paused"] = isPaused;
    data["status"] = status;
    return data;
  }
}
