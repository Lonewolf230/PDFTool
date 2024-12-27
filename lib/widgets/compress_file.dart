import 'package:flutter/material.dart';

class CompressFile extends StatefulWidget {
  const CompressFile({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CompressFileState();
  }
}

class CompressFileState extends State<CompressFile> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Text('Compress File'),
          ElevatedButton(
            onPressed: () {},
            child: Text('Compress'),
          )
        ],
      ),
    ]);
  }
}
