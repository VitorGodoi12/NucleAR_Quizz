import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

/// Conteúdo introdutório sobre aplicações da tecnologia nuclear.
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conheça a tecnologia nuclear')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _TopicHero(),
          SizedBox(height: 20),
          _TopicCard(
            icon: Icons.medical_services_rounded,
            title: 'Saúde e medicina',
            color: AppColors.blue,
            text: 'Radioisótopos ajudam a produzir imagens para diagnóstico, enquanto a radioterapia utiliza radiação controlada no tratamento de alguns tipos de câncer. A radiação também pode esterilizar materiais médicos.',
          ),
          _TopicCard(
            icon: Icons.agriculture_rounded,
            title: 'Agricultura e alimentos',
            color: AppColors.cyan,
            text: 'Técnicas nucleares auxiliam pesquisas sobre solo e água, ajudam no controle de pragas e podem ser usadas para reduzir microrganismos e prolongar a conservação de certos alimentos.',
          ),
          _TopicCard(
            icon: Icons.factory_rounded,
            title: 'Indústria',
            color: AppColors.blue,
            text: 'A radiação pode inspecionar soldas e peças sem danificá-las, medir espessuras e verificar processos industriais, contribuindo para a qualidade e a segurança.',
          ),
          _TopicCard(
            icon: Icons.bolt_rounded,
            title: 'Energia',
            color: AppColors.navy,
            text: 'Em uma usina nuclear, a energia liberada na fissão aquece água. O vapor movimenta turbinas ligadas a geradores elétricos. A operação exige sistemas rigorosos de segurança e gestão responsável dos resíduos.',
          ),
          SizedBox(height: 12),
          Text(
            'Aprenda um tema por vez e depois teste seus conhecimentos no quiz.',
            style: TextStyle(color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _TopicHero extends StatelessWidget {
  const _TopicHero();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [AppColors.navy, AppColors.blue]),
      borderRadius: BorderRadius.circular(22),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.science_rounded, color: Colors.white, size: 38),
        SizedBox(height: 12),
        Text(
          'A tecnologia nuclear está no nosso dia a dia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Entenda aplicações, benefícios e a importância do uso responsável.',
          style: TextStyle(color: Color(0xFFD6E8F6), height: 1.45),
        ),
      ],
    ),
  );
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;
  const _TopicCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  text,
                  style: const TextStyle(color: AppColors.text, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
