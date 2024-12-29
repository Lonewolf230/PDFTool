import 'package:flutter/material.dart';
import 'package:pdftool/widgets/menu_buttons.dart';

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key, required this.paths});

  final List<String> paths;

  void showFiles(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              Text(
                'Selected Files',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: (int oldIndex, int newIndex) {
                    String path = paths.removeAt(oldIndex);
                    paths.insert(newIndex, path);
                  },
                  itemCount: paths.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) {
                        paths.removeAt(index);
                      },
                      key: ValueKey(paths[index]),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        title: Text(paths[index].split("/").last),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisSpacing: 10),
                children: [
                  MenuButtons(
                      icon: Icons.compress,
                      text: 'Compress File',
                      onPressed: () => {}),
                  MenuButtons(
                    icon: Icons.splitscreen_outlined,
                    text: 'Split File',
                    onPressed: () => {},
                  ),
                  MenuButtons(
                    icon: Icons.merge_type,
                    text: 'Merge Files',
                    onPressed: () => {},
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
                onPressed: () {
                  showFiles(context);
                },
                icon: const Icon(Icons.arrow_circle_up_rounded))
          ],
        ));
  }
}
