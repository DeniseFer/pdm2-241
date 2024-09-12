import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importa o pacote de máscaras
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validação de Formulário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormValidationScreen(),
    );
  }
}

class FormValidationScreen extends StatefulWidget {
  const FormValidationScreen({Key? key}) : super(key: key);

  @override
  _FormValidationScreenState createState() => _FormValidationScreenState();
}

class _FormValidationScreenState extends State<FormValidationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _valueController = TextEditingController();

  final dateMask = MaskTextInputFormatter(mask: '##-##-####', filter: { '#': RegExp(r'[0-9]') });
  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: { '#': RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validação de Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para Data
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Data (dd-mm-aaaa)'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [dateMask],
                validator: validateDate,
              ),
              // Campo para Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              // Campo para CPF
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                inputFormatters: [cpfMask],
                validator: validateCPF,
              ),
              // Campo para Valor
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: validateValue,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formulário válido!')),
                    );
                  }
                },
                child: const Text('Validar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Validação da Data
String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe uma data';
  }
  try {
    DateFormat("dd-MM-yyyy").parseStrict(value);
  } catch (e) {
    return 'Data inválida. Use o formato dd-MM-aaaa';
  }
  return null;
}

// Validação de Email
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe um email';
  }
  const pattern = r'^[^@]+@[^@]+\.[^@]+';
  final regExp = RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return 'Email inválido';
  }
  return null;
}

// Validação de CPF
String? validateCPF(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe um CPF';
  }
  // Remove a máscara para validação
  String cleanedCPF = value.replaceAll(RegExp(r'[^\d]'), '');
  if (cleanedCPF.length != 11 || !isValidCPF(cleanedCPF)) {
    return 'CPF inválido';
  }
  return null;
}

// Função auxiliar para validar o CPF
bool isValidCPF(String cpf) {
  int sum = 0;
  int remainder;

  for (int i = 1; i <= 9; i++) {
    sum += int.parse(cpf[i - 1]) * (11 - i);
  }
  remainder = (sum * 10) % 11;
  if (remainder == 10 || remainder == 11) remainder = 0;
  if (remainder != int.parse(cpf[9])) return false;

  sum = 0;
  for (int i = 1; i <= 10; i++) {
    sum += int.parse(cpf[i - 1]) * (12 - i);
  }
  remainder = (sum * 10) % 11;
  if (remainder == 10 || remainder == 11) remainder = 0;
  return remainder == int.parse(cpf[10]);
}

// Validação de Valor
String? validateValue(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe um valor';
  }
  final number = double.tryParse(value);
  if (number == null || number <= 0) {
    return 'Valor inválido';
  }
  return null;
}
