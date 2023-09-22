import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lansonndehplumbing/core/utils/constants.dart';
import 'package:lansonndehplumbing/models/plumbing_menu_items.dart';
import 'package:lansonndehplumbing/screens/my_image_screen.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' show window;
import 'package:url_launcher/url_launcher.dart';
import 'package:lansonndehplumbing/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:lansonndehplumbing/core/utils/firestore_db.dart';
import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/core/utils/strings.dart';
import 'package:lansonndehplumbing/core/utils/views_and_order_types.dart';
import 'package:lansonndehplumbing/core/widgets/action_button.dart';
import 'package:lansonndehplumbing/core/widgets/contact_form.dart';
import 'package:lansonndehplumbing/core/widgets/custom_web_icon_button.dart';
import 'package:lansonndehplumbing/core/widgets/default_loading_shimmer.dart';
import 'package:lansonndehplumbing/core/widgets/display_chat_room_details.dart';
import 'package:lansonndehplumbing/core/widgets/flutter_toasts.dart';
import 'package:lansonndehplumbing/core/widgets/hours_widget.dart';
import 'package:lansonndehplumbing/core/widgets/fade_in_dart.dart';
import 'package:lansonndehplumbing/core/widgets/new_menu_item_card.dart';
import 'package:lansonndehplumbing/core/widgets/order_details_widget.dart';
import 'package:lansonndehplumbing/core/widgets/progress_indicator.dart';
import 'package:lansonndehplumbing/core/widgets/respond_to_contact_us.dart';
import 'package:lansonndehplumbing/core/widgets/select_order_type.dart';
import 'package:lansonndehplumbing/models/chat_room_details.dart';
import 'package:lansonndehplumbing/models/contact_inquiries.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

import 'package:lansonndehplumbing/firebase_options.dart';
import 'package:lansonndehplumbing/models/custom_auth_provider.dart';
import 'package:lansonndehplumbing/models/firebase_auth_user.dart';
import 'package:lansonndehplumbing/models/ordered_item.dart';
import 'package:lansonndehplumbing/repository/firebase/firebase_services.dart';
import 'package:lansonndehplumbing/repository/service_locator.dart';
import 'package:lansonndehplumbing/screens/mobile_chat_window_web.dart';
import 'package:lansonndehplumbing/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lansonndehplumbing/web_chat/web_chat.dart';

import 'models/chat_message.dart';

//flutter clean && flutter pub get && flutter build web --release && firebase deploy
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        host = host.toLowerCase();
        var res = RegExp(r"[a-z]+").allMatches(host).map((m) => m[0]).toList();
        return res.contains('dukafoods') ||
            res.contains('googleapis') ||
            res.contains('wa') ||
            res.contains('me') ||
            res.contains('s3') ||
            res.contains('amazon') ||
            host.contains('lansonndehplumbing');
      };
  }
}

