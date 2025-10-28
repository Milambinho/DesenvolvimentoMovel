import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'historico_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  String display = '0';
  String memoria = '0';
  String expressao = '';

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final dados = await dbHelper.getDados();
    setState(() {
      display = dados['numero_atual'];
      memoria = dados['memoria'];
    });
  }

  void atualizarBanco() {
    dbHelper.updateDados(display, memoria);
  }

  void pressionar(String valor) {
    setState(() {
      if (valor == 'C') {
        display = '0';
        expressao = '';
      } else if (['+', '-', '*', '/'].contains(valor)) {
        expressao = '$display $valor';
        display = '0';
      } else if (valor == '=') {
        try {
          final partes = expressao.split(' ');
          if (partes.length == 2) {
            final n1 = double.parse(partes[0]);
            final op = partes[1];
            final n2 = double.parse(display);
            double resultado = 0;

            switch (op) {
              case '+':
                resultado = n1 + n2;
                break;
              case '-':
                resultado = n1 - n2;
                break;
              case '*':
                resultado = n1 * n2;
                break;
              case '/':
                resultado = n2 != 0 ? n1 / n2 : double.nan;
                break;
            }

            dbHelper.salvarOperacao('$n1 $op $n2', resultado.toString());
            display = resultado.toString();
            expressao = '';
          }
        } catch (_) {
          display = 'Erro';
        }
      } else if (valor == 'MC') {
        memoria = '0';
      } else if (valor == 'MR') {
        display = memoria;
      } else if (valor == 'M+') {
        memoria = (double.parse(memoria) + double.parse(display)).toString();
      } else if (valor == 'M-') {
        memoria = (double.parse(memoria) - double.parse(display)).toString();
      } else {
        display = display == '0' ? valor : display + valor;
      }

      atualizarBanco();
    });
  }

  Widget botao(String txt, {Color? cor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cor ?? Colors.grey[800],
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () => pressionar(txt),
          child: Text(
            txt,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora SQLite'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoricoPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('M: $memoria',
                      style: const TextStyle(color: Colors.grey)),
                  Text(
                    display,
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                botao('MC'),
                botao('MR'),
                botao('M+'),
                botao('M-')
              ]),
              Row(children: [botao('7'), botao('8'), botao('9'), botao('/')]),
              Row(children: [botao('4'), botao('5'), botao('6'), botao('*')]),
              Row(children: [botao('1'), botao('2'), botao('3'), botao('-')]),
              Row(children: [
                botao('0'),
                botao('C', cor: Colors.red),
                botao('=', cor: Colors.green),
                botao('+')
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
