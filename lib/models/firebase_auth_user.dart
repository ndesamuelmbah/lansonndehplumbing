import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lansonndehplumbing/models/custom_auth_provider.dart';
part 'firebase_auth_user.g.dart';

@HiveType(typeId: 16)
class FirebaseAuthUser {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? displayName;
  @HiveField(3)
  final String? photoUrl;
  @HiveField(4)
  final bool emailVerified;
  @HiveField(5)
  final int creationTime;
  @HiveField(6)
  final Map<String, dynamic>? customClaims;
  @HiveField(7)
  final List<CustomAuthProvider> providers;
  @HiveField(8)
  final bool isAdmin;
  @HiveField(9)
  final String phoneNumber;
  @HiveField(10)
  final String? currentOrderId;

  FirebaseAuthUser(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photoUrl,
      required this.providers,
      required this.creationTime,
      required this.customClaims,
      required this.emailVerified,
      required this.phoneNumber,
      this.currentOrderId,
      this.isAdmin = false});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'providers': providers.map((p) => p.toJson()).toList(),
      'emailVerified': emailVerified,
      'creationTime': creationTime,
      'customClaims': customClaims,
      'phoneNumber': phoneNumber,
      'currentOrderId': currentOrderId,
      'isAdmin': customClaims?['isAdmin'] ?? false
    };
  }

  factory FirebaseAuthUser.fromJson(Map<String, dynamic> json) {
    final providersList = (json['providers'] as List<dynamic>)
        .map((p) => CustomAuthProvider.fromJson(p))
        .toList();

    return FirebaseAuthUser(
        uid: json['uid'],
        email: json['email'],
        phoneNumber: json['phoneNumber'] ?? json['uid'],
        displayName: json['displayName'],
        photoUrl: json['photoUrl'],
        providers: providersList,
        emailVerified: json['emailVerified'],
        creationTime: json['creationTime'] ?? json['createDate'],
        customClaims: json['customClaims'],
        currentOrderId: json['currentOrderId'] ??
            json['customClaims']?['currentOrderId'] as String?,
        isAdmin: json['customClaims']?['isAdmin'] ?? false);
  }

  static FirebaseAuthUser fromCurrentUser(
      User user, Map<String, dynamic>? customClaims) {
    if (user.email == null) {
      throw 'Only Users With Emails Can Proceed';
    }
    final providerData = user.providerData;
    final providers =
        providerData.map((p) => CustomAuthProvider.fromUserInfo(p)).toList();

    return FirebaseAuthUser(
        uid: user.uid,
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        providers: providers,
        emailVerified: user.emailVerified,
        creationTime: user.metadata.creationTime?.millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch,
        customClaims: customClaims,
        isAdmin: customClaims?['isAdmin'] ?? false,
        currentOrderId: customClaims?['currentOrderId']);
  }

  DateTime getCreateDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(creationTime);
  }
}
