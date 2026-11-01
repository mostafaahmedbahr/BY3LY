
class PauseAdResumeAdModel {
  bool? status;
  String? message;
  Data? data;

  PauseAdResumeAdModel({this.status, this.message, this.data});

  PauseAdResumeAdModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? adId;
  bool? isPaused;
  int? status;

  Data({this.adId, this.isPaused, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    adId = json["ad_id"];
    isPaused = json["is_paused"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["ad_id"] = adId;
    _data["is_paused"] = isPaused;
    _data["status"] = status;
    return _data;
  }
}