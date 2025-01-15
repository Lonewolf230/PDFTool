import 'package:flutter/material.dart';
import 'package:pdftool/providers/paths_notifier.dart';
import 'package:pdftool/utilities/actions_utilities.dart';
import 'package:pdftool/utilities/pdf_processing.dart';
import 'package:pdftool/widgets/loading_screen.dart';
import 'package:pdftool/widgets/menu_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class ActionsScreen extends ConsumerStatefulWidget {
  const ActionsScreen({super.key, required this.initalPaths});
  final List<Map<String, dynamic>> initalPaths;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ActionsScreenState();
  }
}

class _ActionsScreenState extends ConsumerState<ActionsScreen> {
  final PdfProcessing pdfProcessing = PdfProcessing();
  final ActionsUtilities actionsUtilities = ActionsUtilities();
  int fileCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initalPaths.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(pathsProvider.notifier).setPaths(widget.initalPaths);
      });
    }
    fileCount = widget.initalPaths.length;
  }

  void _showLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LoadingScreen(message: 'Please wait');
        });
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }

  void mergePdfs(WidgetRef ref) async {
    final paths = ref.read(pathsProvider);
    if (paths.isEmpty || paths.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(paths.isEmpty
              ? 'No files selected for merging'
              : 'Select more files')));
      return;
    }
    if (!mounted) return;
    _showLoading();
    try {
      final mergedPdf = await pdfProcessing.mergeFiles(paths);
      final mergedPath = await pdfProcessing.savePdf(mergedPdf, 'merged', '');
      if (!mounted) return;
      _hideLoading();
      Navigator.of(context).pop(mergedPath != null
          ? 'PDFs merged successfully'
          : 'Error saving merged PDF');
      print('Merged PDF saved at $mergedPath');
    } catch (e) {
      if (!mounted) return;
      _hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error merging PDFs:${e.toString()}')));
    }
  }

  void splitPdf(WidgetRef ref) async {
    final paths = ref.read(pathsProvider);
    if (paths.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Limit to 1 Pdf file for splitting')));
      return;
    }
    final breakpoints = await actionsUtilities.fixBreakpoints(context);
    if (breakpoints == null || breakpoints.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No breakpoints set')));
      return;
    }
    if (!mounted) return;
    _showLoading();
    try {
      final String filePath = paths[0]['path'] as String;
      final fileNamewithExt = path.basename(filePath);
      final originalFilename =
          fileNamewithExt.substring(0, fileNamewithExt.length - 4);
      final splitPdfs = await pdfProcessing.splitFile(paths, breakpoints);
      for (int i = 0; i < splitPdfs.length; i++) {
        final splitPath = await pdfProcessing.savePdf(
            splitPdfs[i], 'split_${i + 1}', originalFilename);
        print('Split PDF saved at $splitPath');
      }
      if (!mounted) return;
      _hideLoading();
      Navigator.of(context).pop('Pdf Split successfully');
    } catch (e) {
      if (!mounted) return;
      _hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error splitting Pdf: ${e.toString()}')));
    }
  }

  void encryptPdf(WidgetRef ref) async {
    final paths = ref.read(pathsProvider);
    if (paths.length != 1) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please limit to 1 file for encryption purposes')));
      return;
    }
    final credentials = await actionsUtilities.setPasswords(context);
    print(credentials);
    if (credentials.isEmpty ||
        credentials['userPassword']?.isEmpty == true ||
        credentials['ownerPassword']?.isEmpty == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please set credentials to encrypt')));
      return;
    }

    if (!mounted) return;
    _showLoading();

    try {
      final filePath = paths[0]['path'] as String;
      final fileNamewithExt = path.basename(filePath);
      final originalFilename =
          fileNamewithExt.substring(0, fileNamewithExt.length - 4);
      final encryptedPdf = await pdfProcessing.encryptPdf(paths[0],
          credentials['userPassword']!, credentials['ownerPassword']!);

      final encryptedPath = await pdfProcessing.savePdf(
          encryptedPdf, 'encrypted', originalFilename);
      print('Encrypted file stored at:$encryptedPath');
      if (!mounted) return;
      _hideLoading();
      Navigator.of(context).pop(encryptedPath != null
          ? 'File encrypted successfully'
          : 'Error saving encrypted PDF');
    } catch (e) {
      if (!mounted) return;
      _hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error encrypting PDF: ${e.toString()}')));
    }
  }

  void showFiles(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(pathsProvider);
    if (paths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No files selected')),
      );
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final paths = ref.watch(pathsProvider);

            if (paths.isEmpty) {
              Navigator.pop(context);
              return const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fixed header section
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      // Drag indicator and close button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50),
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Selected Files (${paths.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Scrollable list section
                Expanded(
                  child: ReorderableListView.builder(
                    // buildDefaultDragHandles: false,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      ref
                          .read(pathsProvider.notifier)
                          .reorderPaths(oldIndex, newIndex);
                    },
                    itemCount: paths.length,
                    itemBuilder: (context, index) {
                      final item = paths[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        key: ValueKey(item['key']),
                        onDismissed: (direction) {
                          ref.read(pathsProvider.notifier).removePath(index);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${item['path'].split("/").last} removed'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  ref.read(pathsProvider.notifier).setPaths([
                                    ...paths.sublist(0, index),
                                    item,
                                    ...paths.sublist(index),
                                  ]);
                                },
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              item['path'].split("/").last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: ReorderableDragStartListener(
                                index: index,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${item['size']} Mb'),
                                    const SizedBox(height: 4),
                                    Text('${item['pages']} Pages'),
                                  ],
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Padding(padding: EdgeInsets.only(bottom: 20))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize paths after the first frame
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                Opacity(
                  opacity: 0.4,
                  child: MenuButtons(
                    icon: Icons.compress,
                    text: 'Compress File',
                    onPressed: () => {},
                  ),
                ),
                MenuButtons(
                  icon: Icons.splitscreen_outlined,
                  text: 'Split File',
                  onPressed: () async {
                    splitPdf(ref);
                  },
                ),
                MenuButtons(
                  icon: Icons.merge_type,
                  text: 'Merge Files',
                  onPressed: () async {
                    mergePdfs(ref);
                  },
                ),
                MenuButtons(
                  icon: Icons.picture_as_pdf,
                  text: 'Encrypt Pdf',
                  onPressed: () => {encryptPdf(ref)},
                ),
              ],
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(40),
            iconSize: 40,
            onPressed: () => showFiles(context, ref),
            icon: const Icon(Icons.arrow_circle_up_rounded),
          ),
        ],
      ),
    );
  }
}
