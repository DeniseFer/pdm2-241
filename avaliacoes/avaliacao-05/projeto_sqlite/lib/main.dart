import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Criar um banco de dados SQLite
  final databasePath = await getDatabasesPath();
  final databaseName = 'alunos.db';
  final databaseFile = join(databasePath, databaseName);

  // Criar a tabela TB_ALUNO
  final database = await openDatabase(databaseFile, version: 1,
      onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE TB_ALUNO (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT(50) NOT NULL
      )
    ''');
  });

  // Função para inserir dados na tabela TB_ALUNO
  Future<void> insertAluno(String nome) async {
    await database.insert('TB_ALUNO', {'nome': nome});
  }

  // Função para ler dados da tabela TB_ALUNO
  Future<List<Map<String, dynamic>>> readAlunos() async {
    return await database.query('TB_ALUNO');
  }

  // Receber dados do teclado para gravar na tabela TB_ALUNO
  print('Digite o nome do aluno:');
  final nome = stdin.readLineSync() ?? '';

  await insertAluno(nome);

  // Ler dados da tabela TB_ALUNO e apresentar na tela
  final alunos = await readAlunos();
  print('Alunos:');
  for (final aluno in alunos) {
    print('ID: ${aluno['id']}, Nome: ${aluno['nome']}');
  }
}
