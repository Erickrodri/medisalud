import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generarFacturaPDF(Map<String, dynamic> compra) async {
  final pdf = pw.Document();
  print("factura iniciando");
  // Crear contenido del PDF
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Factura de Compra", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Fecha: ${compra["fecha_compra"]}"),
            pw.Text("Cliente ID: ${compra["id_cliente"]}"),
            pw.SizedBox(height: 10),
            pw.Text("Detalle de la Compra:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("ID Medidor", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Cantidad", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Precio Unitario", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Subtotal", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...compra["detalles"].map<pw.TableRow>((detalle) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(detalle["id_medidor"].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(detalle["cantidad"].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("\$${detalle["precio_unitario"]}")),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("\$${detalle["subtotal"]}")),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text("Total: \$${compra["total"]}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ),
  );

  print("factura iniciando 2");
 // Convertir PDF a bytes
  Uint8List pdfBytes = await pdf.save();

  // Mostrar el PDF en el visor de impresión del navegador
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdfBytes,
  );
}
