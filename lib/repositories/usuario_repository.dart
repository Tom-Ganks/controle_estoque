import '../core/database_helper.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insert(Usuario usuario) async {
    return await _databaseHelper.insertUsuario(usuario);
  }

  Future<List<Usuario>> fetchAll() async {
    return await _databaseHelper.fetchAllUsuarios();
  }

  Future<int> update(Usuario usuario) async {
    return await _databaseHelper.updateUsuario(usuario);
  }

  Future<int> delete(int id) async {
    return await _databaseHelper.deleteUsuario(id);
  }
}
