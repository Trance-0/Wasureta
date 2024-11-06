import 'package:flutter/material.dart';
import '../singleTest.dart';

class TestCard extends StatelessWidget {
  const TestCard({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            child: Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.folder),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SingleTest()));
              },
              child: const Text('Start test'),
            ),
          ],
        )
      ],
    )));
  }
}
