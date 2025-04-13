class Notificacao {
  int? id;
  String solicitanteNome;
  String solicitanteCargo;
  String produtoNome;
  int quantidade;
  DateTime dataSolicitacao;
  bool lida;
  int? idMovimentacao;
  String? observacao;
  String status; // Adicionado campo status

  Notificacao({
    this.id,
    required this.solicitanteNome,
    required this.solicitanteCargo,
    required this.produtoNome,
    required this.quantidade,
    required this.dataSolicitacao,
    this.lida = false,
    this.idMovimentacao,
    this.observacao,
    this.status =
        'pendente', // Valores possíveis: pendente, aprovado, parcial, recusado
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'solicitante_nome': solicitanteNome,
      'solicitante_cargo': solicitanteCargo,
      'produto_nome': produtoNome,
      'quantidade': quantidade,
      'data_solicitacao': dataSolicitacao.toIso8601String(),
      'lida': lida ? 1 : 0,
      'idMovimentacao': idMovimentacao,
      'observacao': observacao,
      'status': status,
    };
  }

  factory Notificacao.fromMap(Map<String, dynamic> map) {
    return Notificacao(
      id: map['id'],
      solicitanteNome: map['solicitante_nome'],
      solicitanteCargo: map['solicitante_cargo'],
      produtoNome: map['produto_nome'],
      quantidade: map['quantidade'],
      dataSolicitacao: DateTime.parse(map['data_solicitacao']),
      lida: map['lida'] == 1,
      idMovimentacao: map['idMovimentacao'],
      observacao: map['observacao'],
      status: map['status'] ?? 'pendente',
    );
  }
}
