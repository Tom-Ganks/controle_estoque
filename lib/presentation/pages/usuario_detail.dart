import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/usuario_model.dart';
import '../../repositories/usuario_repositorie.dart';

class UsuarioDetailPage extends StatefulWidget {
  final Usuario usuario;

  const UsuarioDetailPage({super.key, required this.usuario});

  @override
  State<UsuarioDetailPage> createState() => _UsuarioDetailPageState();
}

class _UsuarioDetailPageState extends State<UsuarioDetailPage> {
  File? _foto;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _enderecoController;
  late TextEditingController _cargoController;
  late TextEditingController _setorController;
  late TextEditingController _statusController;
  late TextEditingController _cpfController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _cargaHorariaController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _emailController = TextEditingController(text: widget.usuario.email);
    _telefoneController = TextEditingController(text: widget.usuario.telefone);
    _enderecoController = TextEditingController(text: widget.usuario.endereco);
    _cargoController = TextEditingController(text: widget.usuario.cargo);
    _setorController = TextEditingController(text: widget.usuario.setor);
    _statusController = TextEditingController(text: widget.usuario.status);
    _cpfController = TextEditingController(text: widget.usuario.cpf);
    _dataNascimentoController = TextEditingController(
      text: widget.usuario.dataNascimento,
    );
    _cargaHorariaController = TextEditingController(
      text: widget.usuario.cargaHoraria,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _cargoController.dispose();
    _setorController.dispose();
    _statusController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _cargaHorariaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
        widget.usuario.foto = pickedFile.path;
      });
      await UsuarioRepository().update(widget.usuario);
    }
  }

  Future<void> _editarUsuario() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: const InputDecoration(labelText: 'Endereço'),
                  ),
                  TextFormField(
                    controller: _cargoController,
                    decoration: const InputDecoration(labelText: 'Cargo'),
                  ),
                  TextFormField(
                    controller: _setorController,
                    decoration: const InputDecoration(labelText: 'Setor'),
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                  ),
                  TextFormField(
                    controller: _dataNascimentoController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                    ),
                  ),
                  TextFormField(
                    controller: _cargaHorariaController,
                    decoration: const InputDecoration(
                      labelText: 'Carga Horária',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.usuario.nome = _nomeController.text;
                  widget.usuario.email = _emailController.text;
                  widget.usuario.telefone = _telefoneController.text;
                  widget.usuario.endereco = _enderecoController.text;
                  widget.usuario.cargo = _cargoController.text;
                  widget.usuario.setor = _setorController.text;
                  widget.usuario.status = _statusController.text;
                  widget.usuario.cpf = _cpfController.text;
                  widget.usuario.dataNascimento =
                      _dataNascimentoController.text;
                  widget.usuario.cargaHoraria = _cargaHorariaController.text;

                  await UsuarioRepository().update(widget.usuario);
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário atualizado com sucesso!'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForLabel(label),
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? "Não informado",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Email':
        return Icons.email;
      case 'Telefone':
        return Icons.phone;
      case 'Endereço':
        return Icons.location_on;
      case 'Cargo':
        return Icons.work;
      case 'Setor':
        return Icons.business;
      case 'Status':
        return Icons.info;
      case 'CPF':
        return Icons.badge;
      case 'Data de Nascimento':
        return Icons.cake;
      case 'Carga Horária':
        return Icons.access_time;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _selecionarFoto,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: _foto != null
                                ? FileImage(_foto!)
                                : widget.usuario.foto != null
                                    ? FileImage(File(widget.usuario.foto!))
                                    : null,
                            child: _foto == null && widget.usuario.foto == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blue,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.usuario.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.usuario.cargo,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _editarUsuario,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text(
                      'Editar Informações',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard('Email', widget.usuario.email),
                  _buildInfoCard('Telefone', widget.usuario.telefone),
                  _buildInfoCard('Endereço', widget.usuario.endereco),
                  _buildInfoCard('Setor', widget.usuario.setor),
                  _buildInfoCard('Status', widget.usuario.status),
                  _buildInfoCard('CPF', widget.usuario.cpf),
                  _buildInfoCard(
                    'Data de Nascimento',
                    widget.usuario.dataNascimento,
                  ),
                  _buildInfoCard('Carga Horária', widget.usuario.cargaHoraria),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