Future setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(CustomAuthProviderAdapter());
  Hive.registerAdapter(FirebaseAuthUserAdapter());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL; // defaults to Level.INFO

  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupHive();
  await ServiceLocator().setupLocator();
  final getIt = GetIt.I;
  await getIt.allReady();

  Logger.root.onRecord.listen((record) async {
    final firestoreInst = FirebaseFirestore.instance;
    Map<String, dynamic> data = {
      'level': record.level.name,
      'loggerName': record.loggerName,
      'error': record.error?.toString(),
      'time': record.time.millisecondsSinceEpoch,
      'message': record.message,
      'stackTrace': record.stackTrace?.toString(),
      'zone': record.zone?.toString(),
      'sequenceNumber': record.sequenceNumber,
      'object': record.object?.toString(),
    };
    await firestoreInst
        .collection('logs')
        .doc(record.time.millisecondsSinceEpoch.toString())
        .set(data)
        .catchError((err, stactrace) async {
      await Future.delayed(const Duration(seconds: 5));
      await firestoreInst
          .collection('logs')
          .doc(record.time.millisecondsSinceEpoch.toString())
          .set(data);
    });
  });
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<FirebaseAuthBloc>(
          create: (BuildContext context) =>
              FirebaseAuthBloc()..add(AutoLogin()),
        ),
      ],
      child: BlocListener<FirebaseAuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state is Authenticated) {
            print('State is Authenticated');
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: Strings.appName)),
              (route) => false,
            );
          }
          if (state is UnAuthenticated) {
            print('State is UnAuthenticated');
            FirebaseService()
                .firebaseAuthInst
                .signInAnonymously()
                .then((user) {});
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: Strings.appName)),
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          title: Strings.appName,
          navigatorKey: navigatorKey,
          navigatorObservers: [
            routeObserver,
          ],
          home: const SplashScreen(appName: Strings.appName),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenView currentView = ScreenView.home;
  OrderType orderType = OrderType.fixtures;
  final logger = Logger('MyHomePage');

  OrderedMenuItems orderedMenuItems = OrderedMenuItems(orderedMenuItems: []);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isWebOnMobile = kIsWebOnMobile();
    bool isWebOnMobileSafe = kIsWebOnMobile() || screenSize.width < 450;
    final storeImage = Image.asset(
      'assets/images/launcher_icon.png',
      fit: BoxFit.fitHeight,
    );
    var currentUser = getNullableFirebaseAuthUser(context);

    const appNameWidget = Text(
      Strings.appName,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink),
    );
    return Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!isWebOnMobileSafe) ...[
                          appNameWidget,
                          storeImage,
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: HoursWidget(
                              isOnMobile: isWebOnMobile,
                            ),
                          ),
                        ],
                        if (isWebOnMobileSafe) ...[
                          storeImage,
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 25, bottom: 2.0),
                            child: Column(
                              children: [
                                appNameWidget,
                                const Spacer(),
                                HoursWidget(
                                  isOnMobile: isWebOnMobile,
                                ),
                              ],
                            ),
                          )
                        ],
                        // ActionButton(
                        //     text: 'test me',
                        //     maxWidth: 300,
                        //     color: Colors.red,
                        //     onPressed: () async {
                        //       print(orderType.toString());
                        //     }),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          "Home, Menu, Respond To Chats, Orders, Contact, About"
                              .split(', ')
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      switch (e) {
                                        case 'Home':
                                          {
                                            currentView = ScreenView.home;
                                          }
                                          break;
                                        case 'Menu':
                                          {
                                            currentView = ScreenView.menu;
                                          }
                                          break;
                                        case 'About':
                                          {
                                            currentView = ScreenView.about;
                                          }
                                          break;
                                        case 'Contact':
                                          {
                                            currentView = ScreenView.contact;
                                          }
                                          break;

                                        case 'Respond To Chats':
                                          {
                                            currentView =
                                                ScreenView.respondToChats;
                                          }
                                          break;
                                        default:
                                          {
                                            currentView = ScreenView.placeOrder;
                                          }
                                          break;
                                      }
                                      setState(() {});
                                    },
                                    child: e == 'Respond To Chats' &&
                                            currentUser?.isAdmin != true
                                        ? const SizedBox.shrink()
                                        : e == 'Orders' &&
                                                (currentUser == null ||
                                                    currentUser.isAdmin == true)
                                            ? const SizedBox.shrink()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Chip(
                                                    backgroundColor: currentView
                                                                .toString()
                                                                .split('.')
                                                                .last
                                                                .substring(
                                                                    0, 1) ==
                                                            e
                                                                .substring(0, 1)
                                                                .toLowerCase()
                                                        ? Colors
                                                            .lightGreenAccent
                                                            .shade100
                                                        : null,
                                                    label: Text(
                                                      e,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )),
                                              ),
                                  ))
                              .toList(),
                    ),
                  ),
                ),
              ),
              if (ScreenView.home == currentView)
                Container(
                  height: screenSize.height - 100,
                  //constraints: BoxConstraints(maxHeight: screenSize.height),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      color: Colors.transparent.withOpacity(0.4),
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome to Lanson Ndeh's Plumbing Shop.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors
                                  .lightGreenAccent, // Customize the text color
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Place your order for quality plumbing equipment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SelectOrderType(
                            onSmallOrderPressed: () {
                              currentView = ScreenView.menu;
                              orderType = OrderType.fixtures;
                              setState(() {});
                            },
                            onCateringOrderPressed: () {
                              currentView = ScreenView.menu;
                              orderType = OrderType.installation;
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () async {
                                String text =
                                    "Hello ${Strings.appName}, Customer Support,\nI would love to ..";
                                var phone = Strings.supportPhoneNumber
                                    .replaceAll(RegExp(r'\D'), '')
                                    .replaceAll(RegExp('^0+'), '');
                                final sb = StringBuffer('https://wa.me/$phone');
                                sb.write(
                                    '?text=${Uri.encodeQueryComponent(text)}');
                                final url = sb.toString();
                                //launch(sb.toString());
                                if (kIsWeb) {
                                  window.open(url, '_blank');
                                  return;
                                } else {
                                  try {
                                    await launch(url);
                                  } catch (error, stackTrace) {
                                    Logger('myHomePageWhatsapp')
                                        .severe(error, stackTrace);
                                    await Clipboard.setData(const ClipboardData(
                                        text: Strings.supportPhoneNumber));
                                    showSuccessToast(
                                        'Phone Number Copied to Clipboard');
                                    await HapticFeedback.vibrate();
                                  }
                                }
                              },
                              child: Container(
                                height: 51,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.lightGreenAccent.shade100
                                        .withOpacity(0.2),
                                    border: Border.all(
                                      color: Colors.lightGreenAccent,
                                      width: 1,
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomWebIconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        color: Colors.green,
                                        onPressed: () {}),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 36.0),
                                      child: Text(
                                        Strings.supportPhoneNumber,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if ([ScreenView.menu].contains(currentView))
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 110, minHeight: 50),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: const Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'All Orders are placed on this website and Picked Up at ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                      Text(
                        Strings.shopPickupAddress,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              if ([ScreenView.placeOrder].contains(currentView))
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 110, minHeight: 50),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: const Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'You will need to pick up in about 30 minutes at ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 17),
                      ),
                      Text(
                        Strings.shopPickupAddress,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              if (currentView == ScreenView.about)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getPadding(MediaQuery.of(context).size,
                          forForm: false)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.pinkAccent.withOpacity(0.2),
                            border:
                                Border.all(color: Colors.pinkAccent, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval:
                                    const Duration(milliseconds: 2700)),
                            items: Constants.aboutImages
                                .map(
                                  (item) => Center(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(item,
                                        fit: BoxFit.cover, height: 300),
                                  )),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "When I graduated from School, I could not find a good shop where people could buy quality plumbing materials for their homes. I decided to start the Lanson Ndeh's Plumbing shop to solve this problem. I decided to set up a plumbing shop - Lanson Ndeh's Plumbing Shop to serve the Kampala community.",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "The shop performed well and when COVID 19 hit, I created this website to gather customer's orders. We have been increasing our inventory and are constantly updating this website with our inventory. If you do not find the plumbing materials you need for your project on this website, please feel free to write a message to us and we will help you find those items.",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Thank You.",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Azah Lanson Ndeh.",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (currentView == ScreenView.respondToChats)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        getPadding(MediaQuery.of(context).size, forForm: true),
                  ),
                  child: Container(
                    color: Colors.grey.shade200,
                    constraints: const BoxConstraints(
                      minHeight: 300,
                    ),
                    child: StreamBuilder<Object>(
                        stream: FirestoreDB.chatsRef
                            .where('lastUpdated',
                                isGreaterThan: DateTime.now()
                                    .add(const Duration(days: -14))
                                    .millisecondsSinceEpoch)
                            .orderBy('lastUpdated', descending: true)
                            .limit(20)
                            .snapshots(),
                        builder: (context, snapshot) {
                          const errorTextStyle =
                              TextStyle(color: Colors.black, fontSize: 19);
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingWidgetsListView(
                              numberOfLoaders: 3,
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Sorry! An error occured while Loading the Chats',
                                style: errorTextStyle,
                              ),
                            );
                          }
                          final chatRooms = !snapshot.hasData
                              ? [] as List<ChatRoomDetails>
                              : (snapshot.data! as QuerySnapshot).docs.map((e) {
                                  var data = e.data()! as Map<String, dynamic>;
                                  data['messageId'] = e.id;
                                  return ChatRoomDetails.fromJson(data);
                                }).toList();
                          if (chatRooms.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'There are not Contact or Chat Messages To Respond To',
                                  style: errorTextStyle,
                                ),
                              ),
                            );
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: chatRooms
                                .map(
                                  (chatRoom) => ChatRoomDetailsWidget(
                                    chatRoomDetails: chatRoom,
                                    key: Key(chatRoom.customerPhone),
                                  ),
                                )
                                .toList(),
                          );
                        }),
                  ),
                ),
              if (currentView == ScreenView.placeOrder) ...[
                if (currentUser?.isAdmin != true && orderedMenuItems.hasItems())
                  ContactForm(
                    header: 'Place Your Order',
                    includeContactReason: true,
                    orderedMenuItems: orderedMenuItems,
                    orderType: orderType,
                  ),
                if (currentUser != null)
                  OrderDetailsWidget(
                    isAdmin: currentUser.isAdmin,
                  ),
              ],
              if (currentView == ScreenView.contact) ...[
                if (currentUser?.isAdmin != true)
                  const ContactForm(
                      header: 'Contact Us', includeContactReason: true),
                const SizedBox(
                  height: 16,
                ),
                if (currentUser != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getPadding(MediaQuery.of(context).size,
                          forForm: true),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors
                                  .black54, // specify the color of the underline
                              width: 2.0, // specify the width of the underline
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0, top: 5),
                          child: Center(
                            child: Text(
                              'Previous Contact Requests',
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ActionButton(
                  //     text: 'test me',
                  //     maxWidth: 300,
                  //     color: Colors.red,
                  //     onPressed: () async {
                  //       var s = await FirestoreDB.contactUsRef
                  //           .where('hasResponse', isEqualTo: false)
                  //           .orderBy('timestamp', descending: true)
                  //           .limit(20)
                  //           .get();
                  //     }),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getPadding(
                        MediaQuery.of(context).size,
                        forForm: true,
                      ),
                    ),
                    child: StreamBuilder<Object>(
                        stream: !getFirebaseAuthUser(context).isAdmin
                            ? FirestoreDB.contactUsRef
                                .where('phoneNumber',
                                    isEqualTo: getFirebaseAuthUser(context)
                                        .phoneNumber)
                                .orderBy('timestamp', descending: true)
                                .limit(20)
                                .snapshots()
                            : FirestoreDB.contactUsRef
                                .where('hasResponse', isEqualTo: false)
                                .orderBy('timestamp', descending: true)
                                .limit(20)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingProgressIndicator();
                          } else {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text('There are no Previous Inquires'),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    'Sorry! An error has occurred. Please Try Refreshing.'),
                              );
                            } else {
                              final contactInquires =
                                  (snapshot.data! as QuerySnapshot)
                                      .docs
                                      .map((e) {
                                        var data =
                                            e.data()! as Map<String, dynamic>;

                                        data['inquiryId'] = e.id;
                                        return ContactInquiry.fromJson(data);
                                      })
                                      .toList()
                                      .reversed
                                      .toList();
                              if (contactInquires.isEmpty) {
                                return const Center(
                                  child: Text('There are no Previous Inquires'),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: contactInquires
                                    .map(
                                      (inquiry) => ContactUsRespond(
                                        inquiry: inquiry,
                                        key: Key(inquiry.inquiryId),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          }
                        }),
                  ),
                ]
              ],
              if ([ScreenView.menu].contains(currentView))
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPadding(MediaQuery.of(context).size),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    itemCount: getMenuItems(orderType).length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getConstrainedWidth(
                          MediaQuery.of(context).size, 1250),
                      childAspectRatio: 1.3,
                    ),
                    itemBuilder: (context, index) {
                      final currentItem = getMenuItems(orderType)[index];
                      return NewMenuItemCard(
                          orderedMenuItems: orderedMenuItems,
                          menuItem: currentItem,
                          onItemAdded: () {
                            if (currentUser?.isAdmin == true) {
                              showSuccessToast(
                                  'Admins cannot be allowed to place Orders');
                              currentView = ScreenView.placeOrder;
                              setState(() {});
                              return;
                            } else if (currentUser?.currentOrderId != null) {
                              showSuccessToast('You already have an order.');
                              currentView = ScreenView.placeOrder;
                              setState(() {});
                              return;
                            } else {
                              orderedMenuItems.addItem(currentItem);
                              setState(() {});
                            }
                          },
                          onItemRemoved: () {
                            orderedMenuItems.removeItem(currentItem);
                            setState(() {});
                          },
                          key: Key(index.toString()));
                    },
                  ),
                ),
              const SizedBox(
                height: 100,
              ),
              Container(
                height: 300,
                color: Colors.pinkAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Follow Us on Social Media",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWebIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.envelopeCircleCheck,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            final Uri uri = Uri(
                              scheme: 'mailto',
                              path: Strings.shopEmailAddress,
                              query:
                                  'subject=Inquiries%20About%20Lanson%20Ndeh%27s%20Plumbing%20Shop',
                            );
                            if (kIsWeb) {
                              window.open(uri.toString(), '_blank');
                              return;
                            } else {
                              try {
                                await launchUrl(uri);
                              } catch (error, stackTrace) {
                                Logger('myHomePageEmail')
                                    .severe(error, stackTrace);
                                await Clipboard.setData(const ClipboardData(
                                    text: Strings.shopEmailAddress));
                                showSuccessToast('Email Copied to Clipboard');
                                await HapticFeedback.vibrate();
                              }
                            }
                          },
                        ),
                        CustomWebIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.tiktok,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.pink.shade200,
                          onPressed: () {
                            if (kIsWeb) {
                              window.open(Strings.tikTokLink, '_blank');
                              return;
                            } else {
                              launchUrl(Uri.parse(Strings.tikTokLink));
                            }
                          },
                        ),
                        CustomWebIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.green,
                          onPressed: () {
                            if (kIsWeb) {
                              window.open(Strings.instangramLink, '_blank');
                              return;
                            } else {
                              launchUrl(Uri.parse(Strings.instangramLink));
                            }
                          },
                        ),
                        CustomWebIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            if (kIsWeb) {
                              window.open(Strings.facebookLink, '_blank');
                              return;
                            } else {
                              launchUrl(Uri.parse(Strings.facebookLink));
                            }
                          },
                        ),
                        CustomWebIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            String text =
                                "Hello ${Strings.appName}, Customer Support,\nI would love to ..";
                            var phone = Strings.supportPhoneNumber
                                .replaceAll(RegExp(r'\D'), '')
                                .replaceAll(RegExp('^0+'), '');
                            final sb = StringBuffer('https://wa.me/$phone');
                            sb.write('?text=${Uri.encodeQueryComponent(text)}');
                            final url = sb.toString();
                            //launch(sb.toString());
                            if (kIsWeb) {
                              window.open(url, '_blank');
                              return;
                            } else {
                              try {
                                await launch(url);
                              } catch (error, stackTrace) {
                                Logger('myHomePageWhatsapp')
                                    .severe(error, stackTrace);
                                await Clipboard.setData(const ClipboardData(
                                    text: Strings.supportPhoneNumber));
                                showSuccessToast(
                                    'Phone Number Copied to Clipboard');
                                await HapticFeedback.vibrate();
                              }
                            }
                          },
                        ),
                        // CustomWebIconButton(
                        //   icon: const Icon(
                        //     FontAwesomeIcons.person,
                        //     color: Colors.white,
                        //     size: 30,
                        //   ),
                        //   color: Colors.blue,
                        //   onPressed: () async {
                        //     int now = DateTime.now().millisecondsSinceEpoch;
                        //     logger.severe('Here is a test Logg');
                        //     // try {
                        //     //   var url =
                        //     //       'https://dukagas.s3.eu-south-1.amazonaws.com/chats/lansonndehplumbing.json';
                        //     //   var response = await http.get(Uri.parse(url));
                        //     //   var jsonMap = jsonDecode(response.body);
                        //     //   final map = Map<String, String>.from(
                        //     //       jsonMap as Map<String, dynamic>);

                        //     //   print('Json Map 1: $jsonMap');
                        //     //   print('Json map 3 $map');
                        //     //   print(
                        //     //       'Duration of request 1: ${DateTime.now().millisecondsSinceEpoch - now}');
                        //     // } catch (error, stackTrace) {
                        //     //   logger.shout(error, stackTrace);
                        //     //   print('Error Logged about $now');
                        //     // }
                        //     // prints the parsed JSON map

                        //     // final pass = String.fromEnvironment('EMAIL_PASSWORD');
                        //     // print(pass);
                        //   },
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 60),
                      //height: 60,
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () async {
                          String text =
                              "${Strings.developerOrganization} (email: ${Strings.developerEmail}, phone: ${Strings.developerPhoneNumber}),\nI would love to ..";
                          var phone = Strings.developerPhoneNumber
                              .replaceAll(RegExp(r'\D'), '')
                              .replaceAll(RegExp('^0+'), '');
                          final sb = StringBuffer('https://wa.me/$phone');
                          sb.write('?text=${Uri.encodeQueryComponent(text)}');
                          final url = sb.toString();
                          String developerContactsCopied =
                              'Developer Contacts Copied Copied to Clipboard';
                          final devLogger =
                              Logger('myHomePageDeveloperContact');
                          if (kIsWeb) {
                            try {
                              window.open(url, '_blank');
                              return;
                            } catch (error, stackTrace) {
                              devLogger.severe(error, stackTrace);
                              await Clipboard.setData(
                                const ClipboardData(
                                    text:
                                        '${Strings.supportPhoneNumber} ${Strings.developerPhoneNumber}'),
                              );
                              showSuccessToast(developerContactsCopied);
                              await HapticFeedback.vibrate();
                            }
                          } else {
                            try {
                              await launch(url);
                            } catch (error, stackTrace) {
                              devLogger.severe(error, stackTrace);
                              await Clipboard.setData(const ClipboardData(
                                  text:
                                      '${Strings.supportPhoneNumber} ${Strings.developerPhoneNumber}'));
                              showSuccessToast(developerContactsCopied);
                              await HapticFeedback.vibrate();
                            }
                          }
                        },
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    '©2023 Developed By: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.5,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    Strings.developerOrganization,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.5,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: orderedMenuItems.hasItems()
            ? (currentView != ScreenView.placeOrder
                ? FloatingActionButton(
                    onPressed: () async {
                      if (currentUser?.isAdmin == true) {
                        showErrorToast('Admins Cannot Place Orders.');
                      } else {
                        currentView = ScreenView.placeOrder;
                        setState(() {});
                      }
                    },
                    child: const WidgetFadeInTransition(
                      animationDurationInMilisecs: 2000,
                      canRepeat: false,
                      child: Icon(
                        FontAwesomeIcons.cartShopping,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null)
            : isWebOnMobile
                ? FloatingActionButton(
                    onPressed: () {
                      if (currentUser?.isAdmin == true) {
                        showErrorToast(
                            'Admins Cannot Write Messages. Please respond to Chats');
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileChatWindowWeb(
                                //onClose: () => Navigator.of(context).pop(),
                                ),
                          ),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.chat,
                      size: 30,
                      color: Colors.black,
                    ),
                  )
                : const FloatingChatButton());
  }
}
