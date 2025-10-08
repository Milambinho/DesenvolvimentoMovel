import 'package:flutter/material.dart';

void main() {
  runApp(const PetIdadeApp());
}

enum Pet { cachorro, gato }

const Color fundo = Color(0xFF1E164B);
const Color selecionada = Color.fromARGB(255, 45, 11, 237);
const double alturaBotao = 80.0;

class PetIdadeApp extends StatelessWidget {
  const PetIdadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TelaPet(),
    );
  }
}

class TelaPet extends StatefulWidget {
  const TelaPet({super.key});

  @override
  State<TelaPet> createState() => _TelaPetState();
}

class _TelaPetState extends State<TelaPet> {
  Pet? petSelecionado;
  int idadeReal = 1;
  double peso = 5.0; // em kg
  double idadeFisiologica = 0.0;

  void selecionarPet(Pet pet) {
    setState(() {
      petSelecionado = pet;
    });
  }

  void calcularIdadeFisiologica() {
    double result = 0.0;
    if (petSelecionado == null) {
      result = 0.0;
    } else if (petSelecionado == Pet.cachorro) {
      if (idadeReal <= 0) {
        result = 0.0;
      } else if (idadeReal == 1) {
        result = 15;
      } else {
        // Fórmula exemplo: primeiro ano = 15, depois 5 + ajuste por peso
        double ajuste = peso / 10.0; // exemplo: +0.5 anos por cada 10 kg
        double fator = 5 + ajuste;
        result = 15 + (idadeReal - 1) * fator;
      }
    } else if (petSelecionado == Pet.gato) {
      if (idadeReal <= 0) {
        result = 0.0;
      } else if (idadeReal == 1) {
        result = 15;
      } else {
        // Fórmula exemplo para gato: cada ano após o primeiro = 4 anos humanos
        result = 15 + (idadeReal - 1) * 4;
      }
    }

    setState(() {
      idadeFisiologica = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idade Fisiológica Pet'),
      ),
      body: Column(
        children: [
          // Seleção: Cachorro / Gato
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selecionarPet(Pet.cachorro),
                    child: Caixa(
                      cor: petSelecionado == Pet.cachorro ? selecionada : fundo,
                      filho: const Center(
                        child: Text(
                          'CACHORRO',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => selecionarPet(Pet.gato),
                    child: Caixa(
                      cor: petSelecionado == Pet.gato ? selecionada : fundo,
                      filho: const Center(
                        child: Text(
                          'GATO',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Peso Slider
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Peso (kg):',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    peso.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Slider(
                    value: peso,
                    min: 1.0,
                    max: 100.0,
                    divisions: 990,
                    label: peso.toStringAsFixed(1),
                    onChanged: (double novo) {
                      setState(() {
                        peso = novo;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Idade real + botões + resultado
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Idade real (anos):',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$idadeReal',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (idadeReal > 0) {
                            setState(() {
                              idadeReal--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            idadeReal++;
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Idade fisiológica:',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    idadeFisiologica > 0
                        ? idadeFisiologica.toStringAsFixed(1)
                        : '--',
                    style: const TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Botão calcular
          GestureDetector(
            onTap: calcularIdadeFisiologica,
            child: Container(
              width: double.infinity,
              height: alturaBotao,
              margin: const EdgeInsets.only(top: 10),
              color: const Color(0xFF638ED6),
              alignment: Alignment.center,
              child: const Text(
                'CALCULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: cor),
      child: filho,
    );
  }
}
