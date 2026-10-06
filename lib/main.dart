import 'package:atividadecontato/lista_contatos_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaContatosPage(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlueAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
        ),
      ),
    ),
  );
}
