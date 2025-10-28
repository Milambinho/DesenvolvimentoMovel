import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _db;
  DBHelper._internal();

  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'calculadora.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero_atual TEXT,
        memoria TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE operacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expressao TEXT,
        resultado TEXT,
        data TEXT
      )
    ''');

    await db.insert('dados', {'numero_atual': '0', 'memoria': '0'});
  }

  // ======== DADOS =========
  Future<Map<String, dynamic>> getDados() async {
    final banco = await db;
    final result = await banco.query('dados', limit: 1);
    return result.first;
  }

  Future<void> updateDados(String numero, String memoria) async {
    final banco = await db;
    await banco.update('dados', {
      'numero_atual': numero,
      'memoria': memoria,
    });
  }

  // ======== OPERAÇÕES =========
  Future<void> salvarOperacao(String expr, String resultado) async {
    final banco = await db;
    await banco.insert('operacoes', {
      'expressao': expr,
      'resultado': resultado,
      'data': DateTime.now().toIso8601String()
    });
  }

  Future<List<Map<String, dynamic>>> listarOperacoes() async {
    final banco = await db;
    return await banco.query('operacoes', orderBy: 'id DESC');
  }

  Future<void> limparOperacoes() async {
    final banco = await db;
    await banco.delete('operacoes');
  }
}
