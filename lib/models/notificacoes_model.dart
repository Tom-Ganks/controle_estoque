class Notificacao {
  final int? id;
  final String solicitanteNome;
  final String solicitanteCargo;
  final String produtoNome;
  final int quantidade;
  final DateTime dataSolicitacao;
  final bool lida;

  Notificacao({
    this.id,
    required this.solicitanteNome,
    required this.solicitanteCargo,
    required this.produtoNome,
    required this.quantidade,
    required this.dataSolicitacao,
    this.lida = false,
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
    );
  }
}
