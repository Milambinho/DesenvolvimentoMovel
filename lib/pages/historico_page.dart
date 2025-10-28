import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> historico = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final lista = await dbHelper.listarOperacoes();
    setState(() => historico = lista);
  }

  void limpar() async {
    await dbHelper.limparOperacoes();
    carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Operações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: limpar,
          )
        ],
      ),
      body: historico.isEmpty
          ? const Center(child: Text('Nenhuma operação registrada.'))
          : ListView.builder(
              itemCount: historico.length,
              itemBuilder: (context, i) {
                final op = historico[i];
                return ListTile(
                  title: Text(op['expressao']),
                  subtitle: Text('= ${op['resultado']}'),
                  trailing: Text(
                    DateTime.parse(op['data'])
                        .toLocal()
                        .toString()
                        .substring(0, 19),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}
