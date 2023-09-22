import 'package:lansonndehplumbing/core/utils/get_chat_message_id.dart';
import 'package:hive_flutter/adapters.dart';
part 'chat_message.g.dart';

//Run  `flutter packages pub run build_runner build` in root dir to generate classes
@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  late int sentBy;
  @HiveField(1)
  late String message;
  @HiveField(2)
  late int time;
  @HiveField(3)
  int? duration;
  @HiveField(4)
  num? fileSize;
  @HiveField(5)
  late bool sentByMe;
  @HiveField(6)
  late String messageId;
  @HiveField(7, defaultValue: 'NotProvided')
  late String chatRoomId;
  ChatMessage(
      {required this.sentBy,
      required this.message,
      required this.time,
      this.duration,
      this.fileSize,
      required this.sentByMe,
      required this.messageId,
      required this.chatRoomId});
  factory ChatMessage.fromMap(Map<String, dynamic> json, int myId) {
    int sentBy = json["sentBy"] as int;
    int time = json["time"] as int;
    bool sentByMe = json["sentByMe"] ?? sentBy == myId;
    return ChatMessage(
        time: time,
        message: json["message"] as String,
        sentBy: json["sentBy"] as int,
        sentByMe: sentByMe,
        duration: json["duration"] ?? -1,
        fileSize: json["fileSize"],
        messageId: json['messageId'] ?? getChatMessageId(time),
        chatRoomId: json['chatRoomId']);
  }
}

@HiveType(typeId: 1)
class Address {
  @HiveField(0)
  String displayName;
  @HiveField(1)
  String? city;
  @HiveField(2)
  String? state;
  @HiveField(3)
  double lat;
  @HiveField(4)
  double lng;
  @HiveField(5)
  String countryCode;
  Address(
      {required this.displayName,
      this.city,
      this.state,
      required this.lat,
      required this.lng,
      required this.countryCode});

  factory Address.fromMap(Map<String, dynamic> json) => Address(
      displayName: (json["displayName"] ?? '') as String,
      city: json["city"] as String?,
      state: json["state"] as String?,
      lat: (json["lat"] ?? 0) as double,
      lng: (json["lng"] ?? 0) as double,
      countryCode: (json["countryCode"] ?? '') as String);

  Map<String, dynamic> toMap() => {
        "displayName": displayName,
        "city": city,
        "state": state,
        "lat": lat,
        "lng": lng,
        "countryCode": countryCode
      };
}
