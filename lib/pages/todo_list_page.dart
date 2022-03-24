import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos =[];

  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState(){
    super.initState(); // Função chamada quando o app é iniciado

    todoRepository.getTodoList().then((value) { // Chama a função 'getTodoList', armazena a lista que retornará na variável 'value' que será uma lista
      setState(() {                             // e depois insere essa lista na lista 'todos', que será carregada na tela as informações que foram armazenadas no fechamento do app
        todos = value;
      });
    });
  }

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  void onDelete(Todo todo){ // Função que será utilizada pelo widget filho (todo_list_item)
                            // para deletar uma determinada tarefa
    deletedTodo = todo; // Armazena os dados do card deletado
    deletedTodoPos = todos.indexOf(todo); // Armazena a posição do cad deletado

    setState(() {
      todos.remove(todo); // Remove o card
    });
    todoRepository.saveTodoList(todos); // Salva a lista atualizada no JSON

    ScaffoldMessenger.of(context).clearSnackBars(); // Limpa as snackbars visiveis antes de mostrar a nova
    
    ScaffoldMessenger.of(context).showSnackBar( // Exibição da snackbar
        SnackBar(
          content: Text('Tarefa ${todo.title} foi removida com sucesso!',
            style: const TextStyle(
            color: Color(0xff060708),
            ),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: const Color(0xff00d7f3),
            onPressed: (){
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!); // Funçao que reinsere o card deletado na lista e mesma posição em que ele se encontrava
              });
              todoRepository.saveTodoList(todos); // Salva a lista atualizada no JSON
            },
          ),
          duration: const Duration(seconds: 5), // Duração que a snackbar ficará ativa
        ),
    );
  }

  void showDeleteTodosConfirmationDialog(){ // Função para exibição do alertdialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tudo?'),
        content: const Text('Você tem certeza que deseja apagar todos as tarefas?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(); // Ao cancelar, apenas fecha o alertdialog
            },
            child: const Text('Cancelar'),
            style: TextButton.styleFrom(
              primary: const Color(0xff00d7f3),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(); // Ao clicar, fecha o alertdialog e depois executa a função de deletar as tarefas
              deleteAllTodos();
            },
            child: const Text('Limpar Tudo'),
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos(){ // Função para deletar todas as tarefas
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos); // Salva a lista atualizada no JSON
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText, // Função para exibir uma mensagem de erro
                          labelStyle: const TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                          focusedBorder: const OutlineInputBorder( // Estilo da borda ao entrar em foco
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 3,
                            )
                          )
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        String text  = todoController.text;

                        if(text.isEmpty){ // Verifica se o campo foi preenchido, caso não, exibe mensagem de erro
                          setState(() {
                            errorText = 'Obrigatório informar o nome da tarefa';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo( // Cria uma classe 'Todo'
                            title: text,
                            date: DateTime.now(), // Pega a data/hora atual
                          );
                          todos.add(newTodo); // Adiciona a classe ao List 'todos'
                          errorText = null; // Quando o campo estiver preenchido, retira a mensagem de erro
                        });
                        todoController.clear(); // Limpa o controller do textfield, consequentemente limpa o textfield após inserir uma tarefa

                        todoRepository.saveTodoList(todos); // Salva o JSON com a lista atualizada (pós-inclusão)
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Flexible(
                  child: ListView(
                    shrinkWrap: true, // O tamanho da lista se torna o tamanho dos itens que houver nela
                    children: [
                     for(Todo todo in todos) // Cada item adicionado será incluído no list 'todos' e será construído o widget TodoListItem para cada item
                       TodoListItem(
                         todo: todo,
                         onDelete: onDelete, // Passa a função via parâmetro para o widget filho (todo_list_item)
                       ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                        child: Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: (){
                          showDeleteTodosConfirmationDialog(); // Chama a função de exibição do alertdialog
                        },
                        child: const Text('Limpar Tudo'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14),
                        ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}