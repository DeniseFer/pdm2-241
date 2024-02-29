// Agregação e Composição
import 'dart:convert';

// TRABALHO FEITO EM DUPLA
// DUPLA: ABNER SOARES JERONIMO E DENISE FERREIRA DE ABREU
class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson(){
    return{
      'nome':_nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson(){
    return{
      'nome':_nome,
      'dependentes': _dependentes.map((dependente) => dependente.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
  Map<String, dynamic> toJson(){
    return{
      'nomeProjeto':_nomeProjeto,
      'dependentes': _funcionarios.map((funcionario) => funcionario.toJson()).toList(),
    };
}
}

void main() {

 // 1. Criar varios objetos Dependentes 

 Dependente dependente1 = Dependente("Carlos");
 Dependente dependente2 = Dependente("Caio");
 Dependente dependente3 = Dependente("Camila");
 Dependente dependente4 = Dependente("Cintia");
 
  // 2. Criar varios objetos Funcionario
    // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
Funcionario funcionario1 = Funcionario("Elfo", [dependente1]);
Funcionario funcionario2 = Funcionario("Carla", [dependente2]);
Funcionario funcionario3 = Funcionario("Eduarda", [dependente3]);
Funcionario funcionario4 = Funcionario("Alejandro", [dependente4]);

  // 4. Criar uma lista de Funcionarios

List<Funcionario> listaFuncionarios = [funcionario1, funcionario2, funcionario3, funcionario4];

  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario

  EquipeProjeto equipeDoProjeto = EquipeProjeto("ProjetoDartTaveira", listaFuncionarios);



  // 6. Printar no formato JSON o objeto Equipe Projeto.
  
  print(jsonEncode(equipeDoProjeto.toJson()));
  }