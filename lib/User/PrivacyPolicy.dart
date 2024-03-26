import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Last updated: January 1, 2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Welcome to [Your App Name]! This privacy policy explains how [Your Company Name] collects, uses, and protects your personal information when you use our mobile application [Your App Name] (referred to as the "Service"). By using the Service, you agree to the collection and use of information in accordance with this policy.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'We may collect several types of information from and about users of our Service, including:\n\n- Personal Information: This may include your name, email address, phone number, shipping address, and payment information when you register for an account or make a purchase.\n\n- Usage Data: We may collect information on how you interact with the Service, such as pages visited, products viewed, and actions taken within the app.\n\n- Device Information: We may collect information about your mobile device, including device type, operating system version, unique device identifiers, and mobile network information.\n\nWe may use cookies and similar tracking technologies to collect information and improve our Service.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'We may use the information we collect for various purposes, including:\n\n- To provide and maintain the Service.\n\n- To process and fulfill orders, including billing and shipping.\n\n- To personalize your experience and improve our products and services.\n\n- To communicate with you, including responding to your inquiries and providing customer support.\n\n- To send you promotional materials and offers related to our products and services, unless you have opted out of receiving such communications.\n\n- To detect, prevent, and address technical issues and security vulnerabilities.\n\nWe will not sell, rent, or share your personal information with third parties except as described in this privacy policy or with your consent.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Data Security',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'We take reasonable measures to protect the security of your personal information from unauthorized access, use, alteration, and disclosure. However, please be aware that no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
              textAlign: TextAlign.justify,
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}
