class Animal {
  final String nome;
  final String descricao;
  final String imagemUrl;

  Animal({
    required this.nome,
    required this.descricao,
    required this.imagemUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Animal &&
          runtimeType == other.runtimeType &&
          nome == other.nome &&
          descricao == other.descricao &&
          imagemUrl == other.imagemUrl;

  @override
  int get hashCode => nome.hashCode ^ descricao.hashCode ^ imagemUrl.hashCode;
}
