import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            return Consumer(builder: (context, ref, _) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
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
                                        controller: controllers[index]
                                            ['second'],
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
          });
      final res = await dialogFuture;
      return res ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, String>> setPasswords(BuildContext context) async {
    final TextEditingController userPwdctrl = TextEditingController();
    final TextEditingController ownerPwdctrl = TextEditingController();

    try {
      final dialogFuture = showDialog<Map<String, String>>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxHeight: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      title: const Text('Set credentials'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: userPwdctrl,
                      decoration: const InputDecoration(
                          labelText: 'Enter User password'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: ownerPwdctrl,
                      decoration: const InputDecoration(
                          labelText: 'Enter owner password'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Map<String, String> credentials = {
                            'userPassword': userPwdctrl.text,
                            'ownerPassword': ownerPwdctrl.text
                          };
                          Navigator.of(context).pop(credentials);
                        },
                        child: const Text('Encrypt Pdf'))
                  ],
                ),
              ),
            );
          });
      final credentials = await dialogFuture;
      return credentials ?? {};
    } catch (e) {
      print(e);
      return {};
    }
  }
}
