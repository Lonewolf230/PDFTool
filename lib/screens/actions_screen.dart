import 'package:flutter/material.dart';
import 'package:pdftool/providers/paths_notifier.dart';
import 'package:pdftool/utilities/actions_utilities.dart';
import 'package:pdftool/utilities/pdf_processing.dart';
import 'package:pdftool/widgets/menu_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool loading = false;

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

  void mergePdfs(WidgetRef ref) async {
    final paths = ref.read(pathsProvider);
    final mergedPdf = await pdfProcessing.mergeFiles(paths);
    final mergedPath = await pdfProcessing.savePdf(mergedPdf, 'merged');
    print('Merged PDF saved at $mergedPath');
  }

  void splitPdf(WidgetRef ref) async {
    final paths = ref.read(pathsProvider);
    final breakpoints = await actionsUtilities.fixBreakpoints(context);
    if (breakpoints == null || breakpoints.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No breakpoints set')));
      return;
    }

    final splitPdfs = await pdfProcessing.splitFile(paths, breakpoints);
    for (int i = 0; i < splitPdfs.length; i++) {
      final splitPath =
          await pdfProcessing.savePdf(splitPdfs[i], 'split_${i + 1}');
      print('Split PDF saved at $splitPath');
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
                              child: Text('${item['size']} Mb'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Padding(padding: EdgeInsets.only(bottom: 20))
                // Fixed footer section
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
                MenuButtons(
                  icon: Icons.compress,
                  text: 'Compress File',
                  onPressed: () => {},
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
                  text: 'Convert between formats',
                  onPressed: () => {},
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
