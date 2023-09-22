import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:lansonndehplumbing/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:lansonndehplumbing/client/api_requests.dart';
import 'package:lansonndehplumbing/core/utils/firestore_db.dart';
import 'package:lansonndehplumbing/core/utils/general_utils.dart';
import 'package:lansonndehplumbing/core/utils/keys.dart';
import 'package:lansonndehplumbing/core/utils/text_styles.dart';
import 'package:lansonndehplumbing/core/widgets/action_button.dart';
import 'package:lansonndehplumbing/core/widgets/flutter_toasts.dart';
import 'package:lansonndehplumbing/core/widgets/ordered_menu_items_summary.dart';
import 'package:lansonndehplumbing/core/widgets/progress_indicator.dart';
import 'package:lansonndehplumbing/models/firebase_auth_user.dart';
import 'package:lansonndehplumbing/models/order_details.dart';
import 'package:lansonndehplumbing/models/order_status_web.dart';

final currentLogger = Logger('orderDetailsWidget');

class OrderDetailsWidget extends StatelessWidget {
  final bool isAdmin;

  const OrderDetailsWidget({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final user = getFirebaseAuthUser(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
      stream: !isAdmin
          ? FirebaseFirestore.instance
              .collection('orders')
              .where('phoneNumber', isEqualTo: user.phoneNumber)
              .orderBy('lastUpdatedTime', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('orders')
              .where('orderStatusIndex',
                  isLessThan: OrderStatusWeb.values
                      .indexOf(OrderStatusWeb.READY_FOR_PICKUP))
              .orderBy('orderStatusIndex', descending: false)
              .orderBy('lastUpdatedTime', descending: true)
              .limit(20)
              .snapshots(),
      builder: (BuildContext context, snapshot) {
        const emptyOrders = SizedBox(
          height: 200,
          child: Center(
            child: Text('There are not pending Orders'),
          ),
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return emptyOrders;
        }

        final orderData = snapshot.data!.docs.map((e) {
          var data = e.data()!;
          data['orderId'] = e.id;
          return OrderDetails.fromJson(data);
        }).toList();
        if (orderData.isEmpty) {
          return emptyOrders;
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPadding(MediaQuery.of(context).size, forForm: true),
          ),
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const BouncingScrollPhysics(),
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                return WebOrderItemSummary(
                  isAdmin: isAdmin,
                  orderItem: orderData[index],
                );
              }),
          // GridView.builder(
          //     shrinkWrap: true,
          //     primary: false,
          //     physics: const BouncingScrollPhysics(),
          //     itemCount: orderData.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 1,
          //       //getConstrainedWidth(MediaQuery.of(context).size, 1250),
          //       childAspectRatio: 0.8,
          //     ),
          //     itemBuilder: (context, index) {
          //       return WebOrderItemSummary(
          //         isAdmin: isAdmin,
          //         orderItem: orderData[index],
          //       );
          //     }),
        );
      },
    );
  }
}

