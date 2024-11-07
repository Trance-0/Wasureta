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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: renderTestInfo()
        ),
      ),
    );
  }
  
  List<Widget> renderTestInfo() {
    String title = widget.title;
    List<Widget> testInfoWidgets = [
      Text(title),
      Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ],
        ),
      ),
    ];
    return testInfoWidgets;
  }
}
