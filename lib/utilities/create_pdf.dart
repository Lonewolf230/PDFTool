import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:dart_pdf_reader/dart_pdf_reader_io.dart' as pdf;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CreatePdf {
  Future<String> createPdf(List<File> images, String fileName) async {
    final doc = pw.Document();

    List<pw.MemoryImage> listImages = [];
    try {
      for (var image in images) {
        try {
          listImages.add(pw.MemoryImage(image.readAsBytesSync()));
        } catch (e) {
          print('Error processing image ${image.path}: $e');
          continue;
        }
      }

      if (listImages.isEmpty) {
        print('No valid images to create PDF');
        return '';
      }

      for (var image in listImages) {
        doc.addPage(pw.Page(build: (context) {
          return pw.Center(child: pw.Image(image));
        }));
      }

      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        final String filename = fileName.trim().isEmpty
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : fileName.trim();
        if (directory != null) {
          final String filePath = '${directory.path}/$filename.pdf';
          await File(filePath).writeAsBytes(await doc.save());
          return filePath;
        }
      }
    } catch (e) {
      print('Error saving image: $e');
    }
    return '';
  }

  Future<double> getFileSize(String path) async {
    final fileBytes = await File(path).readAsBytes();
    return (fileBytes.lengthInBytes) / (1000 * 1000);
  }

  Future<int> getFilePages(String path) async {
    final Uint8List fileBytes = await File(path).readAsBytes();
    PdfDocument loadedDocument = PdfDocument(inputBytes: fileBytes);
    final int pages = loadedDocument.pages.count;
    loadedDocument.dispose();
    return pages;
  }
}
