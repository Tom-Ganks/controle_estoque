class Usuario {
  int? id;
  String nome;
  String email;
  String telefone;
  String endereco;
  String cargo;
  String senha;
  String? foto;
  String status; // 'admin' ou 'user'
  String? setor; // Novo campo
  String? cpf; // Novo campo
  String? rg; // Novo campo
  String? dataNascimento; // Novo campo
  String? cargaHoraria; // Novo campo

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.endereco,
    required this.cargo,
    required this.senha,
    this.foto,
    required this.status,
    this.setor,
    this.cpf,
    this.rg,
    this.dataNascimento,
    this.cargaHoraria, // Novo campo
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'cargo': cargo,
      'senha': senha,
      'foto': foto,
      'status': status,
      'setor': setor, // Novo campo
      'cpf': cpf, // Novo campo
      'rg': rg, // Novo campo
      'dataNascimento': dataNascimento, // Novo campo
      'cargaHoraria': cargaHoraria, // Novo campo
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      endereco: map['endereco'],
      cargo: map['cargo'],
      senha: map['senha'],
      foto: map['foto'],
      status: map['status'],
      setor: map['setor'], // Novo campo
      cpf: map['cpf'], // Novo campo
      rg: map['rg'], // Novo campo
      dataNascimento: map['dataNascimento'], // Novo campo
      cargaHoraria: map['cargaHoraria'], // Novo campo
    );
  }
}
