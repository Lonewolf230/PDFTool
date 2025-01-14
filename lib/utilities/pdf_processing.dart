import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfProcessing {
  Future<Uint8List> mergeFiles(List<Map<String, dynamic>> maps) async {
    PdfDocument newDocument = PdfDocument();
    for (Map<String, dynamic> map in maps) {
      final bytes = await File(map['path']).readAsBytes();
      PdfDocument loadedDocument = PdfDocument(inputBytes: bytes);

      for (int i = 0; i < loadedDocument.pages.count; i++) {
        PdfTemplate template = loadedDocument.pages[i].createTemplate();
        newDocument.pages.add().graphics.drawPdfTemplate(template, Offset.zero);
      }

      loadedDocument.dispose();
    }
    final mergedBytes = await newDocument.save();
    newDocument.dispose();
    print('PDFs merged successfully!');
    return Uint8List.fromList(mergedBytes);
  }

  Future<List<Uint8List>> splitFile(
      List<Map<String, dynamic>> maps, List<int> breakpoints) async {
    List<Uint8List> splitFiles = [];
    if (maps.length != 1) {
      throw Exception('Only one file can be split at a time');
    }
    try {
      if (maps.length == 1) {
        final Map<String, dynamic> map = maps[0];
        final bytes = await File(map['path']).readAsBytes();
        final loadedDocument = PdfDocument(inputBytes: bytes);
        int startPage = 0;

        for (int breakpoint in breakpoints) {
          PdfDocument newDocument = PdfDocument();
          for (int i = startPage; i < breakpoint; i++) {
            PdfTemplate template = loadedDocument.pages[i].createTemplate();
            newDocument.pages
                .add()
                .graphics
                .drawPdfTemplate(template, Offset.zero);
          }
          final splitBytes = await newDocument.save();
          splitFiles.add(Uint8List.fromList(splitBytes));
          newDocument.dispose();

          startPage = breakpoint + 1;
        }

        if (startPage < loadedDocument.pages.count) {
          PdfDocument finalDocument = PdfDocument();
          for (int i = startPage; i < loadedDocument.pages.count; i++) {
            PdfTemplate template = loadedDocument.pages[i].createTemplate();
            finalDocument.pages
                .add()
                .graphics
                .drawPdfTemplate(template, Offset.zero);
          }

          final finalBytes = await finalDocument.save();
          splitFiles.add(Uint8List.fromList(finalBytes));
          finalDocument.dispose();
        }
        loadedDocument.dispose();
        print('PDF split successfully');
      }
    } catch (e) {
      print('Error splitting PDF: $e');
    }
    return splitFiles;
  }

  Future<String?> savePdf(Uint8List bytes, String category) async {
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final String filePath =
              '${directory.path}/${category}_${DateTime.now().millisecondsSinceEpoch}.pdf';
          await File(filePath).writeAsBytes(bytes);
          return filePath;
        }
        return null;
      }
      print('saved to internal storage');
      return null;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }
}
