import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: onChanged, //A cada mudança que houver no campo, executará a função onChanged
                onSubmitted: onSubmitted, //Executa a função sempre que digitar o texto e apertar o botão de confirmar no teclado
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email', // nome do campo
                  hintText: 'seunome@email.com', // dica no campo do texto
                  //prefixText: 'R\$ ', // Insere um valor no inicio do campo ('\' para conseguir mostrar o '$')
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                  //border: OutlineInputBorder(), // Insere borda em volta do campo inteiro
                  //errorText: 'Campo Obrigatório', // Mensagem de erro no campo
                  //suffixText: 'cm', // Insere um valor no final do campo
                ),
                keyboardType: TextInputType.emailAddress, // Define quais caracteres permitidos para o campo
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
                //obscureText: true, // deixa o texto digitado invísivel
                //obscuringCharacter: '*', // Define o caracter que será mostrado ao invés do texto digitado
              ),
              ElevatedButton(
                onPressed: login,
                child: Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(){

  }

  void onChanged(String text){
    print('onChanged: $text');
  }

  void onSubmitted(String text){
    print('onSubmitted: $text');
  }
}