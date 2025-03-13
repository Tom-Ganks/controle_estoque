import '../models/produto_model.dart';
import '../repositories/produto_repositorie.dart';

class ProdutoViewModel {
  final ProdutoRepository _repository = ProdutoRepository();
  List<Produto> produtos = [];

  Future<void> fetchAllProdutos() async {
    produtos = await _repository.fetchAll();
  }

  Future<bool> insertProduto(Produto produto) async {
    try {
      await _repository.insert(produto);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduto(Produto produto) async {
    try {
      await _repository.update(produto);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduto(int id) async {
    try {
      await _repository.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
