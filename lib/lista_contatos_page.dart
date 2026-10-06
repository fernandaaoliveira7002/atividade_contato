import 'package:atividadecontato/database_helper.dart';
import 'package:atividadecontato/sobre_contato_page.dart';
import 'package:flutter/material.dart';

class ListaContatosPage extends StatefulWidget {
  const ListaContatosPage({super.key});

  @override
  State<ListaContatosPage> createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  List<Map<String, dynamic>> contatos = [];

  String? filtroAtual;

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  void carregarContatos() async {
    final dados = await DatabaseHelper.buscarContatos(filtro: filtroAtual);
    setState(() {
      contatos = dados;
    });
  }

  void aplicarFiltro(String? novoFiltro) {
    filtroAtual = novoFiltro;
    Navigator.pop(context);
    carregarContatos();
  }

  Future<void> marcarFavorito(int index) async {
    final contato = contatos[index];
    final novoValor = contato['status'] == 1 ? 0 : 1;
    await DatabaseHelper.atualizarContato(contato['id'], novoValor);
    carregarContatos();
  }

  Future<void> deletarContato(int index) async {
    final contato = contatos[index];
    await DatabaseHelper.deletarContato(contato['id']);
    carregarContatos();
  }

  void adicionarContato() {
    final novoContatoController = TextEditingController();
    final numeroController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Novo Contato"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: novoContatoController,
                decoration: InputDecoration(hintText: 'Digite o nome...'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: numeroController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Digite o número...',
                  labelText: 'Número',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
              ),
            ),
            TextButton(
              onPressed: () async {
                if (novoContatoController.text.isNotEmpty &&
                    numeroController.text.isNotEmpty) {
                  await DatabaseHelper.inserirContato(
                    novoContatoController.text,
                    numeroController.text,
                  );
                  carregarContatos();

                  if (!context.mounted) return;

                  Navigator.pop(context);
                }
              },
              child: Text(
                "Adicionar",
              ),
            ),
          ],
        );
      },
    );
  }

  String gerarSigla(String nome) {
    final palavras = nome.trim().split(' ');

    if (palavras.length >= 2) {
      return '${palavras[0][0]}${palavras[1][0]}'.toUpperCase();
    }

    if (nome.isNotEmpty) {
      return nome[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Contatos"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "Meus Contatos",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Todos os Contatos"),
              selected: filtroAtual == null,
              onTap: () => aplicarFiltro(null),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Contatos favoritos"),
              selected: filtroAtual == 'favoritos',
              onTap: () => aplicarFiltro('favoritos'),
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text("Contatos não favoritos"),
              selected: filtroAtual == 'naofavoritos',
              onTap: () => aplicarFiltro('naofavoritos'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Sobre o APP"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SobreContatoPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: contatos.isEmpty
          ? Center(
              child: Text(
                "Nenhum contato ainda. Clique em + para adicionar um",
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];
                final nome = contato['nome'] ?? '';
                final numero = contato['numero'] ?? '';
                final bool status = contato['status'] == 1;

                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    final int contatoId = contato['id'];
                    await DatabaseHelper.deletarContato(contatoId);

                    carregarContatos();
                  },

                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          gerarSigla(nome),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        contato['nome'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        numero.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: GestureDetector(
                        onTap: () => marcarFavorito(index),
                        child: Icon(
                          status ? Icons.star : Icons.star_border,
                          color: status ? Colors.amber : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarContato(),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
