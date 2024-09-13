import 'package:adminmuseo/museoTraje/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/museoTraje/eventos/model/modelEventoWeb.dart';
import 'package:adminmuseo/museoTraje/eventos/vista/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museoTraje/traje/controller/trajeControllerWeb.dart'; // Asegúrate de que la ruta del archivo sea correcta
import 'package:adminmuseo/museoTraje/traje/model/modelTraje.dart';
import 'package:adminmuseo/museoTraje/traje/vista/screens/dashboard/register_traje_museo.dart';
import 'package:adminmuseo/museoTraje/traje/vista/screens/dashboard/update_traje_museo.dart';
import 'package:adminmuseo/museoTraje/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';

class ListarMuseoScreen extends StatefulWidget {
  static const String id = "listarmuseo";

  @override
  State<ListarMuseoScreen> createState() => _ListarMuseoScreenState();
}

class _ListarMuseoScreenState extends State<ListarMuseoScreen> {
  String searchQuery = "";
  final EventoControllerWeb _eventoController = EventoControllerWeb();
  List<QueryDocumentSnapshot> allDocuments = [];
  List<QueryDocumentSnapshot> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('trajes')
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden ascendente
        .get();

    setState(() {
      allDocuments = snapshot.docs;
      filteredDocuments = allDocuments; // Mostrar inicialmente todos los documentos
    });
  }


  void chooseScreens(item) {
    switch (item) {
      case ListarMuseoScreen.id:
        Navigator.pushNamed(context, ListarMuseoScreen.id);
        break;
      case ListarEventoScreen.id:
        Navigator.pushNamed(context, ListarEventoScreen.id);
        break;
      case ListarUsuarioScreen.id:
        Navigator.pushNamed(context, ListarUsuarioScreen.id);
        break;
    }
  }

  void filterDocuments(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredDocuments = allDocuments.where((doc) {
        final nombreTraje = doc['nombreTraje'].toString().toLowerCase();
        return nombreTraje.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF66212),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black, size: 35,),
            onPressed: () {
              // Aquí debes agregar la lógica para cerrar sesión
              _eventoController.logout(context);
            },
          ),
        ],
      ),
      sideBar: SideBar(
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        backgroundColor: Color(0xFFF55A07),
        activeIconColor: Color(0xFFF55A07),
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Colors.white,
        activeBackgroundColor: Colors.white,
        items: const [
          AdminMenuItem(
            title: 'INICIO',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'TARJETA MUSEO',
            icon: Icons.museum,
            route: ListarMuseoScreen.id,
          ),
          AdminMenuItem(
            title: 'EVENTOS',
            icon: Icons.museum,
            route: ListarEventoScreen.id,
          ),
          AdminMenuItem(
            title: 'USUARIOS',
            icon: Icons.person,
            route: ListarUsuarioScreen.id,
          ),
        ],
        selectedRoute: ListarMuseoScreen.id,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFF55A07),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen (asegúrate de tener el archivo de imagen en tu proyecto)
              Image.asset(
                'assets/images/splash/logo.png', // Ruta de tu imagen
                height: 35, // Ajusta el tamaño según sea necesario
              ),
              SizedBox(width: 10), // Espacio entre la imagen y el texto
              Text(
                'Museo Traje Bogotá D.C.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xFFF55A07),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => registerTraje(context),
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: Color(0xFFF55A07),
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: Text(
                                  'REGISTRAR TRAJE',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300, // Ajusta el tamaño según sea necesario
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey), // Borde personalizado
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Buscar por nombre de traje',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      filterDocuments(value.toLowerCase());
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Espacio entre los controles y la tabla
                          Expanded(
                            child: filteredDocuments.isNotEmpty
                                ? PaginatedDataTable2(
                              border: TableBorder.all(color: Colors.grey.shade400),
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              rowsPerPage: 10,
                              columns: [
                                DataColumn2(
                                  size: ColumnSize.M,
                                  label: Center(
                                    child: Text(
                                      'TÍTULO',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn2(
                                  size: ColumnSize.L,
                                  label: Center(
                                    child: Text(
                                      'DESCRIPCION CORTA',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn2(
                                  size: ColumnSize.S,
                                  label: Center(
                                    child: Text(
                                      'DESCRIPCION LARGA',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn2(
                                  size: ColumnSize.S,
                                  label: Center(
                                    child: Text(
                                      'ACCIONES',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              source: TrajeDataTableSource(data: filteredDocuments, context: context),
                            )
                                : Center(
                              child: Text('No se encontraron resultados'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerTraje(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebMainRegisterCardMuseo()),
    );
  }
}

class TrajeDataTableSource extends DataTableSource {
  final List<QueryDocumentSnapshot> data;
  final BuildContext context;

  TrajeDataTableSource({required this.data, required this.context});

  @override
  DataRow getRow(int index) {
    final traje = data[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            traje['nombreTraje'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            traje['descriptionShort'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            traje['descriptionLarge'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WebMainUpdateCardMuseo(
                        id: traje.id,
                        museo: ModelTrajeWeb(
                          idTraje: traje['idTraje'],
                          nombreTraje: traje['nombreTraje'],
                          descriptionShort: traje['descriptionShort'],
                          descriptionLarge: traje['descriptionLarge'],
                          imageUrls: traje['imageUrls'],
                          timestamp: FieldValue.serverTimestamp(),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Eliminar Registro'),
                        content: Text('¿Deseas eliminar este registro?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Eliminar'),
                            onPressed: () async {
                              await TrajeControllerWeb.deleteTraje(traje.id);
                              Navigator.of(context).pop();
                              // Redirigir a ListarMuseoScreen después de eliminar
                              Navigator.of(context).pushReplacementNamed(ListarMuseoScreen.id);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
