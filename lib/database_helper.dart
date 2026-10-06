import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> abrirBanco() async {
    final caminho = join(await getDatabasesPath(), 'contatos.db');

    return openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE contatos ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nome TEXT,'
          'numero TEXT,'
          'status INTEGER'
          ')',
        );
      },
    );
  }

  static Future<Database> get database async {
    _db ??= await abrirBanco();
    return _db!;
  }

  static Future<List<Map<String, dynamic>>> buscarContatos({
    String? filtro,
  }) async {
    final db = await DatabaseHelper.database;

    if (filtro == 'naofavoritos') {
      return db.query("contatos", where: 'status = ?', whereArgs: [0]);
    }

    if (filtro == 'favoritos') {
      return db.query('contatos', where: 'status = ?', whereArgs: [1]);
    }

    return db.query('contatos');
  }

  static Future<void> inserirContato(String nome, String numero) async {
    final db = await DatabaseHelper.database;
    await db.insert("contatos", {
      'nome': nome,
      'numero': numero,
      'status': 0,
    });
  }

  static Future<void> atualizarContato(int id, int status) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'contatos',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deletarContato(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
