import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:lansonndehplumbing/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:lansonndehplumbing/core/utils/firestore_db.dart';
import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/core/widgets/contact_form.dart';
import 'package:lansonndehplumbing/core/widgets/custom_web_icon_button.dart';
import 'package:lansonndehplumbing/core/widgets/default_loading_shimmer.dart';
import 'package:lansonndehplumbing/core/widgets/flutter_toasts.dart';
import 'package:lansonndehplumbing/models/chat_message_web.dart';
import 'package:lansonndehplumbing/screens/mobile_chat_window_web.dart';

class ChatWindow extends StatefulWidget {
  final void Function() onClose;
  final String? chatRoomId;

  const ChatWindow({Key? key, required this.onClose, this.chatRoomId})
      : super(key: key);

  @override
  ChatWindowState createState() => ChatWindowState();
}

class ChatWindowState extends State<ChatWindow> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Size? screenSize;
  final getIt = GetIt.I;
  final Logger logger = Logger('chatWindow');
  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    scrollController.animateTo(800,
        duration: const Duration(milliseconds: 900),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  onNewMessage(String message, String phoneNumber) async {
    message = message.trim();
    if (getNullableFirebaseAuthUser(context)?.isAdmin != true) {
      if (message.length > 1) {
        textEditingController.clear();
        await addStoreMessage(message, phoneNumber);
        _scrollDown();
      }
    } else {
      showErrorToast(
          'Admins cannot Sent a contat inquiry.\nPlease Respond To Chats');
    }
  }

  Future<bool> addStoreMessage(String message, String phoneNumber) async {
    try {
      int time = DateTime.now().microsecondsSinceEpoch;
      await FirestoreDB.chatsRef
          .doc(widget.chatRoomId ?? phoneNumber)
          .collection('messages')
          .doc(getChatMessageId(time))
          .set({
        'message': message,
        'time': time,
        'sentBy': phoneNumber,
        'sentByAdmin': getFirebaseAuthUser(context).isAdmin,
        'isRead': false,
      });
      return Future.value(true);
    } catch (e, stackTrace) {
      logger.severe(e, stackTrace);
      return Future.value(false);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStoreChatMessages(
      String phoneNumber) {
    int startTime =
        DateTime.now().add(const Duration(days: -14)).millisecondsSinceEpoch;
    return FirestoreDB.chatsRef
        .doc(widget.chatRoomId ?? phoneNumber)
        .collection('messages')
        .where('time', isGreaterThan: startTime)
        .orderBy('time', descending: true)
        .limit(20)
        .snapshots();
  }

  double getSafeHeight(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    List<dynamic> details = [mediaQuery, mediaQuery.size, mediaQuery.padding];
    // Get the padding values for the system bars
    EdgeInsets systemPadding = MediaQuery.of(context).padding;
    Logger('ScreenSize').fine('screenSize', details);
    // Calculate the safe area height by subtracting the top and bottom padding
    return screenHeight - systemPadding.bottom - systemPadding.top;
    //SafeHeight Excluding App Bar Height
    // // Get the app bar height
    // double appBarHeight = AppBar().preferredSize.height;

    // // Calculate the safe area height by subtracting the top and bottom padding and app bar height
    // double safeAreaHeight = screenHeight - systemPadding.top - systemPadding.bottom - appBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobileOnWeb = kIsWebOnMobile();
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: isMobileOnWeb
          ? getSafeHeight(context)
          : min(screenSize.height - 60, 650),
      width: isMobileOnWeb ? screenSize.width : 401,
      padding: isMobileOnWeb ? const EdgeInsets.symmetric(horizontal: 8) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: isMobileOnWeb
            ? null
            : const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        children: [
          if (FirebaseAuth.instance.currentUser?.isAnonymous != true)
            Container(
              height: 50,
              color: Colors.blue.shade200,
              child: Padding(
                padding: isMobileOnWeb
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Write your Message',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    CustomWebIconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 35,
                      ),
                      color: Colors.pink.shade50,
                      onPressed: () {
                        //context.read<FirebaseAuthBloc>().add(Logout());
                        widget.onClose();
                      },
                    )
                  ],
                ),
              ),
            ),
          if (FirebaseAuth.instance.currentUser?.isAnonymous != true)
            Expanded(
              flex: 1,
              child: StreamBuilder<Object>(
                  stream: getStoreChatMessages(
                      FirebaseAuth.instance.currentUser!.phoneNumber!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const DefaultLoadingSchimmer();
                    } else {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('There are no messages'),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              'Sorry! An error has occurred. Please Try Refreshing.'),
                        );
                      } else {
                        final storeChats = (snapshot.data! as QuerySnapshot)
                            .docs
                            .map((e) {
                              var data = e.data()! as Map<String, dynamic>;
                              data['messageId'] = e.id;
                              return ChatMessageWeb.fromJson(data);
                            })
                            .toList()
                            .reversed
                            .toList();
                        if (storeChats.isEmpty) {
                          return const Center(
                            child: Text('There are no messages'),
                          );
                        }
                        return ListView.builder(
                            //shrinkWrap: true,
                            itemCount: storeChats.length,
                            padding: const EdgeInsets.all(8.0),
                            physics: const BouncingScrollPhysics(),
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              final message = storeChats[index];
                              final isMe = message.sentBy ==
                                  FirebaseAuth
                                      .instance.currentUser!.phoneNumber;
                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue
                                        : Colors.grey.shade700,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.message,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(message.time),
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }
                  }),
            ),
          if (FirebaseAuth.instance.currentUser?.isAnonymous == true)
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ContactForm(
                    includeContactReason: false,
                    header: "Provide Your Contact Details"),
              ),
            ),
          if (FirebaseAuth.instance.currentUser?.isAnonymous == false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Type your message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        onNewMessage(textEditingController.text,
                            FirebaseAuth.instance.currentUser!.phoneNumber!);
                      },
                      color: Colors.blue.shade100,
                      elevation: 6.0,
                      minWidth: 50.0,
                      height: 50.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Transform.rotate(
                        angle: -20 * pi / 180,
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({Key? key}) : super(key: key);

  @override
  FloatingChatButtonState createState() => FloatingChatButtonState();
}

class FloatingChatButtonState extends State<FloatingChatButton> {
  bool _isChatWindowOpen = false;

  void _toggleVisibility() {
    showErrorToast("May need to Navigate");
    if (kIsWebOnMobile()) {
      showErrorToast("Here is successful Moble Nave trial");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileChatWindowWeb(),
        ),
      );
    } else {
      setState(() {
        _isChatWindowOpen = !_isChatWindowOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOnMobile = kIsWebOnMobile();
    Widget button = FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileChatWindowWeb(),
          ),
        );
      },
      child: const Icon(
        Icons.chat,
        size: 30,
      ),
    );
    if (isOnMobile) {
      return button;
    }
    return Stack(
      children: [
        _isChatWindowOpen
            ? Positioned(
                bottom: 16,
                right: 16,
                child: ChatWindow(
                  onClose: _toggleVisibility,
                ),
              )
            : FloatingActionButton(
                onPressed: _toggleVisibility,
                child: const Icon(
                  Icons.chat,
                  size: 30,
                ),
              )
      ],
    );
  }
}
