import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      log('Error al hacer el request: $e');
    }
  }

  Future<void> registrarPedidoAdaptado({
    required int numeroPedido,
    required String fechaHora,
    required String estado,
    required bool paraLlevar,
    required double total,
    required int mesaNumero,
    required int usuarioId,
  }) async {
    // Construir el JSON del pedido
    final Map<String, dynamic> data = {
      "numero_pedido": numeroPedido,
      "fecha_hora": fechaHora,
      "estado": estado,
      "para_llevar": paraLlevar,
      "total": total,
      "mesa_numero": mesaNumero,
      "usuario_id": usuarioId,
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
      }
    } catch (e) {
      print('Error de conexión: $e');
    }

    // Puedes generar un PDF si es necesario
    //generarComprobantePDF(data);
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  final _formKey = GlobalKey<FormState>();
  int numeroPedido = 1010;
  DateTime fechaHora = DateTime.parse("2025-03-21T17:15:00.000Z");
  String estado = "entregado";
  bool paraLlevar = false;
  double total = 60.0;
  int mesaNumero = 2;
  int usuarioId = 4;

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
                              DataColumn(label: Text('ID')),
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
                                DataCell(Text(pedido['id'].toString())),
                                DataCell(
                                    Text(pedido['numero_pedido'].toString())),
                                DataCell(Text(pedido['fecha_hora'])),
                                DataCell(Text(pedido['estado'])),
                                DataCell(
                                    Text(pedido['para_llevar'] ? 'Sí' : 'No')),
                                DataCell(Text(pedido['total'])),
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
    final TextEditingController numeroPedidoController =
        TextEditingController(text: '1010');
    final TextEditingController fechaHoraController =
        TextEditingController(text: DateTime.now().toIso8601String());
    final TextEditingController totalController =
        TextEditingController(text: '60.00');
    final TextEditingController mesaNumeroController =
        TextEditingController(text: '2');
    final TextEditingController usuarioIdController =
        TextEditingController(text: '4');

    String estadoSeleccionado = 'entregado';
    bool paraLlevar = false;

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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: numeroPedidoController,
                              decoration: InputDecoration(
                                labelText: 'Número de Pedido',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: estadoSeleccionado,
                              items:
                                  ['pendiente', 'en preparación', 'entregado']
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
                            TextFormField(
                              controller: totalController,
                              decoration: InputDecoration(
                                labelText: 'Total',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: mesaNumeroController,
                              decoration: InputDecoration(
                                labelText: 'Número de Mesa',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: usuarioIdController,
                              decoration: InputDecoration(
                                labelText: 'ID de Usuario',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
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
                                    
                                    // 👉 Aquí llamas a tu función que inserta el pedido
                                    registrarPedidoAdaptado(
                                      numeroPedido: int.parse(
                                          numeroPedidoController.text),
                                          fechaHora: DateTime.now().toIso8601String(),
                                          estado: estado,
                                          paraLlevar: paraLlevar,
                                          total: double.parse(totalController.text),
                                          mesaNumero: int.parse(mesaNumeroController.text),
                                          usuarioId: 1,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5932EA),
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
