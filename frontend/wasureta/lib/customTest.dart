import 'package:flutter/material.dart';

class CustomTest extends StatefulWidget {
  const CustomTest({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CustomTest> createState() => _CustomTestState();
}

class _CustomTestState extends State<CustomTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('CustomTest')
      ),
    );  
  }
}
