import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          if (userData.isEmpty) {
            return Center(child: Text('User data is empty'));
          }

          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Username'),
                  subtitle: Text(userData['Username'] ?? ''),
                ),
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(userData['Email'] ?? ''),
                ),
                ListTile(
                  title: Text('Mobile'),
                  subtitle: Text(userData['Mobile'] ?? ''),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(userData['Address'] ?? ''),
                ),
                ListTile(
                  title: Text('City'),
                  subtitle: Text(userData['City'] ?? ''),
                ),
                ListTile(
                  title: Text('State'),
                  subtitle: Text(userData['State'] ?? ''),
                ),
                ListTile(
                  title: Text('Zipcode'),
                  subtitle: Text(userData['Zipcode'] ?? ''),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
