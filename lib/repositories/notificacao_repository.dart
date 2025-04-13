import '../core/database_helper.dart';
import '../models/notificacoes_model.dart';

class NotificacoesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insert(Notificacao notificacao) async {
    final db = await _databaseHelper.database;
    return await db.insert('notificacoes', notificacao.toMap());
  }

  Future<List<Notificacao>> fetchAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      orderBy: 'data_solicitacao DESC',
    );
    return List.generate(maps.length, (i) => Notificacao.fromMap(maps[i]));
  }

  Future<List<Notificacao>> fetchUnread() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      where: 'lida = ?',
      whereArgs: [0],
      orderBy: 'data_solicitacao DESC',
    );
    return List.generate(maps.length, (i) => Notificacao.fromMap(maps[i]));
  }

  Future<List<Notificacao>> fetchByUser(String solicitanteNome) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      where: 'solicitante_nome = ?',
      whereArgs: [solicitanteNome],
      orderBy: 'data_solicitacao DESC',
    );
    return List.generate(maps.length, (i) => Notificacao.fromMap(maps[i]));
  }

  Future<int> markAsRead(int id) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'notificacoes',
      {'lida': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAllAsRead() async {
    final db = await _databaseHelper.database;
    return await db.update(
      'notificacoes',
      {'lida': 1},
      where: 'lida = ?',
      whereArgs: [0],
    );
  }

  Future<int> delete(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'notificacoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await _databaseHelper.database;
    await db.delete('notificacoes');
  }

  Future<int> getUnreadCount() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notificacoes WHERE lida = 0',
    );
    return result.first['count'] as int;
  }

  Future<List<Notificacao>> fetchByMovimentacao(int idMovimentacao) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      where: 'idMovimentacao = ?',
      whereArgs: [idMovimentacao],
      orderBy: 'data_solicitacao DESC',
    );
    return List.generate(maps.length, (i) => Notificacao.fromMap(maps[i]));
  }
}
