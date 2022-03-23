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

  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
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

    ScaffoldMessenger.of(context).clearSnackBars(); // Limpa as snackbars visiveis antes de mostrar a nova
    
    ScaffoldMessenger.of(context).showSnackBar(
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
                todos.insert(deletedTodoPos!, deletedTodo!); // Funçao que reinsere o card deletado na mesma posição que ele se encontrava
              });
            },
          ),
          duration: const Duration(seconds: 5), // Duração que a snackbar ficará ativa
        ),
    );
  }

  void showDeleteTodosConfirmationDialog(){
    print('Chamou a função');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todos as tarefas?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
            style: TextButton.styleFrom(
              primary: Color(0xff00d7f3),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: Text('Limpar Tudo'),
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        String text  = todoController.text;
                        setState(() {
                          Todo newTodo = Todo( // Cria uma classe 'Todo'
                            title: text,
                            date: DateTime.now(),
                          );
                          todos.add(newTodo); // Adiciona a classe ao List 'todos'
                        });
                        todoController.clear(); // Limpa o controller do textfield, consequentemente limpa o textfield após inserir uma tarefa

                        todoRepository.saveTodoList(todos);
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
                const SizedBox(height: 25,),
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
                const SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(
                        child: Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: (){
                          showDeleteTodosConfirmationDialog();
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