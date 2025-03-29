import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';
import '../../repositories/usuario_repository.dart';
import 'dashboard.dart';
import 'usuario_detail.dart';

class UsuarioPage extends StatefulWidget {
  final Usuario currentUser; // Add currentUser parameter

  const UsuarioPage({
    super.key,
    required this.currentUser, // Make currentUser required
  });

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  List<Usuario> usuarios = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    setState(() => isLoading = true);
    try {
      final usuariosList = await UsuarioRepository().fetchAll();
      setState(() {
        usuarios = usuariosList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar usuários: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Usuario> get filteredUsuarios {
    if (searchQuery.isEmpty) return usuarios;
    return usuarios.where((usuario) {
      return usuario.nome.toLowerCase().contains(searchQuery.toLowerCase()) ||
          usuario.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (usuario.cargo.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();
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
                                  )),
                        );
                      },
                    ),
                    const Text(
                      'Usuários',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar usuários...',
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredUsuarios.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum usuário encontrado',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredUsuarios.length,
                              itemBuilder: (context, index) {
                                final usuario = filteredUsuarios[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue[100],
                                      child: usuario.foto != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image.file(
                                                File(usuario.foto!),
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Colors.blue[900],
                                            ),
                                    ),
                                    title: Text(
                                      usuario.nome,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          usuario.email,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            usuario.cargo,
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UsuarioDetailPage(
                                                  usuario: usuario),
                                        ),
                                      );
                                    },
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
