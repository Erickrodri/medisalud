import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generarFacturaPDF(Map<String, dynamic> factura) async {
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
              pw.Text("Factura de Venta", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Fecha de emisión: ${factura["fecha_emision"]}"),
              pw.Text("Número de Factura: ${factura["numero_factura"]}"),
              pw.Text("Método de Pago: ${factura["metodo_pago"]}"),
              pw.Text("Estado de Pago: ${factura["estado_pago"]}"),
              pw.SizedBox(height: 10),
              pw.Text("Pedido N°: ${factura["pedido"]["numero_pedido"]}"),
              pw.Text("Fecha de Pedido: ${factura["pedido"]["fecha_hora"]}"),
              pw.Text("Estado: ${factura["pedido"]["estado"]}"),
              pw.Text("Mesa N°: ${factura["pedido"]["mesa_numero"] ?? 'N/A'}"),
              pw.SizedBox(height: 10),
              pw.Text("Detalle del Pedido:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Producto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Cantidad", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Precio Unitario", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Subtotal", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  // Suponiendo que cada pedido tiene productos
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Producto A")), // Cambiar por nombre real
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("1")),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("\Bs 43.50")),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("\Bs 43.50")),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("Subtotal: \$${factura["subtotal"]}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text("Impuestos: \$${factura["impuestos"]}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text("Total: \$${factura["total"]}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

 // Convertir PDF a bytes
  Uint8List pdfBytes = await pdf.save();

  // Mostrar el PDF en el visor de impresión del navegador
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdfBytes,
  );
}
