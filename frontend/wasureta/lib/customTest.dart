import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wasureta/components/models.dart';
import 'package:http/http.dart' as http;
import 'package:wasureta/tests/OTOTest.dart';
import 'components/settings.dart';

class CustomTest extends StatefulWidget {
  const CustomTest(this.jisho, {super.key});

  final Jisho jisho;

  @override
  State<CustomTest> createState() => _CustomTestState();
}

class _CustomTestState extends State<CustomTest> {
  final String BASE_URL = settings.BASE_URL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jisho.title),
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: ListTile(
                  title: Text(widget.jisho.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text(widget.jisho.description ?? "No description."),
                  style: ListTileStyle.list),
            ),
            IconButton(
                tooltip: "Edit reference book",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit title'),
                      content: Column(
                        children: editInfo(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit)),
          ]),
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                const ListTile(title: Text("Input fields")),
                const Divider(),
                ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: FutureBuilder<ListView>(
                      future: _getWordPairsInfo(widget.jisho.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!;
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ))
              ],
            ),
          ),
          CustomTestForm(widget.jisho),
        ]),
      ),
    );
  }

  List<Widget> editInfo() {
    String title = widget.jisho.title;
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

  Future<ListView> _getWordPairsInfo(int id) async {
    Uri uri = Uri.parse("$BASE_URL/jisho/word_pairs_preview/$id");
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load word pairs');
    }
    Iterable l = json.decode(response.body);
    List<WordPair> wordPairs = l.map((e) => WordPair.fromJson(e)).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.vertical,
      itemCount: wordPairs.length,
      itemBuilder: (context, index) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(wordPairs[index].key),
              Text(wordPairs[index].attributes ?? ""),
              Text(wordPairs[index].value),
            ]);
      },
    );
  }
}

class CustomTestForm extends StatefulWidget {
  const CustomTestForm(this.jisho, {super.key});

  final Jisho jisho;

  @override
  State<CustomTestForm> createState() => _CustomTestFormState();
}

class _CustomTestFormState extends State<CustomTestForm> {
  String? _selectedTestOption;
  bool _isRandomized = false;
  final List<String> testOptions = [
    "One-to-one matching",
    "One-to-many matching"
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Test type'),
            items: testOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTestOption = value;
              });
            },
          ),
          CheckboxListTile(
              title: const Text("Randomize"),
              value: _isRandomized,
              onChanged: (value) {
                setState(() {
                  _isRandomized = value ?? false;
                });
              }),
          ElevatedButton(
              onPressed: () => _submitForm(context),
              child: const Text("Create test")),
        ],
      ),
    );
  }

  void _submitForm(context) async {
    Uri uri =
        Uri.parse("$settings.BASE_URL/jisho/${widget.jisho.id}/createTest");
    //add your fields here
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'multipart/form-data',
      'Accept': '*/*',
    });
    request.fields["test_type"] = _selectedTestOption ?? testOptions[0];
    var response = await http.post(uri, body: request.fields);
    if (response.statusCode == 201) {
      Iterable l = json.decode(response.body);
      MemRecord memRecord = MemRecord.fromJson(l.first);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Test created successfully')));
        if (_selectedTestOption == "One-to-one matching") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OTOTest(memRecord)));
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create test')));
      }
    }
  }
}
