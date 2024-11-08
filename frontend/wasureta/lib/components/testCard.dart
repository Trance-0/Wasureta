import 'package:flutter/material.dart';
import '../customTest.dart';
import 'models.dart';

class TestCard extends StatelessWidget {
  const TestCard({Key? key, required this.jisho, required this.lock})
      : super(key: key);

  final Jisho jisho;

  final bool lock;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text(jisho.title),
                subtitle: Text(jisho.description ?? ""),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () { 
                      if (!lock) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomTest(jisho: jisho)));
                      }
                    },
                    child: const Text('Start test'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
