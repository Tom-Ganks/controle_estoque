import 'package:flutter/material.dart';
import '../../models/produto_model.dart';
import '../../repositories/produto_repositorie.dart';
import 'dashboard.dart';

class SolicitacaoPage extends StatefulWidget {
  const SolicitacaoPage({super.key});

  @override
  State<SolicitacaoPage> createState() => _SolicitacaoPageState();
}

class _SolicitacaoPageState extends State<SolicitacaoPage> {
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

  Future<void> _solicitarProduto(Produto produto) async {
    final quantidade = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Solicitar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Saldo atual: ${produto.saldo}'),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade a solicitar',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantidade = int.tryParse(controller.text);
                if (quantidade != null && quantidade > 0) {
                  Navigator.of(context).pop(quantidade);
                }
              },
              child: const Text('Solicitar'),
            ),
          ],
        );
      },
    );

    if (quantidade != null) {
      // Implementar lógica para enviar solicitação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitação de $quantidade unidades de ${produto.nome} enviada.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implementar busca
            },
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
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _solicitarProduto(produto),
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
