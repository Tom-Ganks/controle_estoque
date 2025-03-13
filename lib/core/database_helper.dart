import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/produto_model.dart';
import '../models/usuario_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'controle_estoque.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produtos (
        idProdutos INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        medida INTEGER NOT NULL,
        local TEXT,
        entrada INTEGER NOT NULL,
        saida INTEGER NOT NULL,
        saldo INTEGER NOT NULL,
        codigo TEXT,
        dataEntrada TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL,
        telefone TEXT NOT NULL,
        endereco TEXT NOT NULL,
        cargo TEXT NOT NULL,
        senha TEXT NOT NULL,
        foto TEXT,
        status TEXT NOT NULL,
        setor TEXT, 
        cpf TEXT, 
        rg TEXT, 
        dataNascimento TEXT, 
        cargaHoraria TEXT
      )
    ''');
  }

  // Métodos para Produtos
  Future<int> insertProduto(Produto produto) async {
    final db = await database;
    return await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> fetchAllProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return maps.map((map) => Produto.fromMap(map)).toList();
  }

  Future<int> updateProduto(Produto produto) async {
    final db = await database;
    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'idProdutos = ?',
      whereArgs: [produto.idProdutos],
    );
  }

  Future<int> deleteProduto(int id) async {
    final db = await database;
    return await db
        .delete('produtos', where: 'idProdutos = ?', whereArgs: [id]);
  }

  // Métodos para Usuários
  Future<int> insertUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> fetchAllUsuarios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');
    return maps.map((map) => Usuario.fromMap(map)).toList();
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await database;
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deleteUsuario(int id) async {
    final db = await database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
