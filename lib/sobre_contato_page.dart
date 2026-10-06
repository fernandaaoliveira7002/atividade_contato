import 'package:flutter/material.dart';

class SobreContatoPage extends StatelessWidget {
  const SobreContatoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o APP'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/telefone512x512.png',
                width: 130,
                height: 130,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Aplicativo de gestão de contatos, desenvolvido para ajudar na organização das ligações e informações de contato do dia a dia. Permite cadastrar, visualizar, favoritar e gerenciar contatos, facilitando o controle das ligações e dos contatos de forma simples e prática.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Versão 1.0.0",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
