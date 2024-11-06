import 'package:flutter/material.dart';

class SingleTest extends StatefulWidget {
  const SingleTest({Key? key}) : super(key: key);

  @override
  State<SingleTest> createState() => _SingleTestState();
}

class _SingleTestState extends State<SingleTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingleTest'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('SingleTest')
      ),
    );
  }
}