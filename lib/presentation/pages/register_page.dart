import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:image_picker/image_picker.dart';

import '../../models/usuario_model.dart';
import '../../repositories/usuario_repository.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmasenhaController = TextEditingController();
  final TextEditingController cpfController =
      TextEditingController(); // Add CPF controller

  File? _foto;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  Future<void> registerUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      final usuario = Usuario(
        nome: nomeController.text,
        email: emailController.text,
        telefone: telefoneController.text,
        endereco: enderecoController.text,
        cargo: cargoController.text,
        senha: senhaController.text,
        foto: _foto?.path,
        cpf: cpfController.text, // Add CPF to the Usuario model
        // Adicionando o campo de nível de acesso
        status: cargoController.text.toLowerCase() == 'administração'
            ? 'admin'
            : 'user',
      );

      try {
        await UsuarioRepository().insert(usuario);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuário registrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao registrar usuário: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
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
                            backgroundImage:
                                _foto != null ? FileImage(_foto!) : null,
                            child: _foto == null
                                ? const Icon(Icons.person_add,
                                    size: 50, color: Colors.blue)
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
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: nomeController,
                          label: 'Nome Completo',
                          icon: Icons.person,
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: 'E-mail',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          controller: telefoneController,
                          label: 'Telefone',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                            LengthLimitingTextInputFormatter(
                                11), // Limit to 11 digits
                            _TelefoneInputFormatter(), // Custom formatter for phone number
                          ],
                        ),
                        _buildTextField(
                          controller: cpfController, // Add CPF field
                          label: 'CPF',
                          icon: Icons.credit_card,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                            LengthLimitingTextInputFormatter(
                                11), // Limit to 11 digits
                            _CpfInputFormatter(), // Custom formatter for CPF
                          ],
                        ),
                        _buildTextField(
                          controller: enderecoController,
                          label: 'Endereço',
                          icon: Icons.location_on,
                        ),
                        DropdownButtonFormField<String>(
                          value: cargoController.text.isEmpty
                              ? null
                              : cargoController.text,
                          decoration: InputDecoration(
                            labelText: 'Cargo',
                            prefixIcon:
                                const Icon(Icons.work, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Administração',
                                child: Text('Administração')),
                            DropdownMenuItem(
                                value: 'Staff', child: Text('Staff')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              cargoController.text = value;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecione um cargo';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: senhaController,
                          label: 'Senha',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        _buildTextField(
                          controller: confirmasenhaController,
                          label: 'Confirmar Senha',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) {
                            if (value != senhaController.text) {
                              return 'As senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registerUsuario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Criar Conta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Já tem uma conta? Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters, // Add inputFormatters parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters, // Pass inputFormatters
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, preencha este campo';
              }
              return null;
            },
      ),
    );
  }
}

// Custom formatter for phone number
class _TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to max 11 digits
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    String formattedText = '';

    // Format: (XX) XXXXX-XXXX or (XX) XXXX-XXXX
    if (text.isNotEmpty) {
      // Add area code
      formattedText = '(${text.substring(0, text.length.clamp(0, 2))}';

      if (text.length > 2) {
        formattedText += ') ';

        // Add first part of the number
        if (text.length <= 6) {
          formattedText += text.substring(2);
        } else {
          formattedText += text.substring(2, 6);

          // Add hyphen and remaining digits
          if (text.length > 6) {
            formattedText += '-';
            formattedText += text.substring(6);
          }
        }
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 11 digits
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    String formattedText = '';

    // Format: XXX.XXX.XXX-XX
    if (text.isNotEmpty) {
      // First group
      formattedText = text.substring(0, text.length.clamp(0, 3));

      if (text.length > 3) {
        formattedText += '.${text.substring(3, text.length.clamp(3, 6))}';

        if (text.length > 6) {
          formattedText += '.${text.substring(6, text.length.clamp(6, 9))}';

          if (text.length > 9) {
            formattedText += '-${text.substring(9)}';
          }
        }
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
