// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopperstoreuser/Payment/PaymentScreen.dart';
import 'AddressModel.dart';

class Address extends StatefulWidget {
  const Address({super.key, this.addressItem});

  final AddressItem? addressItem;

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

  int? _selectedAddressIndex;


  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phnController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool isSending = false;
  bool isExpanded = false;

  @override
  void initState() {
    if (widget.addressItem != null) {
      _selectedAddressIndex = 0;
      List<String> address = widget.addressItem!.address.split(',');
      String buildingName = '${address[0]}, ${address[1]}';
      String area = address[2];
      String landmark = address[3];
      String city = address[4];
      List<String> stateAndPinCode = address[5].split('-');
      String state = stateAndPinCode[0];
      String pinCode = stateAndPinCode[1];

      fullNameController.text = widget.addressItem!.name;
      phnController.text = widget.addressItem!.phone;
      buildingNameController.text = buildingName;
      areaController.text = area;
      landmarkController.text = landmark;
      cityValue = city;
      stateValue = state;
      pinCodeController.text = pinCode;
    }

    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phnController.dispose();
    buildingNameController.dispose();
    areaController.dispose();
    landmarkController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchLocationAndPopulateAddress() async {
    try {
      Position position = await _determinePosition();

      List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark[0];

      pinCodeController.text = place.postalCode ?? '';
      buildingNameController.text = place.name ?? '';
      areaController.text = place.subLocality ?? '';
      landmarkController.text = place.street ?? '';

      countryValue = place.country;
      stateValue = place.administrativeArea;
      cityValue = place.locality;
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  void _saveAddress() async {
    FocusScope.of(context).unfocus();
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isSending = true;
        });

        String fullName = fullNameController.text.trim();
        String phnNumber = phnController.text.trim();
        String address =
            '${buildingNameController.text.trim()}, ${areaController.text.trim()}, ${landmarkController.text.trim()}, ${cityValue.toString()}, ${stateValue.toString()} - ${pinCodeController.text.trim()}';

        if (widget.addressItem != null) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('Address')
              .doc(widget.addressItem!.id)
              .update({
            'name': fullName,
            "PhoneNumber": phnNumber,
            'address': address,
          });

          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        } else {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('Address')
              .add({
            'name': fullName,
            "PhoneNumber": phnNumber,
            'address': address,
          });

          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        }

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  PaymentScreen(address: address)),
        );
      }
    } catch (e) {
      debugPrint("Error saving product: $e");
    }

    fullNameController.clear();
    phnController.clear();
    pinCodeController.clear();
    buildingNameController.clear();
    areaController.clear();
    landmarkController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If the "Add New Address" field is expanded, collapse it and return false to prevent popping the screen
        if (isExpanded) {
          setState(() {
            isExpanded = false;
          });
          return false;
        }
        // Otherwise, allow popping the screen
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!isExpanded) // Show only if not expanded
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = true;
                      });
                    },
                    child: const Center(
                      child: Text(
                        '+ Add New Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                if (isExpanded) ...[
                  InputTextField(
                    controller: fullNameController,
                    lableText: 'Full Name',
                    hintText: 'John Jackson',
                    keyBordType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  InputTextField(
                    controller: phnController,
                    lableText: 'Phone Number',
                    hintText: '9876543210',
                    keyBordType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }

                      // Remove all non-numeric characters from the input
                      final numericValue =
                      value.replaceAll(RegExp(r'[^0-9]'), '');

                      // Check if the phone number is exactly 10 digits long
                      if (numericValue.length != 10) {
                        return 'Phone number should be 10 digits long';
                      }

                      // Check if the phone number starts with a valid prefix (e.g., 7, 8, or 9 for Indian mobile numbers)
                      if (!RegExp(r'^[789]').hasMatch(numericValue)) {
                        return 'Invalid phone number prefix';
                      }

                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputTextField(
                          controller: pinCodeController,
                          lableText: 'PinCode',
                          hintText: '380011',
                          keyBordType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the pincode';
                            }

                            // Check if the pincode is exactly 6 digits long
                            if (value.length != 6) {
                              return 'Pincode should be 6 digits long';
                            }

                            // Check if the pincode contains only digits
                            if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                              return 'Pincode should contain only digits';
                            }

                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: isSending
                              ? null
                              : () async {
                            await fetchLocationAndPopulateAddress();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(14),
                            height: MediaQuery.of(context).size.height * 0.045,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.gps_fixed,
                                    color:
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Use my location',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: CSCPicker(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                      selectedItemStyle:
                      Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      dropdownHeadingStyle:
                      Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      dropdownItemStyle:
                      Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      flagState: CountryFlag.DISABLE,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  InputTextField(
                    controller: buildingNameController,
                    lableText: 'House No., Building Name',
                    hintText: 'C/201, Gravity Victoria',
                    keyBordType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the building name';
                      }
                      return null;
                    },
                  ),
                  InputTextField(
                    controller: areaController,
                    lableText: 'Road Name, Area, Colony',
                    hintText: 'Street 9, Malad',
                    keyBordType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the area';
                      }
                      return null;
                    },
                  ),
                  InputTextField(
                    controller: landmarkController,
                    lableText: 'Nearby Famous Shop/Mall/Landmark',
                    hintText: 'Beside Palladium Mall',
                    keyBordType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the landmark';
                      }
                      return null;
                    },
                  ),
                  if (widget.addressItem != null)
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: InkWell(
                        onTap: isSending
                            ? null
                            : () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth
                                .instance.currentUser!.email)
                                .collection('Addresses')
                                .doc(widget.addressItem!.id)
                                .delete();

                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          } catch (e) {
                            debugPrint("Error fetching location: $e");
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          child: Center(
                            child: isSending
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                                : Text(
                              'Delete Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: InkWell(
                      onTap: isSending ? null : _saveAddress,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).colorScheme.onSecondary,
                        child: Center(
                          child: isSending
                              ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                              : Text(
                            'Save Address',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('Address')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final addresses = snapshot.data!.docs;
                        return Column(
                          children: addresses.asMap().entries.map((entry) {
                            final index = entry.key;
                            final doc = entry.value;
                            final addressData = doc.data() as Map<String, dynamic>;

                            return Card(
                              child: ListTile(
                                leading: Radio<int>(
                                  value: index,
                                  groupValue: _selectedAddressIndex,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedAddressIndex = value;
                                    });
                                  },
                                ),
                                title: Text(
                                  addressData['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(addressData['address']),
                                // Add any other details you want to display
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }
                ),
                ElevatedButton(
                  onPressed: _selectedAddressIndex != null
                      ? () async {
                    try {
                      // Retrieve the selected address data from Firestore
                      final snapshot = await FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection('Address')
                          .get();

                      // Check if the selected index is within bounds
                      if (_selectedAddressIndex! < snapshot.docs.length) {
                        // Retrieve the selected address data
                        final selectedAddressData = snapshot.docs[_selectedAddressIndex!].data() as Map<String, dynamic>;

                        // Construct the selected address string
                        final selectedAddress = selectedAddressData['address'];

                        // Navigate to the PaymentScreen and pass the selected address
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              address: selectedAddress,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print("Error fetching selected address: $e");
                    }
                  }
                      : null,
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? lableText;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final TextInputType keyBordType;

  const InputTextField(
      {super.key,
        required this.controller,
        this.lableText,
        required this.hintText,
        this.validator,
        this.prefixIcon,
        required this.keyBordType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: TextFormField(
          controller: controller,
          keyboardType: keyBordType,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
          decoration: InputDecoration(
            labelText: lableText,
            labelStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            prefixIcon: prefixIcon,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
              ),
            ),
          ),
          validator: validator),
    );
  }
}