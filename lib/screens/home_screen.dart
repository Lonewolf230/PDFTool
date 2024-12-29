import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdftool/screens/actions_screen.dart';
import 'package:pdftool/utilities/auth_service.dart';
import 'package:pdftool/widgets/menu_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Signing Out:$e')));
    }
  }

  void pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<String> paths = result.paths.map((path) => path!).toList();
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ActionsScreen(
            paths: paths,
          );
        }));
      }
    } else {
      const snackBar = SnackBar(
        content: Text("No file selected"),
        duration: Duration(seconds: 2),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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
        actions: [
          IconButton(
              onPressed: () {
                _signOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButtons(
                icon: Icons.scanner,
                text: 'Start Scanning',
                onPressed: () => {},
              ),
              const SizedBox(
                width: 20,
              ),
              MenuButtons(
                icon: Icons.browse_gallery,
                text: 'Create from Gallery',
                onPressed: () => {},
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () {
                pickFile();
              },
              label: const Text('Choose Files'),
              icon: const Icon(Icons.file_upload)),
        ],
      ),
    );
  }
}
