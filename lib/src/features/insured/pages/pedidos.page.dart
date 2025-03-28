import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:intl/intl.dart';

class PedidosPage extends StatefulWidget {
  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  // Ejemplo de datos, los reemplazarías con los datos obtenidos de tu API
  String responseData = "Esperando respuesta...";

  List<Map<String, dynamic>> pedidos = [];

  Future<void> fetch() async {
    const url = 'http://localhost:3000/pedidos';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> facturasData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${facturasData.length} elementos';
          pedidos = facturasData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al hacer el request: $e');
    }
  }

  int generarCodigoPedido() {
    Random random = Random();
    int codigoPedido = 0;

    // Generar un código de 6 dígitos numéricos al azar
    for (int i = 0; i < 6; i++) {
      codigoPedido += random.nextInt(10);
    }

    return codigoPedido;
  }

  Future<void> registrarPedidoAdaptado({
    required String fechaHora,
    required String estado,
    required bool paraLlevar,
    required double total,
    required int mesaNumero,
  }) async {
    // Construir el JSON del pedido
    final Map<String, dynamic> data = {
      "numero_pedido": generarCodigoPedido(),
      "fecha_hora": fechaHora,
      "estado": estado,
      "para_llevar": paraLlevar,
      "total": total,
      "mesa_numero": mesaNumero,
      "usuario_id": 9, //id usuario
    };

    // Imprimir para verificación
    print("Pedido a registrar: $data");

    const String url =
        'http://localhost:3000/pedidos'; // Reemplaza con tu endpoint real

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Pedido registrado correctamente.");
        fetch();
      } else {
        print('Error al registrar el pedido: ${response.statusCode}');
        print(response.body.toString());
      }
    } catch (e) {
      print('Error de conexión: $e');
    }

    // Puedes generar un PDF si es necesario
    //generarComprobantePDF(data);
  }

  String formatearFecha(String fechaHora) {
    try {
      // Si la fechaHora está en formato ISO 8601, DateTime.parse lo puede manejar.
      DateTime date = DateTime.parse(fechaHora);
      // Formatear la fecha a un formato más legible (por ejemplo: 14/03/2025 12:45 PM)
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (e) {
      return fechaHora; // Si ocurre algún error, devuelve la fecha original
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  final _formKey = GlobalKey<FormState>();
  int numeroPedido = 1010;
  DateTime fechaHora = DateTime.parse("2025-03-21T17:15:00.000Z");
  String estado = "Entregado";
  bool paraLlevar = false;
  double total = 60.0;
  int mesaNumero = 2;
  int usuarioId = 9;

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
                                'Pedidos',
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
                              mostrarFormularioPedido(context);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Nuevo Pedido',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 8, 150, 84),
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
                              DataColumn(label: Text('Nro Pedido')),
                              DataColumn(label: Text('Fecha y Hora')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Para Llevar')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Mesa')),
                              DataColumn(label: Text('Mesero')),
                            ],
                            rows: pedidos.map((pedido) {
                              return DataRow(cells: [
                                DataCell(
                                    Text(pedido['numero_pedido'].toString())),
                                DataCell(
                                    Text(formatearFecha(pedido['fecha_hora']))),
                                DataCell(Text(pedido['estado'])),
                                DataCell(
                                    Text(pedido['para_llevar'] ? 'Sí' : 'No')),
                                DataCell(Text('${pedido['total']} Bs.')),
                                DataCell(Text(
                                    pedido['mesa_numero']?.toString() ??
                                        'N/A')),
                                DataCell(Text(pedido['usuario']['nombre'])),
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

  void mostrarFormularioPedido(BuildContext context) {
    final TextEditingController totalController =
        TextEditingController(text: '0.00');

    String? _mesaSeleccionada; // Variable para guardar la mesa seleccionada

    String estadoSeleccionado = 'Entregado';
    bool paraLlevar = false;
    DateTime fechaHora = DateTime.now();
    List<Map<String, dynamic>> productos = [
      {"id": 1, "nombre": "Hamburguesa Clásica", "precio": "25.50"},
      {"id": 2, "nombre": "Papas Fritas", "precio": "10.00"},
      {"id": 3, "nombre": "Refresco", "precio": "5.50"},
    ];
    List<int> productosSeleccionados = [];

    void calcularTotal(StateSetter setState) {
      double total = 0.0;
      for (var id in productosSeleccionados) {
        var producto = productos.firstWhere((p) => p['id'] == id);
        total += double.tryParse(producto['precio']) ?? 0.0;
      }

      setState(() {
        totalController.text = total.toStringAsFixed(2);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                              'Registrar Pedido',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),

                            /// 🟣 Lista de productos
                            const Text("Selecciona productos:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Column(
                              children: productos.map((producto) {
                                return CheckboxListTile(
                                  title: Text(
                                      "${producto["nombre"]} - \Bs. ${producto["precio"]}"),
                                  value: productosSeleccionados
                                      .contains(producto["id"]),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        productosSeleccionados
                                            .add(producto["id"]);
                                      } else {
                                        productosSeleccionados
                                            .remove(producto["id"]);
                                      }
                                      calcularTotal(setState);
                                    });
                                  },
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('¿Para llevar?'),
                              value: paraLlevar,
                              onChanged: (value) {
                                setState(() {
                                  paraLlevar = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: estadoSeleccionado,
                              items:
                                  ['Pendiente', 'En preparación', 'Entregado']
                                      .map((estado) => DropdownMenuItem(
                                            value: estado,
                                            child: Text(estado),
                                          ))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  estadoSeleccionado = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // DropdownButton para seleccionar el número de mesa
                            DropdownButtonFormField<String>(
                              value: _mesaSeleccionada,
                              items: ['1', '2', '3', '4']
                                  .map<DropdownMenuItem<String>>((String mesa) {
                                return DropdownMenuItem<String>(
                                  value: mesa,
                                  child: Text('Mesa $mesa'),
                                );
                              }).toList(),
                              onChanged: (String? nuevaMesa) {
                                setState(() {
                                  _mesaSeleccionada = nuevaMesa;
                                  print(_mesaSeleccionada);
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Número de Mesa',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// Total
                            TextFormField(
                              controller: totalController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Total',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

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
                                        horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    registrarPedidoAdaptado(
                                        fechaHora:
                                            DateTime.now().toIso8601String(),
                                        estado: estadoSeleccionado,
                                        paraLlevar: paraLlevar,
                                        total:
                                            double.parse(totalController.text),
                                        mesaNumero: int.parse(
                                            _mesaSeleccionada.toString()));

                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 8, 150, 84),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text(
                                    'Registrar Pedido',
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
