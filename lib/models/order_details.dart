import 'package:lansonndehplumbing/models/ordered_item.dart';

class OrderDetails {
  final DateTime? deliveryDateTime;
  final DateTime? cancellationDateTime;
  final DateTime orderedDateTime;
  final String deliveryAddress;
  final String userName;
  final String phoneNumber;
  final String deliveryMessage;
  final String modeOfPayment;
  final String orderStatus;
  final int orderStatusIndex;
  final int timestamp;
  final int lastUpdatedTime;
  final String orderId;
  final String? orderCancellationMessage;
  final Map<String, dynamic>? review;
  final OrderedMenuItems orderedMenuItems;

  OrderDetails({
    this.deliveryDateTime,
    this.cancellationDateTime,
    required this.orderedDateTime,
    required this.deliveryAddress,
    required this.userName,
    required this.phoneNumber,
    required this.deliveryMessage,
    required this.modeOfPayment,
    required this.orderStatus,
    required this.orderStatusIndex,
    required this.timestamp,
    required this.lastUpdatedTime,
    required this.orderId,
    this.orderCancellationMessage,
    this.review,
    required this.orderedMenuItems,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
        deliveryDateTime: json.containsKey('deliveryDateTime') &&
                json['deliveryDateTime'] != null
            ? DateTime.parse(json['deliveryDateTime'])
            : null,
        cancellationDateTime: json.containsKey('cancellationDateTime') &&
                json['cancellationDateTime'] != null
            ? DateTime.parse(json['cancellationDateTime'])
            : null,
        orderedDateTime: DateTime.parse(json['orderedDateTime']),
        deliveryAddress: json['deliveryAddress'],
        userName: json['userName'],
        phoneNumber: json['phoneNumber'],
        deliveryMessage: json['deliveryMessage'],
        modeOfPayment: json['modeOfPayment'],
        orderStatus: json['orderStatus'],
        orderStatusIndex: json['orderStatusIndex'],
        timestamp: json['timestamp'],
        orderId: json['orderId'],
        lastUpdatedTime: json['lastUpdatedTime'],
        orderCancellationMessage: json['orderCancellationMessage'],
        review: json['review'],
        orderedMenuItems: OrderedMenuItems.fromJson(json));
  }

  bool hasReview() => review == null;

  Map<String, dynamic> toJson() {
    return {
      'deliveryDateTime':
          deliveryDateTime == null ? null : deliveryDateTime!.toIso8601String(),
      'cancellationDateTime': cancellationDateTime == null
          ? null
          : deliveryDateTime!.toIso8601String(),
      'orderedDateTime': orderedDateTime.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'deliveryMessage': deliveryMessage,
      'modeOfPayment': modeOfPayment,
      'orderStatus': orderStatus,
      'orderStatusIndex': orderStatusIndex,
      'timestamp': timestamp,
      'lastUpdatedTime': lastUpdatedTime,
      'orderCancellationMessage': orderCancellationMessage,
      'review': review,
      'orderId': orderId,
      'orderedMenuItems': orderedMenuItems.toJson(),
    };
  }
}
