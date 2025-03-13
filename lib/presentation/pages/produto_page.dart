import 'package:flutter/material.dart';

import '../../models/produto_model.dart';
import '../../repositories/produto_repositorie.dart';
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
    produtosList.sort((a, b) => a.nome.compareTo(b.nome)); // Ordena por nome

    if (!mounted) return;

    setState(() {
      produtos = produtosList;
    });
  }

  Future<void> _addProduto() async {
    final result = await showDialog(
      context: context,
      builder: (context) =>
          const ProdutoFormDialog(), // Abre o diálogo de adição
    );

    if (result != null && result is Produto) {
      try {
        await ProdutoRepository().insert(result);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto adicionado com sucesso!')),
        );
        _fetchProdutos(); // Atualiza a lista de produtos
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar produto: $e')),
        );
      }
    }
  }

  Future<void> _editProduto(Produto produto) async {
    final result = await showDialog(
      context: context,
      builder: (context) =>
          ProdutoFormDialog(produto: produto), // Abre o diálogo de edição
    );

    if (result != null && result is Produto) {
      try {
        await ProdutoRepository().update(result);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
        _fetchProdutos(); // Atualiza a lista de produtos
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar produto: $e')),
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
          const SnackBar(content: Text('Produto excluído com sucesso!')),
        );
        _fetchProdutos(); // Atualiza a lista de produtos
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir produto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProduto, // Botão de adicionar produto
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Procurar produtos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                if (!produto.nome.toLowerCase().contains(searchQuery)) {
                  return Container();
                }
                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text('Saldo: ${produto.saldo}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editProduto(produto),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduto(produto.idProdutos!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
