import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/produto_model.dart';
import '../models/usuario_model.dart';
import '../models/notificacoes_model.dart';

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
      version: 3, // Incremented from 2 to 3 for turma column
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        cargaHoraria TEXT,
        turma TEXT  // Added turma column
      )
    ''');

    await db.execute('''
      CREATE TABLE notificacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitante_nome TEXT NOT NULL,
        solicitante_cargo TEXT NOT NULL,
        produto_nome TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        data_solicitacao TEXT NOT NULL,
        lida INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notificacoes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          solicitante_nome TEXT NOT NULL,
          solicitante_cargo TEXT NOT NULL,
          produto_nome TEXT NOT NULL,
          quantidade INTEGER NOT NULL,
          data_solicitacao TEXT NOT NULL,
          lida INTEGER DEFAULT 0
        )
      ''');
    }

    if (oldVersion < 3) {
      // Add turma column to usuarios table
      await db.execute('ALTER TABLE usuarios ADD COLUMN turma TEXT');

      await db.execute(
          'ALTER TABLE notificacoes ADD COLUMN solicitante_turma TEXT');
    }
  }

  // ... [rest of your existing methods remain unchanged]
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

  Future<int> insertNotificacao(Notificacao notificacao) async {
    final db = await database;
    return await db.insert('notificacoes', notificacao.toMap());
  }

  Future<List<Notificacao>> fetchAllNotificacoes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notificacoes',
      orderBy: 'data_solicitacao DESC',
    );
    return maps.map((map) => Notificacao.fromMap(map)).toList();
  }

  Future<int> markNotificacaoAsRead(int id) async {
    final db = await database;
    return await db.update(
      'notificacoes',
      {'lida': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadNotificacoesCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notificacoes WHERE lida = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
