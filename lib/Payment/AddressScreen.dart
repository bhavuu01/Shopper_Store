import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Address.dart';
import 'AddressModel.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.source,
  });

  final String source;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int activeStepIndex = 0;
  List<String> stepTitles = ['Address', 'Payment'];
  List<AddressItem> addressItem = [];
  AddressItem selectedAddress =
  AddressItem(address: '', name: '', phone: '', id: '');
  String selectedPaymentMethod = '';
  double subtotal = 0;
  double totalAmount = 0;

  // final _razorpay = Razorpay();

  // @override
  // void initState() {
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  //
  //   super.initState();
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Do something when payment succeeds
  //   createOrder();
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackbarMessage(
  //       iconData: Icons.error_outline_rounded,
  //       title: 'Oops. An Error Occurred',
  //       subtitle: 'Please try after some time.',
  //       backgroundColor: Theme.of(context).colorScheme.errorContainer,
  //       context: context,
  //     ),
  //   );
  // }

  void handleContinue() {
    if (activeStepIndex < steps().length - 1) {
      activeStepIndex += 1;
      setState(() {});
    }
  }

  void handleCancel() {
    if (activeStepIndex == 0) {
      // If on the first step, you can handle it as needed, e.g., navigate back.
      Navigator.of(context).pop();
    } else {
      // If on other steps, go back to the previous step.
      activeStepIndex -= 1;
      setState(() {});
    }
  }

  void createOrder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not logged in
        return;
      }

      // final CollectionReference ordersCollection =
      // FirebaseFirestore.instance.collection('Orders');
      // final CollectionReference wishlistCollection =
      // FirebaseFirestore.instance.collection('Wishlist');
      //
      // // Create a Firestore transaction to increment the last order ID
      // final DocumentReference lastOrderIdRef =
      // FirebaseFirestore.instance.collection('metadata').doc('lastOrderId');
      // final DocumentSnapshot lastOrderIdDoc = await lastOrderIdRef.get();

      // if (!lastOrderIdDoc.exists) {
      //   // Initialize the last order ID if it doesn't exist
      //   await lastOrderIdRef.set({'orderId': 0});
      // }

      transactionHandler(transaction) async {
        // final orderIdData = lastOrderIdDoc.data() as Map<String, dynamic>?;
        // final orderId = (orderIdData != null) ? orderIdData['orderId'] : 0;

        // final newOrderId = orderId + 1;

        // Update the last order ID
        // transaction.update(lastOrderIdRef, {'orderId': newOrderId});
        final orderDataForUser = {
          // 'OrderId': newOrderId,
          'Time': FieldValue.serverTimestamp(),
          'UserName': selectedAddress.name,
          'UserPhoneNumber': selectedAddress.phone,
          'UserEmail': user.email,
          'Address': selectedAddress.address,
          'PaymentMethod': selectedPaymentMethod.trim(),
          // 'Items': cartItemsData,
          'Amount': totalAmount.toString(),
        };

        final orderDataForAdmin = {
          // 'OrderId': newOrderId,
          'Time': FieldValue.serverTimestamp(),
          'UserName': selectedAddress.name,
          'UserPhoneNumber': selectedAddress.phone,
          'UserEmail': user.email,
          'Address': selectedAddress.address,
          'PaymentMethod': selectedPaymentMethod.trim(),
          // 'Items': cartItemsData,
          'Amount': totalAmount.toString(),
          'OrderStatus': 'Order Placed'.toString(),
        };

        // // Add the order to the Orders collection
        // transaction.set(
        //     ordersCollection.doc(newOrderId.toString()), orderDataForAdmin);
        //
        // // Add the order to the user's Orders collection
        // transaction.set(
        //     wishlistCollection
        //         .doc(user.email)
        //         .collection('Orders')
        //         .doc(newOrderId.toString()),
        //     orderDataForUser);

        // Clear the cart collection
        // Assuming your cart collection is named 'Cart' under the user's document
        await FirebaseFirestore.instance
            .collection('Favorites')
            .doc(user.email)
            .collection('ShoppingCart')
            .get()
            .then((querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
      }

      await FirebaseFirestore.instance.runTransaction(transactionHandler);

      if (!context.mounted) {
        return;
      }
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const OrderConfirmScreen(),
      //   ),
      // );
    } catch (e) {
      debugPrint('Error creating order: $e');
      // Re-throw the exception so it can be handled in the caller
      rethrow;
    }
  }

  List<Step> steps() =>
      [
        Step(
          state: activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
          isActive: activeStepIndex >= 0,
          title: Text(
            'Address',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme
                .of(context)
                .colorScheme
                .secondary),
          ),
          content: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const Address(),
                    //   ),
                    // );
                  },
                  leading: Icon(
                    Icons.add,
                    size: 15,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                  ),
                  title: Text(
                    'Add a new address',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: Theme
                      .of(context)
                      .colorScheme
                      .onSecondary,
                ),
                const SizedBox(height: 15),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection('Addresses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final data = snapshot.data!.docs;
                    addressItem =
                        data.map((e) => AddressItem.fromJson(e)).toList();

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressItem.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              width: 0.5,
                            ),
                          ),
                          child: Stack(
                            children: [
                              RadioListTile(
                                value: addressItem[index],
                                groupValue: selectedAddress,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAddress = value!;
                                  });
                                },
                                title: Text(
                                  addressItem[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addressItem[index].address,
                                      textAlign: TextAlign.justify,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      addressItem[index].phone,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.76,
                                bottom:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.11,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Address(
                                              addressItem: addressItem[index],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.025,
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onSecondary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edit',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Step(
        //   state: activeStepIndex <= 1 ? StepState.indexed : StepState.complete,
        //   isActive: activeStepIndex >= 1,
        //   title: Text(
        //     'Payment',
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodyMedium!
        //         .copyWith(color: Theme.of(context).colorScheme.secondary),
        //   ),
        //   content: Column(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Theme.of(context).colorScheme.primary,
        //             width: 0.5,
        //           ),
        //         ),
        //         child: ListTile(
        //           onTap: () {
        //             setState(() {
        //               selectedPaymentMethod = 'Cash on delivery';
        //             });
        //           },
        //           leading: Radio(
        //             value: 'Cash on delivery',
        //             groupValue: selectedPaymentMethod,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedPaymentMethod = value.toString();
        //               });
        //             },
        //           ),
        //           title: Text(
        //             'Cash on delivery',
        //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                   color: Theme.of(context).colorScheme.secondary,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Theme.of(context).colorScheme.primary,
        //             width: 0.5,
        //           ),
        //         ),
        //         child: ListTile(
        //           onTap: () {
        //             setState(() {
        //               selectedPaymentMethod = 'Online payment';
        //             });
        //           },
        //           leading: Radio(
        //             value: 'Online payment',
        //             groupValue: selectedPaymentMethod,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedPaymentMethod = value.toString();
        //               });
        //             },
        //           ),
        //           title: Text(
        //             'Online payment',
        //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                   color: Theme.of(context).colorScheme.secondary,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: stepTitles[activeStepIndex],
        onCancel: handleCancel,
      ),
      body: Stepper(
        currentStep: activeStepIndex,
        controlsBuilder: (context, details) {
          return Container();
        },
        onStepContinue: handleContinue,
        onStepCancel: () {
          if (activeStepIndex == 0) {
            return;
          }
          activeStepIndex -= 1;
          setState(() {});
        },
        steps: steps(),
        type: StepperType.horizontal,
      ),
//     bottomNavigationBar: StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('Wishlist')
//           .doc(FirebaseAuth.instance.currentUser!.email)
//           .collection('Cart')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         final data = snapshot.data!.docs;
//         cartItem = data.map((e) => CartItem.fromJson(e)).toList();
//
//         if (cartItem.any((item) => item.timestamp == null)) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (widget.source == "ProductDetails") {
//           if (cartItem.any((item) => item.timestamp == null)) {
//             return const CircularProgressIndicator();
//           } else {
//             cartItem =
//                 cartItem.where((item) => item.timestamp != null).toList();
//             cartItem.sort(
//               (a, b) {
//                 debugPrint("timestamp_b...${b.timestamp}, itemid... ${b.id}");
//                 debugPrint(
//                     "timestamp_a...${a.timestamp}, itemid.... ${b.id}");
//
//                 if (b.timestamp == null && a.timestamp == null) {
//                   return 0;
//                 } else if (b.timestamp == null) {
//                   return -1;
//                 } else if (a.timestamp == null) {
//                   return 1;
//                 } else {
//                   return b.timestamp!.compareTo(a.timestamp!);
//                 }
//               },
//             );
//             cartItem = cartItem.take(1).toList();
//           }
//         }
//
//         String getProductNames(List<CartItem> items) {
//           List<String> productNames =
//               items.map((item) => item.Product).toList();
//           return productNames.join(", ");
//         }
//
//         subtotal = calculateSubtotal(cartItem);
//         double discount = calculateDiscount(cartItem);
//         double deliveryCharges = calculateDeliveryCharges(subtotal);
//         totalAmount = subtotal - discount + deliveryCharges;
//
//         return BottomAppBar(
//           color: Theme.of(context).colorScheme.onSecondary,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       '₹${subtotal.toStringAsFixed(0)}',
//                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                             color: Theme.of(context).colorScheme.onBackground,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       '₹${totalAmount.toStringAsFixed(0)}',
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                     ),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     if (selectedPaymentMethod == 'Cash on delivery') {
//                       createOrder();
//                     } else if (selectedPaymentMethod == 'Online payment') {
//                       String items = getProductNames(cartItem);
//
//                       var options = {
//                         'key': 'rzp_test_nLQYAWuOKvzENb',
//                         'amount': totalAmount * 100,
//                         'name': 'Unicorn',
//                         'description': items,
//                         'prefill': {
//                           'contact': selectedAddress.PhoneNumber.toString(),
//                           'email': FirebaseAuth.instance.currentUser!.email
//                               .toString(),
//                         }
//                       };
//
//                       _razorpay.open(options);
//                     } else {
//                       handleContinue();
//                     }
//                   },
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     width: MediaQuery.of(context).size.width * 0.35,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Theme.of(context).colorScheme.secondary),
//                     child: Center(
//                       child: Text(
//                         'Continue',
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .copyWith(
//                               color:
//                                   Theme.of(context).colorScheme.onSecondary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//
//       },
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onCancel;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onCancel,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
