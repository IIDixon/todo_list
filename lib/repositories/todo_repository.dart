import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

class TodoRepository{

  late SharedPreferences sharedPreferences; // Variável que receberá o conteúdo do JSON salvo

  Future<List<Todo>> getTodoList () async{
    sharedPreferences = await SharedPreferences.getInstance(); // Inicializa a instância e aguarda a execução
    final String jsonString = sharedPreferences.getString('todo_list') ?? '[]'; // Armazena na variável 'jsonString' o conteúdo do JSON lido 'todo_list'

    //print(jsonString);

    final jsonDecoded = json.decode(jsonString) as List; // Decodifica o JSON e formata em uma lista de objetos
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList(); // Pega cada um dos itens (e) da lista e converte para um objeto 'Todo'
                                                              // chamando a função 'fromJson' e passando o Json como parâmetro
                                                              // e transforma em uma lista
  }

  void saveTodoList(List<Todo> todos){
    final jsonString = json.encode(todos); // Formata em JSON a list 'todos'
    sharedPreferences.setString('todo_list', jsonString); // Salva o JSON com o nome 'todo_list' (Nome que será utilizado depois para leitura quando for aberto o app)
  }
}