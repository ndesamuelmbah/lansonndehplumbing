// import 'dart:io' show File;

// import 'package:lansonndehplumbing/client/api_requests.dart';
// import 'package:lansonndehplumbing/core/utils/general_utils.dart';
// import 'package:lansonndehplumbing/core/widgets/custom_icon_button.dart';
// import 'package:lansonndehplumbing/core/widgets/flutter_toasts.dart';
// import 'package:lansonndehplumbing/models/get_images.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
// import '../bloc/auth/auth_bloc.dart';
// import '../core/widgets/action_button.dart';
// import '../core/widgets/rating_start.dart';
// import '../models/store_metrics_model.dart';
// import '../repository/order_summary/order_summary_model.dart';

// class AddReviewScreen extends StatefulWidget {
//   final int storeId;
//   final OrderSummary? orderSummary;
//   final String currencySymbol;
//   final Function(int) callback;
//   const AddReviewScreen(
//       {Key? key,
//       required this.storeId,
//       required this.orderSummary,
//       required this.currencySymbol,
//       required this.callback})
//       : super(key: key);

//   @override
//   State<AddReviewScreen> createState() => _AddReviewScreenState();
// }

// class _AddReviewScreenState extends State<AddReviewScreen> {
//   final _reviewController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   double _rating = 4.0;
//   bool isLoading = false;
//   bool isUpdate = false;
//   int reviewId = 0;
//   String? providedImage;
//   final fileName = const Uuid().v4();
//   final imagePicker = ImagePicker();
//   String currentReviewImages = '';
//   @override
//   void initState() {
//     getAndUpdateReview();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }

