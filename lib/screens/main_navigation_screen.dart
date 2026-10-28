import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/data/mock_competitions.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/screens/leaderboard_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/quiz_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/topic_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/competition_card.dart';

/// Navegação principal após entrar/cadastrar: conteúdo, quiz, conta e placar.
class MainNavigationScreen extends StatefulWidget {
  final String userName;
  const MainNavigationScreen({super.key, required this.userName});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const TopicScreen(),
      _QuizHub(
        onChoose: (competition) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(competition: competition),
          ),
        ),
      ),
      _AccountPage(
        userName: widget.userName,
        onLogout: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (_) => false,
        ),
      ),
      LeaderboardScreen(competition: mockCompetitions.first),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Texto',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Login',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Placar',
          ),
        ],
      ),
    );
  }
}

class _QuizHub extends StatelessWidget {
  final ValueChanged<Competition> onChoose;
  const _QuizHub({required this.onChoose});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Escolha seu quiz')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Cada pergunta tem 30 segundos. Se errar, você verá uma explicação para aprender com a resposta.',
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          ),
        ),
        const SizedBox(height: 18),
        for (final competition in mockCompetitions)
          CompetitionCard(
            competition: competition,
            onParticipate: () => onChoose(competition),
            onLeaderboard: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LeaderboardScreen(competition: competition),
              ),
            ),
          ),
      ],
    ),
  );
}

class _AccountPage extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  const _AccountPage({required this.userName, required this.onLogout});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sua conta')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.cyan,
              child: Icon(Icons.person, size: 42, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Olá, $userName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sua conta está em modo demonstrativo. Os dados não são enviados a um servidor.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
            ),
          ],
        ),
      ),
    ),
  );
}
