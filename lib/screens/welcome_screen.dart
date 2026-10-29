import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/screens/login_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

/// Tela 1: boas-vindas.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: Stack(
          children: [
            // Círculos decorativos de fundo
            const Positioned(
              top: -70,
              right: -60,
              child: _Bubble(size: 220, color: Color(0x1412A9C9)),
            ),
            const Positioned(
              bottom: -90,
              left: -70,
              child: _Bubble(size: 260, color: Color(0x1412A9C9)),
            ),
            const Positioned(
              top: 180,
              left: -40,
              child: _Bubble(size: 90, color: Color(0x14FFFFFF)),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.86, end: 1),
                            duration: const Duration(milliseconds: 650),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Color(0x2612A9C9),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 112,
                                height: 112,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.science_rounded,
                                      size: 72,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        const Text(
                          'NucleAR Quiz',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Aprenda, jogando, como a tecnologia nuclear está presente na saúde, na agricultura, na indústria e na geração de energia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFCFE0F0),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.m),
                          decoration: BoxDecoration(
                            color: const Color(0x1AFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x33FFFFFF)),
                          ),
                          child: const Column(
                            children: [
                              _Feature(
                                icon: Icons.quiz_rounded,
                                title: 'Quizzes temáticos',
                                text: 'Quatro áreas para explorar',
                              ),
                              SizedBox(height: 14),
                              _Feature(
                                icon: Icons.lightbulb_rounded,
                                title: 'Aprenda com os erros',
                                text: 'Explicação em cada resposta incorreta',
                              ),
                              SizedBox(height: 14),
                              _Feature(
                                icon: Icons.emoji_events_rounded,
                                title: 'Disputa e placar',
                                text: 'Some pontos e acompanhe o ranking',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cyan,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text('Cadastrar-se'),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        const Text(
                          'Challenge FIAP 2026 · CTMSP / Amazul',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9FB8D0),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _Feature({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(color: Color(0xFFCFE0F0), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
