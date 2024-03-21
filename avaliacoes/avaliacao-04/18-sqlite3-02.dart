import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Aluno {
  int? id;
  String nome;
  String dataNascimento;

  Aluno({this.id, required this.nome, required this.dataNascimento});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento,
    };
  }


  @override
  String toString() {
    return 'Aluno{id: $id, nome: $nome, dataNascimento: $dataNascimento}';
  }
}

class AlunoDatabase {
  static final AlunoDatabase instance = AlunoDatabase._init();
  static Database? _database;

  AlunoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('aluno.db');
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS TB_ALUNOS (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  data_nascimento TEXT NOT NULL
)

    ''');
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );

    await _createDB(database, 1);
    return database;
  }

  Future<int> insertAluno(Aluno aluno) async {
    final db = await database;
    return await db.insert('TB_ALUNOS', aluno.toMap());
  }

  Future<Aluno?> getAluno(int id) async {
  final db = await database;
  final maps = await db.query(
    'TB_ALUNOS',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) return null;

   return Aluno(
    id: maps.first['id'] as int?,
    nome: maps.first['nome'] as String,
    dataNascimento: maps.first['data_nascimento'] as String,
  );
}

  Future<List<Aluno>> getAllAlunos() async {
    final db = await database;
    final maps = await db.query('TB_ALUNOS');

    return List.generate(maps.length, (i) {
    return Aluno(
      id: maps[i]['id'] as int?,
      nome: maps[i]['nome'] as String,
      dataNascimento: maps[i]['data_nascimento'] as String,
    );
  });
}

  Future<int> updateAluno(Aluno aluno) async {
    final db = await database;
    return await db.update(
      'TB_ALUNOS',
      aluno.toMap(),
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  Future<int> deleteAluno(int id) async {
    final db = await database;
    return await db.delete(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

void main() async {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;


   final db = AlunoDatabase.instance;

  // Inserir um aluno
  final aluno = Aluno(nome: 'João', dataNascimento: '2000-01-01');

  final aluna1 = Aluno(nome: 'Camila Brauna Tavares', dataNascimento: '2006-06-21');
  final aluna2 = Aluno(nome: 'Denise Ferreira de Abreu', dataNascimento: '2006-08-26');

  int alunoId = await db.insertAluno(aluno);
  int aluna1Id = await db.insertAluno(aluna1);
  int aluna2Id = await db.insertAluno(aluna2);

  // Buscar um aluno pelo ID
  Aluno? retrievedAluno = await db.getAluno(alunoId);
  if (retrievedAluno == null) {
    print('Aluno não encontrado');
    return;
  }

  print('Aluno recuperado: $retrievedAluno');

  // Atualizar os dados de um aluno
  retrievedAluno.nome = 'João da Silva';
  await db.updateAluno(retrievedAluno);

  // Buscar todos os alunos
  List<Aluno> alunos = await db.getAllAlunos();
  print('Todos os alunos: $alunos');

  // Deletar um aluno
  await db.deleteAluno(alunoId);

  print('\n Dupla: Denise Ferreira de Abreu e Camila Brauna Tavares');
}
