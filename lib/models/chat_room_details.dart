class ChatRoomDetails {
  final String customerName;
  final String customerPhone;
  final int lastUpdated;
  final String? lastContactMessage;
  final int? lastAdminResponseTime;
  final String? lastAdminPhone;
  final String? customerPhotoUrl;

  ChatRoomDetails({
    required this.customerName,
    required this.customerPhone,
    required this.lastUpdated,
    this.lastContactMessage,
    this.lastAdminResponseTime,
    this.lastAdminPhone,
    this.customerPhotoUrl,
  });

  factory ChatRoomDetails.fromJson(Map<String, dynamic> json) {
    return ChatRoomDetails(
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      lastUpdated: json['lastUpdated'],
      lastContactMessage: json['lastContactMessage'],
      lastAdminResponseTime: json['lastAdminResponseTime'],
      lastAdminPhone: json['lastAdminPhone'],
      customerPhotoUrl: json['customerPhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerName'] = customerName;
    data['customerPhone'] = customerPhone;
    data['lastUpdated'] = lastUpdated;
    data['lastContactMessage'] = lastContactMessage;
    data['lastAdminResponseTime'] = lastAdminResponseTime;
    data['lastAdminPhone'] = lastAdminPhone;
    data['customerPhotoUrl'] = customerPhotoUrl;
    return data;
  }
}
