import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftool/screens/actions_screen.dart';
import 'package:pdftool/screens/image_display.dart';
import 'package:pdftool/utilities/auth_service.dart';
import 'package:pdftool/widgets/menu_buttons.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();

  void displayImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImageDisplay()));
  }

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

  void pickFile(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.paths.isNotEmpty) {
      List<Map<String, dynamic>> paths = result.paths
          .where((path) => path != null)
          .map((path) => {
                'path': path!,
                'key': DateTime.now().microsecondsSinceEpoch.toString()
              })
          .toList();
      if (context.mounted) {
        print(paths.runtimeType);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ActionsScreen(
            initalPaths: paths,
          );
        }));
      }
    } else {
      const snackBar = SnackBar(
        content: Text("No file selected"),
        duration: Duration(seconds: 2),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onPressed: () => {
                  displayImage(context),
                },
              ),
              const SizedBox(
                width: 20,
              ),
              MenuButtons(
                icon: Icons.browse_gallery,
                text: 'Create from Gallery',
                onPressed: () => {displayImage(context)},
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
                pickFile(context);
              },
              label: const Text('Choose Files'),
              icon: const Icon(Icons.file_upload)),
        ],
      ),
    );
  }
}
