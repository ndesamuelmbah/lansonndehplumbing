import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lansonndehplumbing/core/utils/get_chat_message_id.dart';

class FirestoreDB {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference exchangeRatesRef =
      FirebaseFirestore.instance.collection("exchangeRates");
  static CollectionReference chatRooms =
      FirebaseFirestore.instance.collection("chatRooms");
  static CollectionReference customersRef =
      FirebaseFirestore.instance.collection("customers");
  static CollectionReference stores =
      FirebaseFirestore.instance.collection("customers");
  static CollectionReference ordersRef =
      FirebaseFirestore.instance.collection("orders");
  static CollectionReference logsRef =
      FirebaseFirestore.instance.collection("logs");
  static CollectionReference chatsRef =
      FirebaseFirestore.instance.collection('chats');
  static CollectionReference contactUsRef =
      FirebaseFirestore.instance.collection("contactUs");
  static CollectionReference userDevicesRef =
      FirebaseFirestore.instance.collection("userDevices");
  Future<void> createUser(
      Map<String, String> userData, String firebaseUserId) async {
    users.doc(firebaseUserId).set(userData).catchError((e) {});
  }

  getUserInfo(String email) async {
    return users.where("userEmail", isEqualTo: email).get().catchError((e) {});
  }

  Stream<QuerySnapshot> getChatHistory(String firebaseId) {
    int startTime =
        DateTime.now().add(const Duration(days: -40)).millisecondsSinceEpoch;
    return chatRooms
        .where('lastUpdated', isGreaterThan: startTime)
        .where('firebaseId', isEqualTo: firebaseId)
        .orderBy('lastUpdated', descending: true)
        .snapshots();
  }

  Future<void> addChatRoom(
      Map<String, dynamic> chatRoomDetails, String chatRoomId) {
    return chatRooms
        .doc(chatRoomId)
        .set(chatRoomDetails, SetOptions(merge: true))
        .catchError((e) {});
  }

  Stream<QuerySnapshot<Object>> getChats(
      String chatRoomId, bool isCustomerService) {
    int startTime =
        DateTime.now().add(const Duration(days: -5)).millisecondsSinceEpoch;
    return chatRooms
        .doc(chatRoomId)
        .collection("chats")
        .where('time', isGreaterThan: startTime)
        .where('isCustomerService', isEqualTo: !isCustomerService)
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<QuerySnapshot>? getOthersLatestChats(
      String chatRoomId, bool isCustomerService, int startTime) {
    try {
      return chatRooms
          .doc(chatRoomId)
          .collection("chats")
          .where('time', isGreaterThan: startTime)
          .where('isCustomerService', isEqualTo: !isCustomerService)
          .orderBy('time', descending: true)
          .get();
    } catch (e) {
      return null;
    }
  }

  Future<bool> addStoreMessage(String message, int storeId, int customerId,
      int sentBy, String phoneNumber) async {
    try {
      int time = DateTime.now().toUtc().microsecondsSinceEpoch;
      await stores
          .doc('$storeId'.padLeft(10, '0'))
          .collection("chats")
          .doc(phoneNumber)
          .collection('messages')
          .doc(getChatMessageId(time))
          .set({
        'message': message,
        'time': time,
        'storeId': storeId,
        'sentBy': sentBy,
        'customerId': customerId,
        'isRead': false
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> addCancelledOrders(
      Map<String, dynamic> details, int orderId, String phoneNumber) async {
    try {
      int time = DateTime.now().toLocal().microsecondsSinceEpoch;
      details['time'] = time;
      await ordersRef
          .doc('$orderId'.padLeft(10, '0'))
          .collection("cancellations")
          .doc(phoneNumber)
          .set(details);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> addStoreContact(int storeId, bool lastUpdatedByCustomer,
      String phoneNumber, Map<String, dynamic> details) {
    try {
      details['lastUpdatedByCustomer'] = lastUpdatedByCustomer;
      stores
          .doc('$storeId'.padLeft(10, '0'))
          .collection("chats")
          .doc(phoneNumber)
          .set(details, SetOptions(merge: true));
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStoreChatMessages(
      int storeId, int startTime, String phoneNumber) {
    return stores
        .doc('$storeId'.padLeft(10, '0'))
        .collection("chats")
        .doc(phoneNumber)
        .collection('messages')
        .where('time', isGreaterThan: startTime)
        .orderBy('time', descending: true)
        .limit(20)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStoreChatMessagesSnapshot(
      int storeId, int startTime) {
    final storesChatsRef =
        stores.doc('$storeId'.padLeft(10, '0')).collection("chats");
    return storesChatsRef
        .where('time', isGreaterThan: startTime)
        .orderBy('time', descending: true)
        .limit(20)
        .snapshots();
  }

  Future<QuerySnapshot> getOrders(String itemId, String buyerId,
      {bool isCheckingOrder = true}) async {
    return isCheckingOrder
        ? ordersRef
            .where("orderStatus", isNotEqualTo: "Sold")
            .where("buyerId", isEqualTo: buyerId)
            .where("itemId", isEqualTo: itemId)
            .limit(1)
            .get()
        : ordersRef
            .where("orderStatus", isNotEqualTo: "Sold")
            .where("buyerId", isEqualTo: buyerId)
            .get();
  }

  Future<QuerySnapshot> getSellersOrders(String sellerId) async {
    return ordersRef
        .where("orderStatus", isNotEqualTo: "Sold")
        .where("sellerId", isEqualTo: sellerId)
        .get();
  }

  deleteOrder(String orderId, int actualSoldTime, String actualOutcome) {
    Map<String, dynamic> updates = {
      'actualSoldTime': actualSoldTime,
      "orderStatus": "Sold",
      "actualOutcome": actualOutcome
    };
    return ordersRef.doc(orderId).update(updates);
  }

  deleteMessage(String chatRoomId, String messageId) {
    return chatRooms
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .delete();
  }

  Future<void> addMessage(
      String chatRoomId, Map<String, dynamic> chatMessageData) {
    final messageId = getChatMessageId(chatMessageData['time']);
    return chatRooms
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(chatMessageData, SetOptions(merge: true))
        .catchError((e) {});
  }
}
