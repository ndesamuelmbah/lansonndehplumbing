import 'package:flutter/material.dart';

class MyImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Image Screen'),
      ),
      body: Center(
        child: Image.network(
          'https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_gate-valve-15mm-07901.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
