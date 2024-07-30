import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditUbicacionScreen extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? direccion;

  AddEditUbicacionScreen({this.id, this.nombre, this.direccion});

  @override
  _AddEditUbicacionScreenState createState() => _AddEditUbicacionScreenState();
}

class _AddEditUbicacionScreenState extends State<AddEditUbicacionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.nombre != null) {
      _nombreController.text = widget.nombre!;
    }
    if (widget.direccion != null) {
      _direccionController.text = widget.direccion!;
    }
  }

  String? _validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre no puede estar vacío';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'El nombre solo puede contener letras y números';
    }
    return null;
  }

  String? _validateDireccion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La dirección no puede estar vacía';
    }
    if (!RegExp(r'^-?\d+(\.\d+)?,-?\d+(\.\d+)?$').hasMatch(value)) {
      return 'La dirección debe estar en formato (ej: -36.8212801,-73.0141550)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.id == null ? "Añadir Ubicación" : "Editar Ubicación"),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[500],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                validator: _validateNombre,
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: "Dirección (lat,lng)",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                validator: _validateDireccion,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUbicacion,
                child: Text(widget.id == null ? "Guardar" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUbicacion() async {
    if (_formKey.currentState?.validate() ?? false) {
      var nombre = _nombreController.text;
      var direccion = _direccionController.text;
      if (widget.id == null) {
        await _firestore.collection('ubicaciones_frecuentes').add({
          'nombre': nombre,
          'direccion': direccion,
        });
      } else {
        await _firestore
            .collection('ubicaciones_frecuentes')
            .doc(widget.id)
            .update({
          'nombre': nombre,
          'direccion': direccion,
        });
      }
      Navigator.pop(context);
    }
  }
}
