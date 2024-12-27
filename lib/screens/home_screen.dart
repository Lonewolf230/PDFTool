import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdftool/widgets/menu_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _filePath;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PDF Tool',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1),
        children: [
          MenuButtons(
            icon: Icons.scanner,
            text: 'Start Scanning',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.browse_gallery,
            text: 'Create from Gallery',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.merge_rounded,
            text: 'Merge PDFs',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.call_split_outlined,
            text: 'Split PDFs',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.picture_as_pdf_outlined,
            text: 'Convert between formats',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.compress,
            text: 'Compress PDFs',
            onPressed: () {
              pickFile();
            },
          ),
          MenuButtons(
            icon: Icons.picture_as_pdf,
            text: 'Convert to PDF',
            onPressed: () => {},
          ),
          MenuButtons(
            icon: Icons.picture_as_pdf,
            text: 'Convert to PDF',
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
