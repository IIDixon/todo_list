class Todo{

  Todo({required this.title, required this.date});

  Todo.fromJson(Map<String, dynamic> json) // Construtor que recebe um Map(JSON) como parâmetro, utilizado na leitura do JSON ao abrir o app
      : title = json['title'],             // lê as chaves do JSON e armazena nas propriedades. OBS: As chaves devem ser iguais as salvas na função 'toJson'
        date = DateTime.parse(json['date']); // Necessário para converter o dado do JSON em DateTime. OBS: Quando o dado tiver sido salvo em 'toIso8601String'


  String title;
  DateTime date;

  Map<String, dynamic> toJson(){ // Função que retorna um Map, utilizada para criação do JSON
    return {
      'title': title,
      'date' : date.toIso8601String(), // Converte o dado em uma string especifica para datas, facilitando na leitura do JSON posteriormente
    };
  }

}