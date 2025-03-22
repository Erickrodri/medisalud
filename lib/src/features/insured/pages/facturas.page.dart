import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medisalud/src/features/insured/widgets/factura.dart';

class FacturaPage extends StatefulWidget {
  @override
  State<FacturaPage> createState() => _FacturaPageState();
}

class _FacturaPageState extends State<FacturaPage> {
  // Ejemplo de datos, los reemplazarías con los datos obtenidos de tu API
  String responseData = "Esperando respuesta...";

  List<Map<String, dynamic>> facturas = [];

  Future<void> fetchFacturas() async {
    const url = 'http://localhost:3000/facturas';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> facturasData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${facturasData.length} elementos';
          facturas = facturasData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error al hacer el request: $e');
    }
  }

   void _onButtonPressed(int facturaId) {
    print("Acción para la factura con ID: $facturaId");
    final factura = facturas.firstWhere(
      (factura) => factura['id'] == facturaId
    );
    generarFacturaPDF(factura);
  }

  @override
  void initState() {
    super.initState();
    fetchFacturas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Facturas',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          /*ElevatedButton.icon(
                            onPressed: () {
                              //showCompras();
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Nueva Compra',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5932EA),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),*/
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Nro Factura')),
                              DataColumn(label: Text('Fecha Emisión')),
                              DataColumn(label: Text('Subtotal')),
                              DataColumn(label: Text('Impuestos')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Método de Pago')),
                              DataColumn(label: Text('Estado de Pago')),
                              DataColumn(label: Text('Acción')),
                            ],
                            rows: facturas.map((factura) {
                              return DataRow(cells: [
                                DataCell(Text(factura['id'].toString())),
                                DataCell(
                                    Text(factura['numero_factura'].toString())),
                                DataCell(Text(factura['fecha_emision'])),
                                DataCell(Text(factura['subtotal'])),
                                DataCell(Text(factura['impuestos'])),
                                DataCell(Text(factura['total'])),
                                DataCell(Text(factura['metodo_pago'])),
                                DataCell(Text(factura['estado_pago'])),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () => _onButtonPressed(factura['id']),
                                    child: Text('Reimprimir'),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
