import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/factura.dart';

class ComprasPage extends StatefulWidget {
  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  List<Map<String, dynamic>> compras = [];
  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> medidores = [];

  final TextEditingController _total = TextEditingController();

  String responseData = "Esperando respuesta...";

  Future<void> registrarCompra(
      int? clientId, List<int>? medidoresId, String total) async {
    // Validación
    if (clientId == null || medidoresId == null || medidoresId.isEmpty) {
      print("Error: Cliente o medidores no seleccionados");
      return;
    }

    List<Map<String, dynamic>> detalles = [];

    // Recorrer los medidores seleccionados
    for (int idMedidor in medidoresId) {
      var medidor = medidores.firstWhere(
        (m) => m["id_medidor"] == idMedidor,
        orElse: () => {},
      );

      if (medidor.isNotEmpty) {
        var precio = medidor["precios"]?.firstWhere(
          (p) => p["estado"] == "Vigente",
          orElse: () => {"valor_usd": "0.00"},
        );

        double precioUnitario = double.parse(precio["valor_usd"]);
        int cantidad = 1; // Puedes cambiar la cantidad si lo necesitas
        double subtotal = precioUnitario * cantidad;

        detalles.add({
          "id_medidor": idMedidor,
          "cantidad": cantidad,
          "precio_unitario": precioUnitario,
          "subtotal": subtotal
        });
      }
    }

    // Construcción del JSON de la compra
    final Map<String, dynamic> data = {
      "id_cliente": clientId.toString(),
      "fecha_compra":
          DateTime.now().toIso8601String().split('T')[0], // Fecha actual
      "total": total,
      "estado": "Pagado",
      "detalles": detalles
    };

    // Imprimir para verificar el JSON antes de enviarlo
    print("Compra registrada: $data");

    // Aquí puedes enviar `data` a tu API o base de datos

    const String url = 'http://localhost:3000/compras';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        print("compras");
        fetchCompras();
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    generarFacturaPDF(data);
  }

  Future<void> fetchCompras() async {
    const url = 'http://localhost:3000/compras';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> comprasData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${comprasData.length} elementos';
          compras = comprasData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error al hacer el request: $e');
    }
  }

  Future<void> fetchClientes() async {
    const url = 'http://localhost:3000/clientes';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> clientesData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${clientesData.length} elementos';
          clientes = clientesData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error al hacer el request: $e');
    }
  }

  Future<void> fetchMedidores() async {
    const url = 'http://localhost:3000/medidores';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> medidoresData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${medidoresData.length} elementos';
          medidores = medidoresData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error al hacer el request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompras();
    fetchClientes();
    fetchMedidores();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                              'Compras',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            showCompras();
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
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido')),
                            DataColumn(label: Text('Teléfono')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Dirección')),
                            DataColumn(label: Text('NIT')),
                            DataColumn(label: Text('Fecha Compra')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Estado')),
                          ],
                          rows: compras.map((row) {
                            final cliente = row[
                                'cliente']; // Acceder a los datos del cliente
                            return DataRow(cells: [
                              DataCell(Text(
                                  '${cliente['nombre']} ${cliente['apellido']}')),
                              DataCell(Text(
                                  cliente['apellido'])), // Apellido individual
                              DataCell(Text(cliente['telefono'])),
                              DataCell(Text(cliente['email'])),
                              DataCell(Text(cliente['direccion'])),
                              DataCell(Text(cliente['nit'])), // NIT correcto
                              DataCell(Text(row['fecha_compra'])),
                              DataCell(Text(row['total'])),
                              DataCell(Text(row['estado'])), // NIT correcto
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
    );
  }

  void showCompras() {
    int? selectedClientId; // Cliente seleccionado
    List<int> selectedMedidores = []; // Lista de medidores seleccionados
    double totalCompra = 0.0; // Total calculado

    TextEditingController totalController =
        TextEditingController(text: totalCompra.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void calcularTotal() {
              double nuevoTotal = selectedMedidores.fold(0.0, (sum, idMedidor) {
                var medidor = medidores.firstWhere(
                  (med) => med["id_medidor"] == idMedidor,
                  orElse: () => {},
                );

                var precio = medidor["precios"]?.firstWhere(
                  (p) => p["estado"] == "Vigente",
                  orElse: () => {"valor_usd": "0.00"},
                );

                return sum + double.parse(precio["valor_usd"]);
              });

              setState(() {
                totalCompra = nuevoTotal;
                totalController.text = totalCompra.toStringAsFixed(2);
              });
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Registro de Compra',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Dropdown de Clientes
                            DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: "Selecciona un Cliente",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: selectedClientId,
                              items: clientes.map((cliente) {
                                return DropdownMenuItem<int>(
                                  value: cliente["id_cliente"],
                                  child: Text(
                                      "${cliente["nombre"]} ${cliente["apellido"]}"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedClientId = value;
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Selección múltiple de Medidores
                            const Text(
                              "Selecciona los Medidores",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: medidores.map((medidor) {
                                var precio = medidor["precios"]?.firstWhere(
                                  (p) => p["estado"] == "Vigente",
                                  orElse: () => {"valor_usd": "0.00"},
                                );

                                return CheckboxListTile(
                                  title: Text(
                                      "Medidor ${medidor["numero_serie"]}"),
                                  value: selectedMedidores
                                      .contains(medidor["id_medidor"]),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedMedidores
                                            .add(medidor["id_medidor"]);
                                      } else {
                                        selectedMedidores
                                            .remove(medidor["id_medidor"]);
                                      }
                                      calcularTotal(); // 🔥 Actualiza el total en tiempo real
                                    });
                                  },
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Campo Total
                            TextFormField(
                              controller: totalController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Total',
                                hintText: 'Total de la compra',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Cerrar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    registrarCompra(
                                      selectedClientId,
                                      selectedMedidores,
                                      _total.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5932EA),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Registrar Compra',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/*

{
  "id_cliente": 1,
  "fecha_compra": "2025-03-18",
  "total": 500.00,
  "estado": "Pagado",
  "detalles": [
    {
      "id_medidor": 1,
      "cantidad": 2,
      "precio_unitario": 150.00,
      "subtotal": 300.00
    },
    {
      "id_medidor": 2,
      "cantidad": 1,
      "precio_unitario": 200.00,
      "subtotal": 200.00
    }
  ]
}

 */