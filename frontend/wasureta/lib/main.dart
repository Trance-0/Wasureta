import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wasureta/components/models.dart';
import 'package:wasureta/components/testCard.dart';
import 'createReference.dart';
import 'authentication.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasureta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wasureta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Search'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: [
                              TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Search',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            searchTest(_searchController.text);
                          },
                          child: const Text('Search'),
                        ),
                      ],
                    );
                  });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authentication()));
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.all(4.0),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: generateTags().length,
                itemBuilder: (context, index) {
                  return generateTags()[index];
                },
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: FutureBuilder<List<Widget>>(
              future: getTestCards(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return snapshot.data![index];
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateReference()));
        },
        tooltip: 'Create new test',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void searchTest(String searchText) {
    print('searchTest: $searchText');
  }

  Future<List<Widget>> getTestCards() async {
    Uri uri = Uri.parse("$BASE_URL/jisho/getJishoList");
    final response = await http.get(uri);
    developer.log(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Iterable l = json.decode(response.body);
      List<Jisho> posts = List<Jisho>.from(l.map((model)=> Jisho.fromJson(model)));
      return posts.map((e) => TestCard(title: e.title, subtitle: e.description??'', lock: false)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load jisho list');
  }
  }

  List<Widget> generateTags() {
    return List.generate(10, (index) {
      return TextButton(
        onPressed: () {
          // TODO: implement tag selection
        },
        child: Text('Tag sadfsaddfasfdasdf $index'),
      );
    });
  }
}
