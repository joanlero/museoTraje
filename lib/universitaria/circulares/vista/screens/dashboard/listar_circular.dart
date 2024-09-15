import 'package:adminmuseo/universitaria/circulares/controller/circularesControllerWeb.dart';
import 'package:adminmuseo/universitaria/circulares/model/modelCircular.dart';
import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/register_circular.dart';
import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/update_circular.dart';
import 'package:adminmuseo/universitaria/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/listar_evento.dart';
import 'package:adminmuseo/universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'package:adminmuseo/universitaria/pregrado/vista/screens/dashboard/listar_pregrado.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:adminmuseo/universitaria/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';

class ListarCircularScreen extends StatefulWidget {
  static const String id = "listarcircular";

  @override
  State<ListarCircularScreen> createState() => _ListarCircularScreenState();
}

class _ListarCircularScreenState extends State<ListarCircularScreen> {
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
        .collection('circulares')
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden ascendente
        .get();

    setState(() {
      allDocuments = snapshot.docs;
      filteredDocuments = allDocuments; // Mostrar inicialmente todos los documentos
    });
  }


  void chooseScreens(item) {
    switch (item) {
      case ListarCircularScreen.id:
        Navigator.pushNamed(context, ListarCircularScreen.id);
        break;
      case ListarEventoScreen.id:
        Navigator.pushNamed(context, ListarEventoScreen.id);
        break;
      case ListarPosgradoScreen.id:
        Navigator.pushNamed(context, ListarPosgradoScreen.id);
        break;
      case ListarPregradoScreen.id:
        Navigator.pushNamed(context, ListarPregradoScreen.id);
        break;
      case ListarTecnicaScreen.id:
        Navigator.pushNamed(context, ListarTecnicaScreen.id);
        break;
      case ListarUsuarioScreen.id:
        Navigator.pushNamed(context, ListarUsuarioScreen.id);
        break;
    // Agrega casos para las demás pantallas...
    }
  }

  void filterDocuments(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredDocuments = allDocuments.where((doc) {
        final nombreCircular = doc['nombreCircular'].toString().toLowerCase();
        return nombreCircular.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF03045e),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white, size: 35,),
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
        backgroundColor: Color(0xFF03045e),
        activeIconColor: Color(0xFF03045e),
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Colors.white,

        items: const [
          AdminMenuItem(
            title: 'INICIO',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'CIRCULAR',
            icon: Icons.book,
            route: ListarCircularScreen.id,
          ),
          AdminMenuItem(
            title: 'EVENTOS',
            icon: Icons.event,
            route: ListarEventoScreen.id,
          ),
          AdminMenuItem(
            title: 'CARRERAS',
            icon: Icons.menu_book,
            children: [
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'POSGRADOS',
                route: ListarPosgradoScreen.id,
              ),
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'PREGRADOS',
                route: ListarPregradoScreen.id,
              ),
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'CARRERAS TÉCNICAS',
                route: ListarTecnicaScreen.id,
              ),
            ],
          ),
          AdminMenuItem(
              title: 'USUARIOS',
              icon: Icons.file_copy,
              route: ListarUsuarioScreen.id
          ),
        ],
        selectedRoute: ListarCircularScreen.id,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFF03045e),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen (asegúrate de tener el archivo de imagen en tu proyecto)
              Image.asset(
                'assets/images/splash/logoUniversitaria.png', // Ruta de tu imagen
                height: 60, // Ajusta el tamaño según sea necesario
              ),

            ],
          ),
        ),

        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xFF03045e),
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
                                onPressed: () => registerCircular(context),
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: Color(0xFF03045e),
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: Text(
                                  'REGISTRAR CIRCULAR',
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
                                      labelText: 'Buscar por nombre de circulares',
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
                              source: CircularDataTableSource(data: filteredDocuments, context: context),
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

  void registerCircular(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebMainRegisterCircular()),
    );
  }
}

class   CircularDataTableSource extends DataTableSource {
  final List<QueryDocumentSnapshot> data;
  final BuildContext context;

  CircularDataTableSource({required this.data, required this.context});

  @override
  DataRow getRow(int index) {
    final circularIndex = data[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            circularIndex['nombreCircular'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            circularIndex['descriptionShortCircular'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            circularIndex['descriptionLargeCircular'] ?? '',
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
                      builder: (_) => WebMainUpdateCircular(
                        id: circularIndex.id,
                        circular: ModelCircularWeb(
                          idCircular: circularIndex['idCircular'],
                          nombreCircular: circularIndex['nombreCircular'],
                          descriptionShortCircular: circularIndex['descriptionShortCircular'],
                          descriptionLargeCircular: circularIndex['descriptionLargeCircular'],
                          imageUrls: circularIndex['imageUrls'],
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
                              await CircularesControllerWeb.deleteCircular(circularIndex.id);
                              Navigator.of(context).pop();
                              // Redirigir a ListarMuseoScreen después de eliminar
                              Navigator.of(context).pushReplacementNamed(ListarCircularScreen.id);
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
