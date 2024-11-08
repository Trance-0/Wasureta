import 'package:flutter/material.dart';

class OTOTest extends StatefulWidget {
  const OTOTest({Key? key}) : super(key: key);

  @override
  State<OTOTest> createState() => _OTOTestState();
}

class _OTOTestState extends State<OTOTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTOTest'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('OTOTest')
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}