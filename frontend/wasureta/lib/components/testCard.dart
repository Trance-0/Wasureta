import 'package:flutter/material.dart';
import '../customTest.dart';

class TestCard extends StatelessWidget {
  const TestCard({Key? key, required this.title, required this.subtitle, required this.lock})
      : super(key: key);

  final String title;
  final String subtitle;
  
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
                title: Text(title),
                subtitle: Text(subtitle),
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
                                  const CustomTest(title: 'CustomTest')));
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
