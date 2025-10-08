import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaBotao = 80.0;
const Color fundo = Color(0xFF1E164B);
const Color fundoSelecionado = Color.fromARGB(255, 45, 11, 237);

enum Sexo { masculino, feminino }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const CalculadoraIMC(),
    );
  }
}

class CalculadoraIMC extends StatefulWidget {
  const CalculadoraIMC({super.key});

  @override
  State<CalculadoraIMC> createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  double altura = 1.70; // em metros
  int peso = 65;
  double? resultadoIMC;
  String categoria = '';
  Sexo? sexoSelecionado;

  void calcularIMC() {
    setState(() {
      resultadoIMC = peso / (altura * altura);
      categoria = _classificarIMC(resultadoIMC!);
    });
  }

  String _classificarIMC(double imc) {
    if (imc < 18.5) return 'Abaixo do peso';
    if (imc < 25) return 'Peso normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidade';
  }

  void selecionarSexo(Sexo sexo) {
    setState(() {
      sexoSelecionado = sexo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IMC')),
      body: Column(
        children: [
          // Gênero
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selecionarSexo(Sexo.masculino),
                    child: Caixa(
                      cor: sexoSelecionado == Sexo.masculino
                          ? fundoSelecionado
                          : fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.male, color: Colors.white, size: 80.0),
                          SizedBox(height: 15),
                          Text(
                            'MASC',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => selecionarSexo(Sexo.feminino),
                    child: Caixa(
                      cor: sexoSelecionado == Sexo.feminino
                          ? fundoSelecionado
                          : fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.female, color: Colors.white, size: 80.0),
                          SizedBox(height: 15),
                          Text(
                            'FEM',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Altura
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Altura (m):',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    altura.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: altura,
                    min: 1.20,
                    max: 2.20,
                    divisions: 100,
                    label: altura.toStringAsFixed(2),
                    onChanged: (double novoValor) {
                      setState(() {
                        altura = novoValor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Peso e Resultado
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Peso (kg):',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '$peso',
                          style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  peso++;
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (peso > 1) peso--;
                                });
                              },
                              icon:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Resultado:',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          resultadoIMC == null
                              ? '--'
                              : resultadoIMC!.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoria,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botão Calcular
          GestureDetector(
            onTap: calcularIMC,
            child: Container(
              color: const Color(0xFF638ED6),
              width: double.infinity,
              height: alturaBotao,
              margin: const EdgeInsets.only(top: 10.0),
              alignment: Alignment.center,
              child: const Text(
                'CALCULAR IMC',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({super.key, required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
