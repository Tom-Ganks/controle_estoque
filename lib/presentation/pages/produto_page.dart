import 'package:flutter/material.dart';
import '../../models/produto_model.dart';
import '../../repositories/produto_repository.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/produtoform_dialog.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({super.key});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  List<Produto> produtos = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchProdutos();
  }

  Future<void> _fetchProdutos() async {
    final produtosList = await ProdutoRepository().fetchAll();
    produtosList.sort((a, b) => a.nome.compareTo(b.nome));

    if (!mounted) return;

    setState(() {
      produtos = produtosList;
    });
  }

  Future<void> _addProduto() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const ProdutoFormDialog(),
    );

    if (result != null && result is Produto) {
      try {
        await ProdutoRepository().insert(result);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchProdutos();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar produto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editProduto(Produto produto) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ProdutoFormDialog(produto: produto),
    );

    if (result != null && result is Produto) {
      try {
        await ProdutoRepository().update(result);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchProdutos();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar produto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProduto(int id) async {
    final confirm = await showConfirmationDialog(
      context: context,
      title: 'Confirmar Exclusão',
      content: 'Tem certeza que deseja excluir este produto?',
    );

    if (confirm) {
      try {
        await ProdutoRepository().delete(id);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchProdutos();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir produto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProduto,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.withValues(alpha: 0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  hintText: 'Procurar produtos...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];
                  if (!produto.nome.toLowerCase().contains(searchQuery)) {
                    return Container();
                  }
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        child: Text(
                          produto.nome[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.inventory,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Saldo: ${produto.saldo}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () => _editProduto(produto),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () =>
                                _deleteProduto(produto.idProdutos!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchProdutos,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
