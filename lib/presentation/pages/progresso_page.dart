import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notificacoes_model.dart';
import '../../models/usuario_model.dart';
import '../../repositories/notificacao_repository.dart';
import 'dashboard.dart';

class ProgressoPage extends StatefulWidget {
  final Usuario currentUser;

  const ProgressoPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<ProgressoPage> createState() => _ProgressoPageState();
}

class _ProgressoPageState extends State<ProgressoPage> {
  final NotificacoesRepository _repository = NotificacoesRepository();
  List<Notificacao> solicitacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSolicitacoes();
  }

  Future<void> _loadSolicitacoes() async {
    try {
      final userSolicitacoes =
          await _repository.fetchByUser(widget.currentUser.nome);

      setState(() {
        solicitacoes = userSolicitacoes;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading solicitações: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[500]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(
                              currentUser: widget.currentUser,
                            ),
                          ),
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Minhas Solicitações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : solicitacoes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_rounded,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhuma solicitação encontrada',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadSolicitacoes,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: solicitacoes.length,
                                itemBuilder: (context, index) {
                                  final solicitacao = solicitacoes[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  solicitacao.produtoNome,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: solicitacao
                                                      .getStatusColor()
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  solicitacao
                                                      .getStatusDisplay(),
                                                  style: TextStyle(
                                                    color: solicitacao
                                                        .getStatusColor(),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Quantidade solicitada: ${solicitacao.quantidade}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          if (solicitacao.status == 'parcial' &&
                                              solicitacao.quantidadeAprovada !=
                                                  null)
                                            Text(
                                              'Quantidade aprovada: ${solicitacao.quantidadeAprovada}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.orange[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(solicitacao.dataSolicitacao)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          if (solicitacao.observacao !=
                                              null) ...[
                                            const SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Observação:',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    solicitacao.observacao!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
