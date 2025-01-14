import 'package:flutter/material.dart';

class ActionsUtilities {
  Future<List<int>> fixBreakpoints(BuildContext context) async {
    List<Map<String, TextEditingController>> controllers = [
      {
        'first': TextEditingController(text: '0'),
        'second': TextEditingController()
      }
    ];
    try {
      final dialogFuture = showDialog<List<int>>(
          context: context,
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              bool isLoading = false;
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      title: const Text('Set breakpoints'),
                      actions: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                final lastEndingPage = int.tryParse(
                                        controllers.last['second']?.text ??
                                            '0') ??
                                    0;

                                controllers.add({
                                  'first': TextEditingController(
                                      text: (lastEndingPage + 1).toString()),
                                  'second': TextEditingController()
                                });
                              });
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controllers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      controller: controllers[index]['first'],
                                      decoration: const InputDecoration(
                                          labelText: 'Starting page number'),
                                      keyboardType: TextInputType.number,
                                    )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                        child: TextField(
                                      controller: controllers[index]['second'],
                                      decoration: const InputDecoration(
                                          labelText: 'Ending page number'),
                                      keyboardType: TextInputType.number,
                                    )),
                                  ],
                                ),
                              );
                            })),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(null);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              List<int> breakpoints = controllers
                                  .map((map) =>
                                      int.tryParse(
                                          map['second']?.text ?? '0') ??
                                      0)
                                  .toList();
                              Navigator.of(dialogContext).pop(breakpoints);
                            },
                            child: const Text('Split'))
                      ],
                    )
                  ],
                ),
              );
            });
          });
      final res = await dialogFuture;
      return res ?? [];
    } catch (e) {
      return [];
    }
  }
}
