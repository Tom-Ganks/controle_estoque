import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notificacoes_model.dart';
import '../../models/usuario_model.dart';
import '../../repositories/notificacao_repository.dart';

class ProgressoPage extends StatefulWidget {
  final Usuario currentUser;

  const ProgressoPage({super.key, required this.currentUser});

  @override
  State<ProgressoPage> createState() => _ProgressoPageState();
}

class _ProgressoPageState extends State<ProgressoPage> {
  final NotificacoesRepository _repository = NotificacoesRepository();
  List<Notificacao> _solicitacoes = [];
  bool _isLoading = true;
  String _filterStatus = 'todas';

  @override
  void initState() {
    super.initState();
    _loadSolicitacoes();
  }

  Future<void> _loadSolicitacoes() async {
    setState(() => _isLoading = true);
    try {
      final solicitacoes =
          await _repository.fetchByUser(widget.currentUser.nome);
      setState(() {
        _solicitacoes = solicitacoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar solicitações')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'aprovado':
        return Colors.green;
      case 'parcial':
        return Colors.orange;
      case 'recusado':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSolicitacoes = _filterStatus == 'todas'
        ? _solicitacoes
        : _solicitacoes.where((s) => s.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Solicitações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredSolicitacoes.isEmpty
              ? const Center(child: Text('Nenhuma solicitação encontrada'))
              : RefreshIndicator(
                  onRefresh: _loadSolicitacoes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSolicitacoes.length,
                    itemBuilder: (context, index) {
                      final solicitacao = filteredSolicitacoes[index];
                      return _buildSolicitacaoCard(solicitacao);
                    },
                  ),
                ),
    );
  }

  Widget _buildSolicitacaoCard(Notificacao solicitacao) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(solicitacao.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    solicitacao.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(solicitacao.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Quantidade: ${solicitacao.quantidade}'),
            Text(
                'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(solicitacao.dataSolicitacao)}'),
            if (solicitacao.observacao != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  solicitacao.observacao!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Todas'),
              value: 'todas',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Pendentes'),
              value: 'pendente',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Aprovadas'),
              value: 'aprovado',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Parciais'),
              value: 'parcial',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Recusadas'),
              value: 'recusado',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
