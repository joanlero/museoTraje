import 'package:adminmuseo/login/ui/screens/login_screen.dart';
import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/register_evento_museo.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/update_evento_museo.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';

class ListarEventoScreen extends StatefulWidget {
  static const String id = "listareventomuseo";

  @override
  State<ListarEventoScreen> createState() => _ListarEventoScreenState();
}

class _ListarEventoScreenState extends State<ListarEventoScreen> {
  List<DocumentSnapshot> allDocuments = [];
  List<DocumentSnapshot> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('eventos').get();
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
    // Agrega casos para las demás pantallas...
    }
  }

  void filterDocuments(String query) {
    setState(() {
      filteredDocuments = allDocuments.where((doc) {
        final titleEvento = doc['titleEvento'].toString().toLowerCase();
        return titleEvento.contains(query.toLowerCase());
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
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14),
        backgroundColor: Color(0xFFF55A07),
        activeIconColor: Colors.white,
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
        selectedRoute: ListarEventoScreen.id,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFF55A07),
          child: const Center(
            child: Text(
              'EVENTOS MUSEO DEL TRAJE',
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
        child: Stack(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => registerEventoMuseo(context),
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
                            'REGISTRAR EVENTO',
                            style: TextStyle(
                              fontSize: 12.0, // Ajusta el tamaño del texto si es necesario
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
                                hintText: 'Buscar por nombre de evento',
                                border: InputBorder.none, // Sin borde interior
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
                            size: ColumnSize.L,
                            label: Center(
                              child: Text(
                                'NOMBRE EVENTO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: Center(
                              child: Text(
                                'DESCRIPCION CORTA EVENTO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: Center(
                              child: Text(
                                'DESCRIPCION LARGA EVENTO',
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
                        source: EventoDataTableSource(filteredDocuments, context),
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
    );
  }

  void registerEventoMuseo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebMainRegisterEventoMuseo()),
    );
  }
}

class EventoDataTableSource extends DataTableSource {
  final List<DocumentSnapshot> data;
  final BuildContext context;

  EventoDataTableSource(this.data, this.context);

  @override
  DataRow getRow(int index) {
    final evento = data[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            evento['titleEvento'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            evento['descriptionShortEvento'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            evento['descriptionLargeEvento'],
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
                      builder: (_) {
                        return WebMainUpdateEventoMuseo(
                          id: data[index].id,
                          museoEvento: ModelEventoMuseoTraje(
                            idEvento: data[index]['idEvento'],
                            titleEvento: data[index]['titleEvento'],
                            descriptionShortEvento: data[index]['descriptionShortEvento'],
                            descriptionLargeEvento: data[index]['descriptionLargeEvento'],
                            imageUrlsEvento: data[index]['imageUrlsEvento'],
                          ),
                        );
                      },
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
                              await ModelEventoMuseoTraje.deleteEventoMuseo(evento.id);
                              Navigator.of(context).pop();
                              // Redirigir a ListarMuseoScreen después de eliminar
                              Navigator.of(context).pushReplacementNamed(ListarEventoScreen.id);
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
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
