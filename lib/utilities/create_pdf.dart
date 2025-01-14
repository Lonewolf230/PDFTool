import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:dart_pdf_reader/dart_pdf_reader_io.dart' as pdf;

class CreatePdf {
  Future<String> createPdf(List<File> images) async {
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
        if (directory != null) {
          final String filePath =
              '${directory.path}/saved_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
    final stream = pdf.FileStream(File(path).openSync());
    final doc = await pdf.PDFParser(stream).parse();
    final catalog = await doc.catalog;
    final pages = await catalog.getPages();
    return pages.pageCount;
  }
}
