import 'package:flutter/material.dart';
import '../models/produto_model.dart';

class ProdutoFormDialog extends StatefulWidget {
  final Produto? produto;

  const ProdutoFormDialog({super.key, this.produto});

  @override
  State<ProdutoFormDialog> createState() => _ProdutoFormDialogState();
}

class _ProdutoFormDialogState extends State<ProdutoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _medidaController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _entradaController = TextEditingController();
  final TextEditingController _saidaController = TextEditingController();
  final TextEditingController _saldoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _dataEntradaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _nomeController.text = widget.produto!.nome;
      _medidaController.text = widget.produto!.medida.toString();
      _localController.text = widget.produto!.local ?? '';
      _entradaController.text = widget.produto!.entrada.toString();
      _saidaController.text = widget.produto!.saida.toString();
      _saldoController.text = widget.produto!.saldo.toString();
      _codigoController.text = widget.produto!.codigo ?? '';
      _dataEntradaController.text = widget.produto!.dataEntrada ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.produto == null ? 'Adicionar Produto' : 'Editar Produto',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medidaController,
                decoration: const InputDecoration(labelText: 'Medida'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a medida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              TextFormField(
                controller: _entradaController,
                decoration: const InputDecoration(labelText: 'Entrada'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _saidaController,
                decoration: const InputDecoration(labelText: 'Saída'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _saldoController,
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
              TextFormField(
                controller: _dataEntradaController,
                decoration: const InputDecoration(labelText: 'Data de Entrada'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final produto = Produto(
                idProdutos: widget.produto?.idProdutos,
                nome: _nomeController.text,
                medida: int.tryParse(_medidaController.text) ?? 0,
                local: _localController.text,
                entrada: int.tryParse(_entradaController.text) ?? 0,
                saida: int.tryParse(_saidaController.text) ?? 0,
                saldo: int.tryParse(_saldoController.text) ?? 0,
                codigo: _codigoController.text,
                dataEntrada: _dataEntradaController.text,
              );
              Navigator.of(context).pop(produto);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
