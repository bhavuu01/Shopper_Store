import 'package:flutter/material.dart';


class NeedHelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Need Help'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'Frequently Asked Questions',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        // List of frequently asked questions
        FAQItem(
          question: 'How do I place an order?',
          answer:
          'To place an order, simply browse through our collection, select the items you want to purchase, and proceed to the checkout page. Follow the prompts to complete your order.',
        ),
        FAQItem(
          question: 'What payment methods do you accept?',
          answer:
          'We accept various payment methods, including credit/debit cards, PayPal, and cash on delivery (COD). You can choose your preferred payment option during checkout.',
        ),
        FAQItem(
          question: 'How can I track my order?',
          answer:
          'Once your order is shipped, you will receive a tracking number via email or SMS. You can use this tracking number to track the status of your delivery on our website or through our delivery partner’s website.',
        ),
        FAQItem(
          question: 'Do you offer international shipping?',
          answer:
          'Yes, we offer international shipping to select countries. Shipping fees and delivery times may vary depending on the destination. Please refer to our shipping policy for more information.',
        ),
        SizedBox(height: 40),
        // Contact Us Section
        Text(
          'Contact Us',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            // subtitle: mailto:text('support@stylehub.com'),
        onTap: () {
          // Implement email functionality
        },
      ),
      ListTile(
        leading: Icon(Icons.phone),
        title: Text('Phone'),
        subtitle: Text('+91 9664802800'),
        onTap: () {
          // Implement phone call functionality
        },
      ),
      ListTile(
        leading: Icon(Icons.location_on),
        title: Text('Address'),
        subtitle: Text('123 Main Street, Rajkot, Gujarat'),
        onTap: () {
          // Implement map functionality
        },
      ),
      ],
    ),
    ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(answer),
        Divider(),
        SizedBox(height: 20),
      ],
    );
  }
}
