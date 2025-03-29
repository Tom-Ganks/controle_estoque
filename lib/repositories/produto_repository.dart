import '../core/database_helper.dart';
import '../models/produto_model.dart';

class ProdutoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insert(Produto produto) async {
    return await _databaseHelper.insertProduto(produto);
  }

  Future<List<Produto>> fetchAll() async {
    return await _databaseHelper.fetchAllProdutos();
  }

  Future<int> update(Produto produto) async {
    return await _databaseHelper.updateProduto(produto);
  }

  Future<int> delete(int id) async {
    return await _databaseHelper.deleteProduto(id);
  }
}
