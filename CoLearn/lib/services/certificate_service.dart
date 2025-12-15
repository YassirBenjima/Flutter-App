
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as material;

class CertificateService {
  static Future<void> generateCertificate({
    required String studentName,
    required String courseTitle,
    required String date,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue900, width: 5),
            ),
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("CERTIFICAT D'ACHÈVEMENT",
                    style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.SizedBox(height: 30),
                pw.Text("Ce certificat est décerné à",
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.grey700)),
                pw.SizedBox(height: 20),
                pw.Text(studentName.toUpperCase(),
                    style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text("Pour avoir complété avec succès le cours",
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                pw.SizedBox(height: 15),
                pw.Text(courseTitle,
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                pw.SizedBox(height: 40),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text(date, style: const pw.TextStyle(fontSize: 16)),
                      pw.Container(width: 100, height: 1, color: PdfColors.black),
                      pw.Text("Date", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
                    ]),
                    pw.Column(children: [
                      pw.Text("CoLearn AI", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Container(width: 100, height: 1, color: PdfColors.black),
                      pw.Text("Signature", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
                    ]),
                  ],
                ),
                pw.Spacer(),
                pw.Text("Prouvé par CoLearn - L'apprentissage collaboratif",
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey500)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Certificat-$courseTitle.pdf',
    );
  }
}
