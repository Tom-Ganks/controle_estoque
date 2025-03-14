import '../models/usuario_model.dart';
import '../repositories/usuario_repositorie.dart';

class UsuarioViewModel {
  final UsuarioRepository _repository = UsuarioRepository();
  List<Usuario> usuarios = [];

  Future<void> fetchAllUsuarios() async {
    usuarios = await _repository.fetchAll();
  }

  Future<bool> insertUsuario(Usuario usuario) async {
    try {
      await _repository.insert(usuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUsuario(Usuario usuario) async {
    try {
      await _repository.update(usuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUsuario(int id) async {
    try {
      await _repository.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Usuario?> loginUser(String email, String senha) async {
    try {
      await fetchAllUsuarios(); // Ensure we have the latest user list

      // Find user with matching email and password
      final user = usuarios.firstWhere(
        (u) => u.email == email && u.senha == senha,
        orElse: () => throw Exception('User not found'),
      );

      // Return the logged-in user
      return user;
    } catch (e) {
      return null; // Return null if login fails
    }
  }
}
