class Produto {
  int? idProdutos;
  String nome;
  int medida;
  String? local;
  int entrada;
  int saida;
  int saldo;
  String? codigo;
  String? dataEntrada;

  Produto({
    this.idProdutos,
    required this.nome,
    required this.medida,
    this.local,
    required this.entrada,
    required this.saida,
    required this.saldo,
    this.codigo,
    this.dataEntrada,
  });

  // Converte um Produto para um Map (útil para inserir no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'idProdutos': idProdutos,
      'nome': nome,
      'medida': medida,
      'local': local,
      'entrada': entrada,
      'saida': saida,
      'saldo': saldo,
      'codigo': codigo,
      'dataEntrada': dataEntrada,
    };
  }

  // Converte um Map para um Produto (útil para ler do banco de dados)
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      idProdutos: map['idProdutos'],
      nome: map['nome'],
      medida: map['medida'],
      local: map['local'],
      entrada: map['entrada'],
      saida: map['saida'],
      saldo: map['saldo'],
      codigo: map['codigo'],
      dataEntrada: map['dataEntrada'],
    );
  }
}
