double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  if (v is bool) return v ? 1 : 0;
  return null;
}

class WalletHistoryModel {
  bool? status;
  String? message;
  List<WalletHistoryItem>? history;

  WalletHistoryModel({this.status, this.message, this.history});

  WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    if (rawStatus is bool) {
      status = rawStatus;
    } else if (rawStatus is int) {
      status = rawStatus != 0;
    }
    message = json['message']?.toString();
    final raw = json['data'];
    if (raw is List) {
      history = raw
          .whereType<Map>()
          .map((e) => WalletHistoryItem.fromJson(
              Map<String, dynamic>.from(e)))
          .toList();
    } else if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['history'] ??
          map['transactions'] ??
          map['data'] ??
          map['items'];
      if (list is List) {
        history = list
            .whereType<Map>()
            .map((e) => WalletHistoryItem.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (history != null) {
      map['data'] = history?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class WalletHistoryItem {
  int? id;
  double? amount;
  String? type;
  String? typeLabel;
  String? status;
  String? statusLabel;
  String? paymentMethod;
  String? receiptUrl;
  String? createdAt;

  WalletHistoryItem({
    this.id,
    this.amount,
    this.type,
    this.typeLabel,
    this.status,
    this.statusLabel,
    this.paymentMethod,
    this.receiptUrl,
    this.createdAt,
  });

  WalletHistoryItem.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    amount = _asDouble(json['amount'] ?? json['balance']);
    type = json['type']?.toString();
    typeLabel = (json['type_label'] ?? json['typeLabel'] ?? json['title'])
        ?.toString();
    status = json['status']?.toString();
    statusLabel =
        (json['status_label'] ?? json['statusLabel'])?.toString();
    paymentMethod =
        (json['payment_method'] ?? json['paymentMethod'])?.toString();
    receiptUrl =
        (json['receipt_url'] ?? json['receiptUrl'] ?? json['receipt'])
            ?.toString();
    createdAt = (json['created_at'] ??
            json['createdAt'] ??
            json['date'] ??
            json['created'])
        ?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['type'] = type;
    map['type_label'] = typeLabel;
    map['status'] = status;
    map['status_label'] = statusLabel;
    map['payment_method'] = paymentMethod;
    map['receipt_url'] = receiptUrl;
    map['created_at'] = createdAt;
    return map;
  }

  bool get isCredit {
    final t = (type ?? '').toLowerCase();
    if (t.contains('debit') ||
        t.contains('withdraw') ||
        t.contains('pay') ||
        t.contains('خصم') ||
        t.contains('سحب')) {
      return false;
    }
    return true;
  }

  String get dateLabel {
    final v = (createdAt ?? '').trim();
    if (v.isEmpty) return '';
    return v.length > 10 ? v.substring(0, 10) : v;
  }
}
