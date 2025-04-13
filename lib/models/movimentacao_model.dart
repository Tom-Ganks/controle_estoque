class Movimentacao {
  int? idMovimentacao;
  int idProdutos;
  int idTurma;
  int idUsuarios;
  DateTime? dataSaida;

  Movimentacao({
    this.idMovimentacao,
    required this.idProdutos,
    required this.idTurma,
    required this.idUsuarios,
    this.dataSaida,
  });

  Map<String, dynamic> toMap() {
    return {
      'idMovimentacao': idMovimentacao,
      'idProdutos': idProdutos,
      'idTurma': idTurma,
      'idUsuarios': idUsuarios,
      'dataSaida': dataSaida?.toIso8601String(),
    };
  }

  factory Movimentacao.fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      idMovimentacao: map['idMovimentacao'],
      idProdutos: map['idProdutos'],
      idTurma: map['idTurma'],
      idUsuarios: map['idUsuarios'],
      dataSaida:
          map['dataSaida'] != null ? DateTime.parse(map['dataSaida']) : null,
    );
  }
}
