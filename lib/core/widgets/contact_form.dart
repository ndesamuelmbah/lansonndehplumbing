import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:lansonndehplumbing/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:lansonndehplumbing/client/api_requests.dart';
import 'package:lansonndehplumbing/core/utils/constants.dart';
import 'package:lansonndehplumbing/core/utils/firestore_db.dart';
import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/core/utils/get_device_id.dart';
import 'package:lansonndehplumbing/core/utils/strings.dart';
import 'package:lansonndehplumbing/core/utils/text_styles.dart';
import 'package:lansonndehplumbing/core/utils/validate_email.dart';
import 'package:lansonndehplumbing/core/utils/views_and_order_types.dart';
import 'package:lansonndehplumbing/core/widgets/action_button.dart';
import 'package:lansonndehplumbing/core/widgets/flutter_toasts.dart';
import 'package:lansonndehplumbing/core/widgets/ordered_menu_items_summary.dart';
import 'package:lansonndehplumbing/core/widgets/progress_indicator.dart';
import 'package:lansonndehplumbing/models/env_vars.dart';
import 'package:lansonndehplumbing/models/firebase_auth_user.dart';
import 'package:lansonndehplumbing/models/ordered_item.dart';
import 'package:lansonndehplumbing/repository/service_locator.dart';

class ContactForm extends StatefulWidget {
  final String header;
  final bool includeContactReason;
  final OrderedMenuItems? orderedMenuItems;
  final OrderType? orderType;
  const ContactForm(
      {Key? key,
      required this.header,
      required this.includeContactReason,
      this.orderType,
      this.orderedMenuItems})
      : super(key: key);

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactReasonController = TextEditingController();
  final getIt = GetIt.I;
  bool isLoading = false;
  String? formSubmittedMessage;
  Logger logger = Logger('contactForm');
  bool isEmailReadOnly = false;
  bool isNameReadOnly = false;
  bool isPhoneReadOnly = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _contactReasonController.dispose();
    if (widget.orderedMenuItems != null &&
        widget.orderedMenuItems!.hasItems()) {
      logger = Logger('contactFormCreateOrder');
    }
    super.dispose();
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    var timeNow = DateTime.now();
    int lastPingTime =
        getIt<GeneralBox>().get(Constants.lastTimeApiWasPinged) ??
            timeNow.add(const Duration(minutes: -30)).millisecondsSinceEpoch;
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      final authUser = getNullableFirebaseAuthUser(context);
      if (authUser != null) {
        if (!authUser.email.endsWith('lansonndehplumbingapi.com')) {
          _emailController.text = authUser.email;
          isEmailReadOnly = true;
        }
        _nameController.text = authUser.displayName ?? '';
        isNameReadOnly = true;

        _phoneController.text = authUser.phoneNumber.replaceAll('+', '');
        isPhoneReadOnly = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
    if (timeNow.millisecondsSinceEpoch - lastPingTime > 5 * 60 * 1000) {
      ApiRequest.genericGet('ping_api/${user?.uid}').then((value) {
        getIt<GeneralBox>().put(Constants.lastTimeApiWasPinged,
            DateTime.now().millisecondsSinceEpoch);
      });
    } else {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.includeContactReason == false
            ? 5
            : getPadding(
                MediaQuery.of(context).size,
                forForm: true,
              ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.orderedMenuItems == null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.header,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (widget.orderedMenuItems?.hasItems() == true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    const Text(
                      'Note About Payment',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.orderType == OrderType.fixtures
                          ? "After placing your order, ${Strings.appName} will contact you with instructions on how to pay."
                          : "After placing your order, ${Strings.appName} will contact you with instructions on how to pay. You can also negotiate the price of your large order",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              OrderedMenuItemsSummary(
                orderedMenuItems: widget.orderedMenuItems!,
                title: "Order Summary",
              )
            ],
            const SizedBox(height: 8.0),
            Container(
              decoration: containerDecoration,
              child: TextFormField(
                controller: _nameController,
                readOnly: isNameReadOnly,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
                validator: validateName,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                controller: _phoneController,
                readOnly: isPhoneReadOnly,
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  contentPadding: EdgeInsets.all(8.0),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (RegExp(r"^\+?(256)?0?7[0-9]{8,8}$").hasMatch(value)) {
                    return null;
                  }
                  return "Enter a Valid UG phone number";
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: containerDecoration,
              child: TextFormField(
                  controller: _emailController,
                  readOnly: isEmailReadOnly,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    contentPadding: EdgeInsets.all(8.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    value = value.trim();
                    if (validateEmail(value) == null) {
                      return null;
                    }
                    return "Enter a Valid Email Or Leave Empty";
                  }),
            ),
            if (widget.includeContactReason) ...[
              const SizedBox(height: 16.0),
              Container(
                decoration: containerDecoration,
                child: TextFormField(
                    controller: _contactReasonController,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.orderedMenuItems == null
                          ? 'Contact Reason'
                          : "Delivery Note",
                      labelText: widget.orderedMenuItems == null
                          ? 'How soon can you deliver my order ...'
                          : "eg I need to pick up at 6:30 PM",
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return widget.includeContactReason
                            ? widget.orderedMenuItems == null
                                ? 'Please Enter A contact Reason'
                                : 'Please Include Delivery Note'
                            : null;
                      }
                      value = value.trim().replaceAll(RegExp(r'\s+'), ' ');
                      if (value.split(' ').length < 3) {
                        return 'Needs to be at least 4 words';
                      }
                      return value.length < 12 ? "Too Short" : null;
                    }),
              ),
            ],
            const SizedBox(height: 26.0),
            isLoading
                ? Visibility(
                    visible: isLoading,
                    child: const LoadingProgressIndicator(),
                  )
                : ActionButton(
                    backgroundColor: Colors.blue.shade200,
                    color: Colors.blue,
                    borderWidth: 2,
                    maxWidth: 400,
                    height: 50,
                    radius: 7,
                    horizontalPadding: 0,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (formSubmittedMessage != null) {
                        showSuccessToast(formSubmittedMessage!);
                      } else if (_formKey.currentState!.validate()) {
                        // Do something with the form data
                        String name = _nameController.text.trim();
                        String phone = _phoneController.text.trim();
                        String email = _emailController.text.trim();
                        String contactReason =
                            _contactReasonController.text.trim();
                        if (phone.startsWith('0')) {
                          phone = phone.substring(1);
                          phone = '+256$phone';
                        } else if (phone.startsWith('256')) {
                          print(phone[3]);
                          if (phone[3] == '0') {
                            phone = phone.substring(4);
                            phone = '+256$phone';
                          } else {
                            phone = '+$phone';
                          }
                        } else {
                          phone = '+256$phone';
                        }
                        final cu = getNullableFirebaseAuthUser(context);
                        Map<String, String> params = {
                          'phoneNumber': cu?.phoneNumber ?? phone,
                          'userName': cu?.displayName ?? name,
                          'skipFirestoreCheck': false.toString()
                        };
                        if (widget.includeContactReason &&
                            widget.orderedMenuItems == null) {
                          params['contactMessage'] = contactReason;
                        }
                        if (widget.orderedMenuItems?.hasItems() == true) {
                          params['deliveryMessage'] = contactReason;
                          params['orderType'] =
                              widget.orderType.toString().split('.').last;
                          params['orderedMenuItems'] = json.encode(widget
                              .orderedMenuItems!.orderedMenuItems
                              .map((e) {
                            var orderedMenuItem = e.menuItem.toJson();
                            orderedMenuItem['totalPrice'] =
                                e.menuItem.itemPrice * e.quantity;
                            orderedMenuItem['quantity'] = e.quantity;
                            return orderedMenuItem;
                          }).toList());
                        }
                        if (cu != null) {
                          params['email'] = cu.email;
                          params['uid'] = cu.uid;
                        }
                        if (email.isNotNullAndNotEmpty) {
                          params['email'] = email;
                        }
                        final userMap = await ApiRequest.genericPost(
                            'get_or_create_user',
                            params: params);
                        if (userMap != null) {
                          if (userMap.containsKey('currentOrderId') &&
                              widget.orderedMenuItems != null &&
                              widget.orderedMenuItems!.hasItems()) {
                            await HapticFeedback.vibrate();
                            showSuccessToast('Your Order has been created');
                          }
                          await FirebaseAuth.instance.signOut();
                          final FirebaseAuthUser firebaseAuthUser =
                              FirebaseAuthUser.fromJson(userMap);

                          getIt<GeneralBox>().put(
                              Constants.lastTimeUserWasExtracted,
                              DateTime.now().millisecondsSinceEpoch);
                          getIt<GeneralBox>()
                              .put(Constants.currentUser, userMap);
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.isNotEmpty
                                        ? email
                                        : firebaseAuthUser.email,
                                    password: EnvVars.EMAIL_PASSWORD);
                          } catch (err, stack) {
                            logger.severe(err, stack);
                          }
                          Map<String, dynamic> data = {
                            'lastUpdated':
                                DateTime.now().millisecondsSinceEpoch,
                            'customerPhone': firebaseAuthUser.phoneNumber,
                            'customerName': firebaseAuthUser.displayName,
                          };

                          if (widget.includeContactReason &&
                              widget.orderedMenuItems == null) {
                            data['lastContactMessage'] = contactReason;
                          } else if (widget.orderedMenuItems != null &&
                              widget.orderedMenuItems!.hasItems()) {
                            data['currentOrderId'] = userMap['currentOrderId'];
                          }
                          saveDeviceLoginInfo(firebaseAuthUser.phoneNumber);
                          if (mounted) {
                            context
                                .read<FirebaseAuthBloc>()
                                .add(Login(firebaseAuthUser));
                          }
                          if (widget.includeContactReason) {
                            formSubmittedMessage =
                                widget.orderedMenuItems == null
                                    ? 'We have Received Your Message'
                                    : 'Your Order has been created';
                          } else {
                            formSubmittedMessage = 'You are now Logged In';
                          }
                          showSuccessToast('You are now Logged In');
                        } else {
                          showSuccessToast('An Error Occurred');
                        }
                      } else {
                        showErrorToast('Please fill the required fields');
                      }

                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    text: 'Submit',
                  ),
          ],
        ),
      ),
    );
  }

  Future saveDeviceLoginInfo(String authPhoneNumber) async {
    var deviceInfo = await getDeviceInfo();
    final dateTime = DateTime.now().toIso8601String();
    deviceInfo['phoneNumber'] = authPhoneNumber;
    deviceInfo['dateTime'] = dateTime;
    await FirestoreDB.userDevicesRef.doc(dateTime).set(deviceInfo);
  }
}