//   Future getAndUpdateReview() async {
//     final endPoint =
//         'get_user_review/${getAuthUser(context).userId}/${widget.storeId}';
//     await ApiRequest.genericGet(endPoint).then((resp) {
//       if (resp != null && resp['reviewData'] != null) {
//         final rawRev = resp['reviewData'] as Map<String, dynamic>;
//         if (!['not provided', '']
//             .contains(rawRev['reviewText'].toString().toLowerCase())) {
//           final Review review = Review.fromMap(rawRev);
//           _rating = review.reviewStar;
//           _reviewController.text = review.reviewText;
//           isUpdate = true;
//           reviewId = review.reviewId!;
//           setState(() {});
//         }
//         var imgs = rawRev['itemImages']?.toString();
//         if (imgs != null && imgs.length > 3) {
//           currentReviewImages = imgs.trim();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color activeColor = _rating >= 2 ? Colors.green : Colors.red;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.blue,
//         title: Text(Strings..reviewShop),
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Container(
//             alignment: Alignment.center,
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text(
//                     widget.orderSummary == null
//                         ? "How do you rate this shop?"
//                         : Strings
//                       ..itemsYouBought,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                 ),
//                 if (widget.orderSummary != null)
//                   Column(
//                     children: widget.orderSummary!.orderedItems
//                         .map((e) => Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 0.0, vertical: 5),
//                               child: Text(
//                                   "⚫ ${e.quantity} - ${e.itemName} ${getFormatedCurrency(widget.currencySymbol, e.itemPrice)} ea."),
//                             )))
//                         .toList(),
//                   ),
//                 const SizedBox(height: 14),
//                 SizedBox(
//                   height: 10,
//                   child: Slider(
//                       max: 5.0,
//                       min: 0.0,
//                       value: _rating,
//                       divisions: 10,
//                       label: '$_rating',
//                       activeColor: activeColor,
//                       onChanged: (val) {
//                         _rating = val;
//                         setState(() {});
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: buildRatingStar(_rating, '',
//                       size: 40, addPadding: false, expandChildren: true),
//                 ),
//                 const SizedBox(height: 20),
//                 Form(
//                   key: _formKey,
//                   child: TextFormField(
//                     controller: _reviewController,
//                     minLines: 2,
//                     maxLines: 3,
//                     maxLength: 198,
//                     textInputAction: TextInputAction.done,
//                     textCapitalization: TextCapitalization.sentences,
//                     decoration: InputDecoration(
//                       labelText: Strings..reviewHint,
//                       hintText: Strings..reviewHint,
//                       alignLabelWithHint: true,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4)),
//                     ),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (name) {
//                       if (name?.isEmpty == true) {
//                         return Strings..writeAReview;
//                       }
//                       return null;
//                     },
//                     //style: TextStyle(color: Colors.black, fontSize: 18),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (isLoading)
//                   const Center(
//                     child: SizedBox(
//                         height: 40,
//                         width: 40,
//                         child: CircularProgressIndicator()),
//                   ),
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.green.shade100,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomIconButton(
//                             borderColor: Colors.grey,
//                             color: Colors.grey.shade300,
//                             onPressed: () async {
//                               final perm = await Permission.camera.request();
//                               if ([
//                                 PermissionStatus.limited,
//                                 PermissionStatus.granted
//                               ].contains(perm)) {
//                                 final file = await GetImages.getImageFile(
//                                     imagePicker, ImageSource.camera);
//                                 if (file != null) {
//                                   providedImage = file;
//                                   setState(() {});
//                                 }
//                               } else if ([
//                                 PermissionStatus.denied,
//                                 PermissionStatus.restricted
//                               ].contains(perm)) {
//                                 showErrorToast(
//                                     'Please Grant Permissions to use Camera');
//                               } else if ([
//                                 PermissionStatus.denied,
//                                 PermissionStatus.restricted
//                               ].contains(perm)) {
//                                 showErrorToast(
//                                     'Please Grant Permmissions Setting\nStart > Settings > Privacy & security > Camera');
//                               }
//                             },
//                             icon: const Icon(
//                               FontAwesomeIcons.camera,
//                             ),
//                           ),
//                           const Text(
//                             'Add Image [Optional]',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black54),
//                           ),
//                           CustomIconButton(
//                             borderColor: Colors.grey,
//                             color: Colors.grey.shade300,
//                             onPressed: () async {
//                               final perm = await Permission.storage.request();
//                               if ([
//                                 PermissionStatus.limited,
//                                 PermissionStatus.granted
//                               ].contains(perm)) {
//                                 final file = await GetImages.getImageFile(
//                                     imagePicker, ImageSource.gallery);
//                                 if (file != null) {
//                                   providedImage = file;
//                                   setState(() {});
//                                 }
//                               } else if ([
//                                 PermissionStatus.denied,
//                                 PermissionStatus.restricted
//                               ].contains(perm)) {
//                                 showErrorToast(
//                                     'Please Grant Permissions to Gallery');
//                               } else if ([
//                                 PermissionStatus.denied,
//                                 PermissionStatus.restricted
//                               ].contains(perm)) {
//                                 showErrorToast(
//                                     'Please Grant Permmissions Setting\nSettings > Privacy > Permission manager > Files and media page');
//                               }
//                             },
//                             icon: const Icon(
//                               FontAwesomeIcons.fileImage,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 if (providedImage != null)
//                   Stack(
//                     children: [
//                       Image.file(File(providedImage!)),
//                       Positioned(
//                           right: 10,
//                           top: 10,
//                           child: CustomIconButton(
//                             color: Colors.grey.shade100,
//                             borderColor: Colors.grey,
//                             icon: const Icon(
//                               FontAwesomeIcons.trashCan,
//                               color: Colors.grey,
//                               size: 30,
//                             ),
//                             onPressed: () {
//                               providedImage = null;
//                               setState(() {});
//                             },
//                           ))
//                     ],
//                   ),
//                 const SizedBox(height: 400)
//               ],
//             ),
//           ),
//         ),
//       )),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 15, left: 18, right: 18),
//         child: ActionButton(
//             text: Strings..submit,
//             color: Colors.green,
//             backgroundColor: Colors.green.shade100,
//             fontWeight: FontWeight.bold,
//             onPressed: () async {
//               if (_rating < 0) {
//                 showErrorToast(Strings..putAStarRating);
//               } else if (_formKey.currentState?.validate() != true) {
//                 showErrorToast(Strings..writeAReview);
//               } else {
//                 isLoading = true;
//                 setState(() {});
//                 final user = getAuthUser(context);
//                 Map<String, String> params = {
//                   "reviewerId": user.userId.toString(),
//                   "reviewText": _reviewController.text.trim(),
//                   "reviewerName": user.userName,
//                   "reviewStar": _rating.toString(),
//                   "storeId": widget.storeId.toString(),
//                   "reviewDate": DateTime.now().toString(),
//                   "itemImages": currentReviewImages
//                 };
//                 if (providedImage != null) {
//                   final resp = await ApiRequest.postAnImage(
//                       fileName: fileName, imageFilePath: providedImage!);
//                   if (resp != null) {
//                     String itemImages = resp['url']?.toString() ?? '';
//                     if (currentReviewImages != '') {
//                       itemImages = '$itemImages,$currentReviewImages';
//                     }
//                     params['itemImages'] = itemImages;
//                   }
//                 }
//                 if (widget.orderSummary != null) {
//                   params["orderId"] = widget.orderSummary!.orderId.toString();
//                   params["itemIds"] = widget.orderSummary!.orderedItems
//                       .map((e) => e.itemId.toString())
//                       .toList()
//                       .join(',');
//                 }
//                 if (reviewId != 0) {
//                   params['reviewId'] = reviewId.toString();
//                   params['isUpdate'] = isUpdate.toString();
//                 }
//                 final value =
//                     await ApiRequest.genericPost('post_review', params: params);
//                 if (value != null) {
//                   showSuccessToast(Strings..reviewAdded);

//                   await Future.delayed(const Duration(milliseconds: 100));
//                   if (mounted) {
//                     Navigator.pop(context);
//                   }
//                 } else {
//                   showErrorToast(Strings..somethingWrong);
//                 }
//                 isLoading = false;
//                 setState(() {});
//               }
//             }),
//       ),
//     );
//   }
// }
