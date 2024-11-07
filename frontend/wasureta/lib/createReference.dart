import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wasureta/components/testCard.dart';
import 'package:mime/mime.dart';
import 'dart:developer' as developer;
// ignore: non_constant_identifier_names
String BASE_URL = "http://localhost:7799";

class CreateReference extends StatefulWidget {
  const CreateReference({super.key});

  @override
  State<CreateReference> createState() => _CreateReferenceState();
}

class _CreateReferenceState extends State<CreateReference> {
  File? file;
  Widget? testCard;

  @override
  Widget build(BuildContext context) {
    renderTestCard('Test', 'Test', true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new word list'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            testCard!,
            const Text('Preview'),
            CreateReferenceForm(renderTestCard: renderTestCard),
          ],
        ),
      ),
    );
  }

  void renderTestCard(String s, String t, bool bool) {
    testCard = TestCard(title: s, subtitle: t, lock: bool);
  }
}

class CreateReferenceForm extends StatefulWidget {
  const CreateReferenceForm({super.key, required this.renderTestCard});

  final void Function(String, String, bool) renderTestCard;

  @override
  State<CreateReferenceForm> createState() => _CreateReferenceFormState();
}

class _CreateReferenceFormState extends State<CreateReferenceForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  bool _isChecked = false;
  // file picker stuff
  PlatformFile? _file;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            onSaved: (String? value) {
              _name = value!;
            },
            onChanged: (String value) {
              widget.renderTestCard(_name, _description, _isChecked);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onSaved: (String? value) {
              _description = value!;
            },
            onChanged: (String value) {
              widget.renderTestCard(_name, _description, _isChecked);
            },
          ),
          CheckboxListTile(
            title: const Text('Is public'),
            value: _isChecked,
            onChanged: (bool? value) {
              _isChecked = value!;
              widget.renderTestCard(_name, _description, _isChecked);
            },
          ),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowMultiple: false,
                  allowedExtensions: ['csv'],
                  withData: false,
                  withReadStream: true);
              // The result will be null, if the user aborted the dialog
              if (result != null) {
                _file = result.files.first;
                developer.log(_file!.name);
                // _filePath = _file?.path;
              } else {
                developer.log("No file selected");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No file selected')));
                }
              }
            },
            child: const Text('Pick a file'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _submitForm(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm(context) async {
    // TODO: fix this to https for security
    // temporary solution: 
    // run your project with --web-browser-option="--disable-web-security"
    // eg: flutter run -d chrome --web-browser-flag "--disable-web-security"
    Uri uri = Uri.parse("$BASE_URL/jisho/create");

    var request = MultipartRequest("POST", uri);
    //add your fields here
    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'multipart/form-data',
      'Accept': '*/*',
    });
    request.fields["title"] = _name;
    request.fields["description"] = _description;
    request.fields["sharing_id"] = _isChecked
        ? (() {
            const chars =
                'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
            Random rnd = Random();

            return String.fromCharCodes(Iterable.generate(
                10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
          })()
        : "";
    request.fields["owner_id"] = "1";
    if (_file != null) {
      // path is not available on web, 
      // TODO: fix this
      // final filePath = _file?.path;
      const filePath = null;
      final mimeType = filePath != null ? lookupMimeType(filePath) : null;
      final contentType = mimeType != null ? MediaType.parse(mimeType) : null;

      final fileReadStream = _file!.readStream;

      developer.log(_file!.name);
      if (fileReadStream == null) {
        throw Exception('Cannot read file from null stream');
      }
      final stream = ByteStream(fileReadStream!);
      developer.log(_file!.size.toString());
      developer.log(contentType.toString());
      // developer.log(stream.toString());
      var multipartFile = MultipartFile(
          'csv_file', stream, _file!.size,
          filename: _file?.name ?? "web_upload.csv",
          contentType: contentType ?? MediaType.parse("text/csv"));
      request.files.add(multipartFile);
    }
    var response = await request.send();
    developer.log(response.toString());
    if (response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reference created successfully')));
      }
      Navigator.pop(context);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Failed to create reference, please contact the administrator')));
      }
    }
  }
}
