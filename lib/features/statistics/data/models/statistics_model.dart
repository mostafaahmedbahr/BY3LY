class StatisticsModel {
  bool? status;
  String? message;
  Data? data;

  StatisticsModel({this.status, this.message, this.data});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
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
    summary = json["summary"] == null
        ? null
        : Summary.fromJson(json["summary"]);
    month = json["month"];
    monthName = json["month_name"];
    selectedDate = json["selected_date"];
    days = json["days"] == null
        ? null
        : (json["days"] as List).map((e) => Days.fromJson(e)).toList();
    period = json["period"] == null ? null : Period.fromJson(json["period"]);
    sales = json["sales"] ?? [];
    pagination = json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (summary != null) {
      _data["summary"] = summary?.toJson();
    }
    _data["month"] = month;
    _data["month_name"] = monthName;
    _data["selected_date"] = selectedDate;
    if (days != null) {
      _data["days"] = days?.map((e) => e.toJson()).toList();
    }
    if (period != null) {
      _data["period"] = period?.toJson();
    }
    if (sales != null) {
      _data["sales"] = sales;
    }
    if (pagination != null) {
      _data["pagination"] = pagination?.toJson();
    }
    return _data;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({this.total, this.perPage, this.currentPage, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    perPage = json["per_page"];
    currentPage = json["current_page"];
    totalPages = json["total_pages"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["total"] = total;
    _data["per_page"] = perPage;
    _data["current_page"] = currentPage;
    _data["total_pages"] = totalPages;
    return _data;
  }
}

class Period {
  String? from;
  String? to;
  int? salesCount;
  int? salesAmount;

  Period({this.from, this.to, this.salesCount, this.salesAmount});

  Period.fromJson(Map<String, dynamic> json) {
    from = json["from"];
    to = json["to"];
    salesCount = json["sales_count"];
    salesAmount = json["sales_amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["from"] = from;
    _data["to"] = to;
    _data["sales_count"] = salesCount;
    _data["sales_amount"] = salesAmount;
    return _data;
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
    date = json["date"];
    day = json["day"];
    dayName = json["day_name"];
    salesCount = json["sales_count"];
    salesAmount = json["sales_amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["date"] = date;
    _data["day"] = day;
    _data["day_name"] = dayName;
    _data["sales_count"] = salesCount;
    _data["sales_amount"] = salesAmount;
    return _data;
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
    totalSales = json["total_sales"];
    totalSalesAmount = json["total_sales_amount"];
    displayedProducts = json["displayed_products"];
    interestedCount = json["interested_count"];
    favouritesCount = json["favourites_count"];
    complaints = json["complaints"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["total_sales"] = totalSales;
    _data["total_sales_amount"] = totalSalesAmount;
    _data["displayed_products"] = displayedProducts;
    _data["interested_count"] = interestedCount;
    _data["favourites_count"] = favouritesCount;
    _data["complaints"] = complaints;
    return _data;
  }
}
