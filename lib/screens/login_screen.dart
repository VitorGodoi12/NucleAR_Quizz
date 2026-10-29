import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/screens/home_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/utils/validators.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';

/// Tela 2a: login (simulado, sem servidor).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Revise os campos destacados em vermelho.')),
      );
      return;
    }
    final name = Validators.nameFromEmail(_emailController.text);
    await context.read<AppProgress>().updateProfile(name: name);
    if (!mounted) return;
    // Home vira a primeira rota: o botão "voltar" não retorna ao login.
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    messenger.showSnackBar(
      SnackBar(content: Text('Login realizado! Bem-vindo(a), $name.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GradientHeader(
              child: Column(
                children: [
                  Icon(Icons.lock_open_rounded, size: 52, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Entre para continuar aprendendo.',
                    style: TextStyle(color: Color(0xFFCFE0F0)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: appCardDecoration(context: context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: appInput(context, 'E-mail', Icons.email_outlined),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: appInput(context, 'Senha',
                          Icons.lock_outline_rounded,
                          suffix: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Login simulado: nenhuma conta é verificada em servidor.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.register);
              },
              child: const Text('Ainda não tem conta? Cadastre-se'),
            ),
            const SizedBox(height: AppSpacing.m),
          ],
        ),
      ),
    );
  }
}
