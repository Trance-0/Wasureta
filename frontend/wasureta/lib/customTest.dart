import 'package:flutter/material.dart';
import 'package:wasureta/components/models.dart';
import 'package:http/http.dart' as http;
import 'components/settings.dart';

class CustomTest extends StatefulWidget {
  const CustomTest({Key? key, required this.jisho}) : super(key: key);

  final Jisho jisho;

  @override
  State<CustomTest> createState() => _CustomTestState();
}

class _CustomTestState extends State<CustomTest> {
  final String BASE_URL = settings.BASE_URL;
  late Future<ListView> wordPairs;

  @override
  void initState() {
    super.initState();
    wordPairs = _getWordPairsInfo(widget.jisho.id);
  }

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
                FutureBuilder<ListView>(
                  future: wordPairs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      snapshot;
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
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
    List<WordPair> wordPairs = [];
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

extension on ListView {
  get length => null;
}
