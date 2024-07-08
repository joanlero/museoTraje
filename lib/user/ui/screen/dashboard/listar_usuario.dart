import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';
import 'package:adminmuseo/user/model/museoUsuarioModel.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/register_usuario.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/update_usuario.dart';

class ListarUsuarioScreen extends StatefulWidget {
  static const String id = "listarusuario";

  @override
  State<ListarUsuarioScreen> createState() => _ListarUsuarioScreenState();
}

class _ListarUsuarioScreenState extends State<ListarUsuarioScreen> {
  List<DocumentSnapshot> allUsuarios = [];
  List<DocumentSnapshot> filteredUsuarios = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('usuarios').get();
    setState(() {
      allUsuarios = snapshot.docs;
      filteredUsuarios = allUsuarios; // Mostrar inicialmente todos los usuarios
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

  void filterUsuarios(String query) {
    setState(() {
      filteredUsuarios = allUsuarios.where((doc) {
        final correoUser = doc['correoUser'].toString().toLowerCase();
        return correoUser.contains(query.toLowerCase());
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
        selectedRoute: ListarUsuarioScreen.id, // Asegúrate de ajustar esto según la pantalla activa
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
                          onPressed: () => registerUser(context),
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
                            'REGISTRAR USUARIO',
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
                                hintText: 'Buscar por correo de usuario',
                                border: InputBorder.none, // Sin borde interior
                              ),
                              onChanged: (value) {
                                filterUsuarios(value.toLowerCase());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Espacio entre los controles y la tabla
                    Expanded(
                      child: filteredUsuarios.isNotEmpty
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
                                'NOMBRES',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Center(
                              child: Text(
                                'CORREO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: Center(
                              child: Text(
                                'PASSWORD',
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
                        source: UsuarioDataTableSource(filteredUsuarios, context),
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

  void registerUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebMainRegisterUsuario()),
    );
  }
}

class UsuarioDataTableSource extends DataTableSource {
  final List<DocumentSnapshot> data;
  final BuildContext context;

  UsuarioDataTableSource(this.data, this.context);

  @override
  DataRow getRow(int index) {
    final usuario = data[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            usuario['nombreUser'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            usuario['correoUser'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            usuario['passwordUser'],
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
                        return WebMainUpdateUser(
                          id: usuario.id,
                          museoUser: ModelUser(
                            idUser: usuario['idUser'],
                            nombreUser: usuario['nombreUser'],
                            correoUser: usuario['correoUser'],
                            direccionUser: usuario['direccionUser'],
                            passwordUser: usuario['passwordUser'],
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
                              await ModelUser.deleteUser(usuario.id);
                              Navigator.of(context).pop();
                              // Redirigir a ListarMuseoScreen después de eliminar
                              Navigator.of(context).pushReplacementNamed(ListarUsuarioScreen.id);
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
