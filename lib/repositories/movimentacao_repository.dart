import '../core/database_helper.dart';
import '../models/movimentacao_model.dart';

class MovimentacaoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insert(Movimentacao movimentacao) async {
    final db = await _databaseHelper.database;
    return await db.insert('movimentacao', movimentacao.toMap());
  }

  Future<List<Movimentacao>> fetchAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('movimentacao');
    return List.generate(maps.length, (i) => Movimentacao.fromMap(maps[i]));
  }

  Future<List<Movimentacao>> fetchByTurma(int turmaId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movimentacao',
      where: 'idTurma = ?',
      whereArgs: [turmaId],
    );
    return List.generate(maps.length, (i) => Movimentacao.fromMap(maps[i]));
  }

  Future<List<Movimentacao>> fetchByUsuario(int usuarioId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movimentacao',
      where: 'idUsuarios = ?',
      whereArgs: [usuarioId],
    );
    return List.generate(maps.length, (i) => Movimentacao.fromMap(maps[i]));
  }

  Future<int> update(Movimentacao movimentacao) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'movimentacao',
      movimentacao.toMap(),
      where: 'idMovimentacao = ?',
      whereArgs: [movimentacao.idMovimentacao],
    );
  }

  Future<int> delete(int id) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('movimentacao', where: 'idMovimentacao = ?', whereArgs: [id]);
  }
}
