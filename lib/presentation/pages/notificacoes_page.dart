import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notificacoes_model.dart';
import '../../repositories/notificacao_repository.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final NotificacaoRepository _repository = NotificacaoRepository();
  List<Notificacao> _notificacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificacoes();
  }

  Future<void> _loadNotificacoes() async {
    setState(() => _isLoading = true);
    try {
      final notificacoes = await _repository.fetchAll();
      setState(() {
        _notificacoes = notificacoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar notificações')),
        );
      }
    }
  }

  Future<void> _markAsRead(Notificacao notificacao) async {
    try {
      await _repository.markAsRead(notificacao.id!);
      await _loadNotificacoes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao marcar como lida')),
        );
      }
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Notificações',
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _notificacoes.isEmpty
                          ? const Center(
                              child: Text('Nenhuma notificação encontrada'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _notificacoes.length,
                              itemBuilder: (context, index) {
                                final notificacao = _notificacoes[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor: notificacao.lida
                                          ? Colors.grey
                                          : Colors.orange,
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      '${notificacao.solicitanteNome} solicitou ${notificacao.quantidade} unidades de ${notificacao.produtoNome}',
                                      style: TextStyle(
                                        fontWeight: notificacao.lida
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Cargo: ${notificacao.solicitanteCargo}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(notificacao.dataSolicitacao)}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    trailing: !notificacao.lida
                                        ? IconButton(
                                            icon: const Icon(
                                                Icons.check_circle_outline),
                                            onPressed: () =>
                                                _markAsRead(notificacao),
                                          )
                                        : null,
                                  ),
                                );
                              },
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
