import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';
import 'package:adminmuseo/user/model/museoUsuarioModel.dart';
import 'package:adminmuseo/museo/traje/model/museoModel.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/register_card_museo.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/update_card_museo.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';

class ListarMuseoScreen extends StatefulWidget {
  static const String id = "listarmuseo";

  @override
  State<ListarMuseoScreen> createState() => _ListarMuseoScreenState();
}

class _ListarMuseoScreenState extends State<ListarMuseoScreen> {
  String searchQuery = "";
  List<QueryDocumentSnapshot> allDocuments = [];
  List<QueryDocumentSnapshot> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('trajes').get();
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
              ModelEventoMuseoTraje.logout(context);
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
          child: const Center(
            child: Text(
              'USUARIOS',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
                        museo: MuseoCard(
                          idTraje: traje['idTraje'],
                          nombreTraje: traje['nombreTraje'],
                          descriptionShort: traje['descriptionShort'],
                          descriptionLarge: traje['descriptionLarge'],
                          imageUrls: traje['imageUrls'],
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
                              await MuseoCard.deleteMuseo(traje.id);
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
