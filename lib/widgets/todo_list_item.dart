import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/pages/todo_list_page.dart';

import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.todo, required this.onDelete,}) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete; // Função criada que receberá a função do widget pai, passada via construtor
                                // Necessário fazer isso para que seja atualizada em tempo real o list no widget pai

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Alinha o texto
              children: [
                Text(DateFormat('dd/MM/yyyy - HH:mm').format(todo.date), // Formata a data/hora
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actionExtentRatio: 0.25, // Tamanho da área dos botões adicionais
          actionPane: const SlidableStrechActionPane(), // Cria a ação de deslizar
          secondaryActions: [
            IconSlideAction( // Cria o botão de excluir
              color: Colors.red,
              icon: Icons.delete,
              caption: 'Deletar Tarefa',
              onTap: (){
                onDelete(todo); // Chama a função criada no widget pai, passada via parâmetro no construtor
                                // para deletar o card
              },
            )
          ],
      ),
    );
  }
}
