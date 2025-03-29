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
  String? dataNascimento; // Novo campo
  String? cargaHoraria; // Novo campo
  String? turma;

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
    this.dataNascimento,
    this.cargaHoraria, // Novo campo
    this.turma,
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
      'dataNascimento': dataNascimento, // Novo campo
      'cargaHoraria': cargaHoraria, // Novo campo
      'turma': turma,
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
      dataNascimento: map['dataNascimento'], // Novo campo
      cargaHoraria: map['cargaHoraria'], // Novo campo
      turma: map['turma'],
    );
  }
}
