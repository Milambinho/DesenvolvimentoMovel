import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QuizApp());
}

class Pergunta {
  final String texto;
  final String resposta;

  Pergunta({required this.texto, required this.resposta});
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int numeroPergunta = 0;
  List<Widget> resultado = [];
  final TextEditingController respostaCtrl = TextEditingController();
  String feedback = "";

  final List<Pergunta> perguntas = [
    Pergunta(texto: "Qual é a capital do Canadá?", resposta: "Ottawa"),
    Pergunta(texto: "Quem pintou a Mona Lisa?", resposta: "Leonardo da Vinci"),
    Pergunta(
        texto: "Qual é o maior oceano do planeta?",
        resposta: "Oceano Pacífico"),
    Pergunta(texto: "O Sol é uma estrela?", resposta: "Sim"),
    Pergunta(texto: "Quem escreveu 'A Ilíada'?", resposta: "Homero"),
    Pergunta(texto: "Quantos estados tem o Brasil?", resposta: "26"),
    Pergunta(
        texto: "Qual o metal usado em cabos elétricos?", resposta: "Cobre"),
    Pergunta(texto: "A água ferve a 90°C no nível do mar?", resposta: "Não"),
    Pergunta(texto: "O corpo humano tem 206 ossos?", resposta: "Sim"),
    Pergunta(texto: "O Egito fica na América?", resposta: "Não"),
  ];

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  Future<void> _carregarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      numeroPergunta = prefs.getInt("numeroPergunta") ?? 0;
    });
  }

  Future<void> _salvarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("numeroPergunta", numeroPergunta);
  }

  void responder() {
    String respostaUsuario = respostaCtrl.text.trim();
    String respostaCerta = perguntas[numeroPergunta].resposta;

    setState(() {
      if (respostaUsuario.toLowerCase() == respostaCerta.toLowerCase()) {
        resultado.add(const Icon(Icons.check, color: Colors.green));
        feedback = "✅ Correto!";
      } else {
        resultado.add(const Icon(Icons.close, color: Colors.red));
        feedback = "❌ Errado! Resposta: $respostaCerta";
      }

      if (numeroPergunta < perguntas.length - 1) {
        numeroPergunta++;
        _salvarEstado();
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Fim do Quiz"),
            content: Text("Você completou ${perguntas.length} perguntas!"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    numeroPergunta = 0;
                    resultado.clear();
                    feedback = "";
                  });
                  _salvarEstado();
                  Navigator.pop(context);
                },
                child: const Text("Reiniciar"),
              )
            ],
          ),
        );
      }
    });

    respostaCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    perguntas[numeroPergunta].texto,
                    style: const TextStyle(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TextField(
                controller: respostaCtrl,
                decoration: const InputDecoration(
                  labelText: "Digite sua resposta",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: responder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Responder"),
              ),
              const SizedBox(height: 16),
              Text(
                feedback,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(children: resultado),
            ],
          ),
        ),
      ),
    );
  }
}
