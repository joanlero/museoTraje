
import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/listar_circular.dart';
import 'package:adminmuseo/universitaria/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/universitaria/eventos/model/modelEventoWeb.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/register_evento.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/update_evento.dart';
import 'package:adminmuseo/universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'package:adminmuseo/universitaria/pregrado/vista/screens/dashboard/listar_pregrado.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:adminmuseo/universitaria/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';

class ListarEventoScreen extends StatefulWidget {
  static const String id = "listareventouniversitaria";

  @override
  State<ListarEventoScreen> createState() => _ListarEventoScreenState();
}

class _ListarEventoScreenState extends State<ListarEventoScreen> {
  final EventoControllerWeb _eventoController = EventoControllerWeb();
  List<DocumentSnapshot> allDocuments = [];
  List<DocumentSnapshot> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('eventos')
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
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14),
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
        selectedRoute: WebMainRegisterEventoUniversitaria.id,
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
              ), // Espacio entre la imagen y el texto
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
                          onPressed: () => registerEventoUniversitaria(context),
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
                            'REGISTRAR EVENTO',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar por nombre de evento',
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
                    SizedBox(height: 10),
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
                        source: EventoDataTableSource(filteredDocuments, context, _eventoController),
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

  void registerEventoUniversitaria(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebMainRegisterEventoUniversitaria()),
    );
  }
}

class EventoDataTableSource extends DataTableSource {
  final List<DocumentSnapshot> data;
  final BuildContext context;
  final EventoControllerWeb _eventoController;

  EventoDataTableSource(this.data, this.context, this._eventoController);

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
                        return WebMainUpdateEventoUniversitaria(
                          id: data[index].id,
                          universitariaEvento: ModelEventoWeb(
                            idEvento: data[index]['idEvento'],
                            titleEvento: data[index]['titleEvento'],
                            descriptionShortEvento: data[index]['descriptionShortEvento'],
                            descriptionLargeEvento: data[index]['descriptionLargeEvento'],
                            imageUrlsEvento: data[index]['imageUrlsEvento'],
                            timestamp: FieldValue.serverTimestamp(),
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
                              await _eventoController.deleteEventoUniversitaria(evento.id);
                              Navigator.of(context).pop();
                              // Redirigir a ListarEventoScreen después de eliminar
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
