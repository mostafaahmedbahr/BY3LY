
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if(data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["ad_id"] = adId;
    jsonData["is_paused"] = isPaused;
    jsonData["status"] = status;
    return jsonData;
  }
}