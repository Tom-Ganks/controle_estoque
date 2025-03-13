import 'package:flutter/material.dart';
import '../../models/produto_model.dart';
import '../../repositories/produto_repositorie.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/summary_card.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalProdutos = 0;
  int produtosEmFalta = 0;
  int produtosAcabando = 0;
  List<Produto> produtos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEstoqueResumo();
    _showNotification();
  }

  Future<void> _fetchEstoqueResumo() async {
    try {
      final List<Produto> produtosList = await ProdutoRepository().fetchAll();

      if (!mounted) return;

      setState(() {
        produtos = produtosList;
        totalProdutos = produtosList.length;
        produtosEmFalta = produtosList.where((p) => p.saldo <= 0).length;
        produtosAcabando =
            produtosList.where((p) => p.saldo > 0 && p.saldo <= 5).length;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching estoque resumo: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar dados do estoque'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showNotification() async {
    await Future.delayed(const Duration(seconds: 1)); // Aguarda o carregamento

    if (produtosEmFalta > 0 || produtosAcabando > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Produtos em falta: $produtosEmFalta\nProdutos acabando: $produtosAcabando',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _fetchEstoqueResumo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Controle'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showConfirmationDialog(
                context: context,
                title: 'Confirmar Logout',
                content: 'Tem certeza que deseja sair?',
              );

              if (confirm) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Visão Geral',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/produtos');
                              },
                              child: SummaryCard(
                                label: 'Total de Produtos',
                                value: totalProdutos,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/produtos');
                              },
                              child: SummaryCard(
                                label: 'Produtos em Falta',
                                value: produtosEmFalta,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/produtos');
                              },
                              child: SummaryCard(
                                label: 'Produtos Acabando',
                                value: produtosAcabando,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'Ações Rápidas',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedActionCard(
                              icon: Icons.inventory,
                              label: 'Gerenciar\nEstoque',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.pushNamed(context, '/produtos')
                                    .then((_) => _refreshData());
                              },
                            ),
                            AnimatedActionCard(
                              icon: Icons.people_alt_rounded,
                              label: 'Staff',
                              color: Colors.red,
                              onTap: () {
                                Navigator.pushNamed(context, '/usuarios')
                                    .then((_) => _refreshData());
                              },
                            ),
                            AnimatedActionCard(
                              icon: Icons.people,
                              label: 'Solicitações',
                              color: Colors.purple,
                              onTap: () {
                                Navigator.pushNamed(context, '/solicitacoes')
                                    .then((_) => _refreshData());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
