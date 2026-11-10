// Tolerant parsing helpers: the API sends the same field as int, String,
// bool or null depending on the endpoint, so every value is normalised
// before it reaches a typed field.
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

String? _asString(dynamic value) => value?.toString();

List<T>? _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(fromJson(Map<String, dynamic>.from(e)));
  }
  return out;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

class StatisticsModel {
  bool? status;
  String? message;
  Data? data;

  StatisticsModel({this.status, this.message, this.data});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    final dataMap = raw == null ? null : _asMap(raw);
    data = dataMap == null ? null : Data.fromJson(dataMap);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if (data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  Summary? summary;
  String? month;
  String? monthName;
  dynamic selectedDate;
  List<Days>? days;
  Period? period;
  List<dynamic>? sales;
  Pagination? pagination;

  Data({
    this.summary,
    this.month,
    this.monthName,
    this.selectedDate,
    this.days,
    this.period,
    this.sales,
    this.pagination,
  });

  Data.fromJson(Map<String, dynamic> json) {
    final rawSummary = json["summary"];
    summary = _asMap(rawSummary) == null
        ? null
        : Summary.fromJson(_asMap(rawSummary)!);
    month = _asString(json["month"]);
    monthName = _asString(json["month_name"]);
    selectedDate = json["selected_date"];
    days = _parseList(json["days"], Days.fromJson);
    final rawPeriod = json["period"];
    period = _asMap(rawPeriod) == null
        ? null
        : Period.fromJson(_asMap(rawPeriod)!);
    sales = json["sales"] is List ? json["sales"] as List : null;
    final rawPagination = json["pagination"];
    pagination = _asMap(rawPagination) == null
        ? null
        : Pagination.fromJson(_asMap(rawPagination)!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (summary != null) {
      jsonData["summary"] = summary?.toJson();
    }
    jsonData["month"] = month;
    jsonData["month_name"] = monthName;
    jsonData["selected_date"] = selectedDate;
    if (days != null) {
      jsonData["days"] = days?.map((e) => e.toJson()).toList();
    }
    if (period != null) {
      jsonData["period"] = period?.toJson();
    }
    if (sales != null) {
      jsonData["sales"] = sales;
    }
    if (pagination != null) {
      jsonData["pagination"] = pagination?.toJson();
    }
    return jsonData;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({this.total, this.perPage, this.currentPage, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = _asInt(json["total"]);
    perPage = _asInt(json["per_page"]);
    currentPage = _asInt(json["current_page"]);
    totalPages = _asInt(json["total_pages"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["total"] = total;
    jsonData["per_page"] = perPage;
    jsonData["current_page"] = currentPage;
    jsonData["total_pages"] = totalPages;
    return jsonData;
  }
}

class Period {
  String? from;
  String? to;
  int? salesCount;
  int? salesAmount;

  Period({this.from, this.to, this.salesCount, this.salesAmount});

  Period.fromJson(Map<String, dynamic> json) {
    from = _asString(json["from"]);
    to = _asString(json["to"]);
    salesCount = _asInt(json["sales_count"]);
    salesAmount = _asInt(json["sales_amount"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["from"] = from;
    jsonData["to"] = to;
    jsonData["sales_count"] = salesCount;
    jsonData["sales_amount"] = salesAmount;
    return jsonData;
  }
}

class Days {
  String? date;
  int? day;
  String? dayName;
  int? salesCount;
  int? salesAmount;

  Days({this.date, this.day, this.dayName, this.salesCount, this.salesAmount});

  Days.fromJson(Map<String, dynamic> json) {
    date = _asString(json["date"]);
    day = _asInt(json["day"]);
    dayName = _asString(json["day_name"]);
    salesCount = _asInt(json["sales_count"]);
    salesAmount = _asInt(json["sales_amount"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["date"] = date;
    jsonData["day"] = day;
    jsonData["day_name"] = dayName;
    jsonData["sales_count"] = salesCount;
    jsonData["sales_amount"] = salesAmount;
    return jsonData;
  }
}

class Summary {
  int? totalSales;
  int? totalSalesAmount;
  int? displayedProducts;
  int? interestedCount;
  int? favouritesCount;
  int? complaints;

  Summary({
    this.totalSales,
    this.totalSalesAmount,
    this.displayedProducts,
    this.interestedCount,
    this.favouritesCount,
    this.complaints,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    totalSales = _asInt(json["total_sales"]);
    totalSalesAmount = _asInt(json["total_sales_amount"]);
    displayedProducts = _asInt(json["displayed_products"]);
    interestedCount = _asInt(json["interested_count"]);
    favouritesCount = _asInt(json["favourites_count"]);
    complaints = _asInt(json["complaints"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["total_sales"] = totalSales;
    jsonData["total_sales_amount"] = totalSalesAmount;
    jsonData["displayed_products"] = displayedProducts;
    jsonData["interested_count"] = interestedCount;
    jsonData["favourites_count"] = favouritesCount;
    jsonData["complaints"] = complaints;
    return jsonData;
  }
}
