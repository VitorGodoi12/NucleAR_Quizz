import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/utils/validators.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';

/// Tela 3: cadastro com validação (envio simulado).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // validate() roda todos os validators; se algum falhar, retorna false.
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revise os campos destacados em vermelho.'),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle_rounded,
          color: semanticStatusColor(context, success: true),
          size: 48,
        ),
        title: Text('Cadastro realizado!'),
        content: Text(
          'Olá, $name! Esta é uma conta demonstrativa: não há autenticação em servidor. Seu nome e progresso ficam salvos somente neste dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Continuar'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    await context.read<AppProgress>().updateProfile(name: name);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar conta')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GradientHeader(
              child: Column(
                children: [
                  Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Crie sua conta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Preencha os dados para participar das competições.',
                    textAlign: TextAlign.center,
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
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: appInput(
                          context,
                          'Nome',
                          Icons.person_outline_rounded,
                        ),
                        validator: Validators.name,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: appInput(
                          context,
                          'E-mail',
                          Icons.email_outlined,
                        ),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: appInput(
                          context,
                          'Senha',
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
                      const SizedBox(height: AppSpacing.m),
                      TextFormField(
                        controller: _confirmController,
                        obscureText: _hidePassword,
                        decoration: appInput(
                          context,
                          'Confirmar senha',
                          Icons.lock_reset_rounded,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Confirme a senha.';
                          }
                          if (v != _passwordController.text) {
                            return 'As senhas não coincidem.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.l),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text('Criar conta'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Text('Já tenho conta. Entrar'),
            ),
            const SizedBox(height: AppSpacing.m),
          ],
        ),
      ),
    );
  }
}