class WebOrderItemSummary extends StatelessWidget {
  final OrderDetails orderItem;
  final bool isAdmin;
  const WebOrderItemSummary(
      {super.key, required this.orderItem, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final cancelController = TextEditingController();
    var orderStatus = orderItem.orderStatus;
    final finalOrderStatuses = [
      OrderStatusWeb.ORDER_ACCEPTED,
      OrderStatusWeb.ORDER_CANCELLED,
      OrderStatusWeb.READY_FOR_PICKUP
    ];
    final currentUser = getFirebaseAuthUser(context);
    bool canChangeOrderStatus =
        (currentUser.isAdmin && !finalOrderStatuses.contains(orderStatus)) ||
            (!currentUser.isAdmin &&
                ![
                  OrderStatusWeb.ORDER_CANCELLED,
                  OrderStatusWeb.READY_FOR_PICKUP,
                  OrderStatusWeb.ORDER_DELIVERED
                ].contains(orderStatus));
    var items = [
      [
        "Order Date",
        DateFormat('E, MMM d, y, h:mm a').format(orderItem.orderedDateTime)
      ],
      ['Order Status:', orderItem.orderStatus]
    ];
    if (isAdmin) {
      items.addAll([
        ['Ordered By', orderItem.userName],
        ['Customer Phone', orderItem.phoneNumber]
      ]);
    }
    items.add(['Payment Method', orderItem.modeOfPayment]);
    var externalContext = context;
    return Container(
      decoration: BoxDecoration(
          color: canChangeOrderStatus
              ? Colors.grey.shade200
              : orderStatus == OrderStatusWeb.ORDER_CANCELLED
                  ? Colors.red.shade200
                  : Colors.green.shade200,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          OrderedMenuItemsSummary(
              orderedMenuItems: orderItem.orderedMenuItems,
              title: 'Total Price'),

          const SizedBox(height: 16.0),
          // Add more order details as needed
          SeparatedTextCard(
            items: items,
          ),
          if (orderItem.orderCancellationMessage != null) ...[
            Card(
              elevation: 5,
              child: Container(
                constraints:
                    const BoxConstraints(minHeight: 50, maxHeight: 300),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Order Cancellation Reason',
                            textAlign: TextAlign.start,
                            style: SeparatedTextCard.style,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        orderItem.orderCancellationMessage!,
                        style: SeparatedTextCard.style,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
          canChangeOrderStatus
              ? Card(
                  elevation: 5,
                  color: Colors.green.shade400,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: orderStatus,
                      onChanged: (newOrderStatus) {
                        if (newOrderStatus != null &&
                            newOrderStatus != orderItem.orderStatus) {
                          final now = DateTime.now();
                          var currentOrderRef =
                              FirestoreDB.ordersRef.doc(orderItem.orderId);
                          var customersRef = FirestoreDB.customersRef
                              .doc(orderItem.phoneNumber);
                          int newStatusIndex =
                              OrderStatusWeb.values.indexOf(newOrderStatus);
                          int oldStatusIndex = OrderStatusWeb.values
                              .indexOf(orderItem.orderStatus);
                          Map<String, dynamic> updates = {
                            "lastUpdatedTime": now.millisecondsSinceEpoch,
                            "orderStatus": newOrderStatus,
                            "orderStatusIndex": newStatusIndex,
                            "orderId": orderItem.orderId,
                            'phoneNumber': orderItem.phoneNumber,
                          };
                          if (newStatusIndex < oldStatusIndex) {
                            showErrorToast(
                                'Order Status Cannot change from ${orderItem.orderStatus} to $newOrderStatus');
                            return;
                          }
                          if (newOrderStatus ==
                                  OrderStatusWeb.ORDER_DELIVERED &&
                              !currentUser.isAdmin) {
                            showErrorToast(
                                'Only the restaurant can mark an order as Delivered');
                            return;
                          } else if (newOrderStatus ==
                                  OrderStatusWeb.ORDER_DELIVERED &&
                              currentUser.isAdmin) {
                            Map<String, String> params = {
                              'deliveryDateTime': now.toString(),
                              'orderStatusIndex': newStatusIndex.toString(),
                              'orderByPhone': orderItem.phoneNumber,
                              'isAdmin': currentUser.isAdmin.toString(),
                              'newOrderStatus': newOrderStatus
                            };
                            Map<String, dynamic> customClaims = {
                              'currentOrderId': null,
                              'isAdmin': false
                            };
                            updates.forEach((key, value) {
                              params[key] = value.toString();
                            });

                            updates['deliveryDateTime'] = now.toString();
                            updates['currentOrderId'] = null;

                            currentOrderRef.set(
                                updates, SetOptions(merge: true));
                            customersRef.set({
                              'customClaims': customClaims,
                              'currentOrderId': null
                            }, SetOptions(merge: true)).then((value) async {
                              updateFirebaseUser(customersRef, externalContext);
                            });
                            ApiRequest.genericPost('update_order',
                                    params: params)
                                .then((value) {
                              if (value != null) {
                                showSuccessToast(
                                    'Order Status Updaed to $newOrderStatus');
                              }
                            }).catchError((error, stacktrace) {
                              currentLogger.severe(error, stacktrace);
                            });

                            return;
                          }

                          if (newOrderStatus ==
                                  OrderStatusWeb.READY_FOR_PICKUP &&
                              !currentUser.isAdmin) {
                            showErrorToast(
                                'Only the restaurant can mark an order as Ready For Pickup');
                            return;
                          } else if (newOrderStatus ==
                                  OrderStatusWeb.READY_FOR_PICKUP &&
                              currentUser.isAdmin) {
                            currentOrderRef.set(
                                updates, SetOptions(merge: true));
                            return;
                          }
                          if (newOrderStatus == OrderStatusWeb.ORDER_ACCEPTED &&
                              !currentUser.isAdmin) {
                            showErrorToast(
                                'Only the restaurant can Accept Orders');
                          } else if (newOrderStatus ==
                                  OrderStatusWeb.ORDER_ACCEPTED &&
                              currentUser.isAdmin) {
                            currentOrderRef.set(
                                updates, SetOptions(merge: true));
                            return;
                          }
                          if (newOrderStatus ==
                              OrderStatusWeb.ORDER_CANCELLED) {
                            // Only allow cancellation if order status is not 'Ready for Pickup'
                            if (!currentUser.isAdmin && oldStatusIndex > 2) {
                              showErrorToast(
                                  'This order cannot be canceled becaus it is ${orderItem.orderStatus}\n Scroll down and Contact Customer Support');
                              return;
                            } else {
                              updates['cancellationDateTime'] = now.toString();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  bool isLoading = false;
                                  return StatefulBuilder(
                                    builder: (context, setState) => AlertDialog(
                                      contentPadding: const EdgeInsets.all(10),
                                      title: const Text(
                                          'Are you sure you want to Cancel Order?'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 8.0),
                                          Container(
                                            decoration: containerDecoration,
                                            child: TextFormField(
                                              controller: cancelController,
                                              readOnly: false,
                                              minLines: 2,
                                              maxLines: 5,
                                              keyboardType: TextInputType.text,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Reason for Cancelling Order',
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.all(8.0),
                                              ),
                                              validator: (txt) {
                                                txt = txt?.trim() ?? '';
                                                if (txt.isEmpty) {
                                                  return 'Enter Cancellation Reason';
                                                }
                                                if (txt.length < 10) {
                                                  return 'Too short';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 25.0),
                                          isLoading
                                              ? const LoadingProgressIndicator()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ActionButton(
                                                      text: 'Do not Cancel',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      maxWidth: 140,
                                                      radius: 15,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ActionButton(
                                                      text: 'Yes, Cancel',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                      maxWidth: 140,
                                                      radius: 15,
                                                      onPressed: () {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        final orderCancellationMessage =
                                                            cancelController
                                                                .text
                                                                .trim();
                                                        if (orderCancellationMessage
                                                                .length >
                                                            9) {
                                                          updates['orderCancellationMessage'] =
                                                              orderCancellationMessage;

                                                          updates['cancellationDateTime'] =
                                                              now.toIso8601String();
                                                          currentOrderRef.set(
                                                              updates,
                                                              SetOptions(
                                                                  merge: true));
                                                          customersRef.set(
                                                              {
                                                                'currentOrderId':
                                                                    null,
                                                                'customClaims':
                                                                    {
                                                                  'isAdmin':
                                                                      false,
                                                                  'currentOrderId':
                                                                      null
                                                                },
                                                              },
                                                              SetOptions(
                                                                  merge:
                                                                      true)).then(
                                                              (value) async {
                                                            updateFirebaseUser(
                                                                customersRef,
                                                                externalContext);
                                                          });

                                                          Map<String, String>
                                                              params = <String,
                                                                  String>{};
                                                          updates.forEach(
                                                              (key, value) {
                                                            params[key] = value
                                                                .toString();
                                                            params['orderByPhone'] =
                                                                orderItem
                                                                    .phoneNumber;
                                                          });
                                                          params['newOrderStatus'] =
                                                              newOrderStatus;
                                                          params['isAdmin'] =
                                                              currentUser
                                                                  .isAdmin
                                                                  .toString();

                                                          ApiRequest.genericPost(
                                                                  'update_order',
                                                                  params:
                                                                      params)
                                                              .then((value) =>
                                                                  Navigator.pop(
                                                                      context))
                                                              .catchError((error,
                                                                  stacktrace) {
                                                            Logger('orderDetails')
                                                                .severe(error,
                                                                    stacktrace);
                                                          });
                                                        } else {
                                                          showErrorToast(
                                                              'Cancellation message is too short');
                                                        }
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        } else {
                          showErrorToast('You Order Status has not Changed');
                        }
                      },
                      items: OrderStatusWeb.values
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox(), // Hide dropdown if user is not admin
        ],
      ),
    );
  }

  Future updateFirebaseUser(customersRef, BuildContext ctx) async {
    final updatedUser = await customersRef.get();
    final firestoreUserMap = updatedUser.data()! as Map<String, dynamic>;
    final firestoreUserUser = FirebaseAuthUser.fromJson(firestoreUserMap);
    try {
      const sf = FlutterSecureStorage();
      await sf.write(
        key: Keys.firebaseAuthUser,
        value: jsonEncode(firestoreUserUser.toJson()),
      );
      ctx.read<FirebaseAuthBloc>().add(UpdateUser(firestoreUserUser));
    } catch (exception, stacktrace) {
      currentLogger.severe(exception, stacktrace);
    }
  }
}

class SeparatedTextCard extends StatelessWidget {
  final List<List<String>> items;
  const SeparatedTextCard({super.key, required this.items});

  static const style = TextStyle(
      fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
  @override
  Widget build(BuildContext context) {
    var listOfWidgets = items.map((strList) {
      return Card(
        elevation: 5,
        child: Container(
          constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
          //height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              //alignment: WrapAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: strList
                  .map((e) => Text(
                        e,
                        maxLines: 3,
                        style: style,
                      ))
                  .toList(),
            ),
          ),
        ),
      );
    }).toList();
    return Column(
      children: listOfWidgets,
    );
  }
}
