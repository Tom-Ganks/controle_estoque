import 'package:sqflite/sqflite.dart';
import '../models/notificacoes_model.dart';

class NotificacaoRepository {
  Future<Database> get database async => await DatabaseProvider.database;

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notificacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitante_nome TEXT NOT NULL,
        solicitante_cargo TEXT NOT NULL,
        produto_nome TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        data_solicitacao TEXT NOT NULL,
        lida INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insert(Notificacao notificacao) async {
    final db = await database;
    return await db.insert('notificacoes', notificacao.toMap());
  }

  Future<List<Notificacao>> fetchAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      orderBy: 'data_solicitacao DESC',
    );

    return List.generate(maps.length, (i) => Notificacao.fromMap(maps[i]));
  }

  Future<int> markAsRead(int id) async {
    final db = await database;
    return await db.update(
      'notificacoes',
      {'lida': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notificacoes WHERE lida = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
