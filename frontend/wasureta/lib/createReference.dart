import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasureta/components/testCard.dart';

class CreateReference extends StatefulWidget {
  const CreateReference({Key? key}) : super(key: key);

  @override
  State<CreateReference> createState() => _CreateReferenceState();
}

class _CreateReferenceState extends State<CreateReference> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateReference'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            renderTestCard(),
            
            const Text('CreateReference'),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: false,
                  allowedExtensions: ['csv']
                );
                // The result will be null, if the user aborted the dialog
                if(result != null) {
                  file = File(result.files.first.path!);
                }
              },
              child: const Text('Pick a file'),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderTestCard() {
    return const TestCard(title: 'Test', subtitle: 'Test');
  }
}
