import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/data/mock_competitions.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/screens/leaderboard_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/quiz_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/topic_detail_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/login_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/competition_card.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';
import 'package:nuclear_quizdefinitivo/widgets/section_title.dart';

/// Área principal com navegação persistente entre Texto, Quiz, Conta e Placar.
class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  late String _displayName = AppProgress.instance.displayName.isNotEmpty
      ? AppProgress.instance.displayName
      : widget.userName;
  String _avatar = AppProgress.instance.avatar;

  @override
  void initState() {
    super.initState();
    AppProgress.instance.addListener(_syncProfile);
  }

  void _syncProfile() {
    if (!mounted) return;
    setState(() {
      if (AppProgress.instance.displayName.isNotEmpty) {
        _displayName = AppProgress.instance.displayName;
      }
      _avatar = AppProgress.instance.avatar;
    });
  }

  @override
  void dispose() {
    AppProgress.instance.removeListener(_syncProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildTextPage(),
      _buildLearnPage(),
      _buildQuizPage(),
      _buildStatsPage(),
      _buildAccountPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Início', 'Aprender', 'Quiz', 'Estatísticas', 'Perfil'][_tab],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            reverseDuration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.025, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey<int>(_tab), child: pages[_tab]),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Aprender',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt_rounded),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Estatísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildTextPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        GradientHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $_displayName!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A tecnologia nuclear está presente na medicina, na produção de alimentos, na indústria e na geração de energia. Explore os conteúdos em seu ritmo e depois pratique o que aprendeu nos desafios.',
                style: TextStyle(color: Color(0xFFCFE0F0), height: 1.4),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _StatBox(value: '${mockCompetitions.length}', label: 'temas'),
                  const SizedBox(width: 10),
                  _StatBox(
                    value:
                        '${mockCompetitions.fold<int>(0, (sum, c) => sum + c.questions.length)}',
                    label: 'perguntas',
                  ),
                  const SizedBox(width: 10),
                  const _StatBox(value: '30s', label: 'por questão'),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: AnimatedBuilder(
            animation: AppProgress.instance,
            builder: (context, _) {
              final p = AppProgress.instance;
              final dailyDone = p.questionsAnswered % 10;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: appCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.gold,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sequência: ${p.currentStreak} dia(s)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Text(
                          'Nível ${p.level}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Missão diária: responda 10 perguntas para manter seu ritmo de aprendizado.',
                      style: TextStyle(color: AppColors.muted, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: dailyDone / 10,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$dailyDone/10 perguntas nesta contagem • ${p.pointsToNextLevel} pts para o próximo nível',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AchievementChip(
                          icon: Icons.school_rounded,
                          label: 'Primeiro quiz',
                          unlocked: p.quizzesCompleted >= 1,
                        ),
                        _AchievementChip(
                          icon: Icons.star_rounded,
                          label: '100 pontos',
                          unlocked: p.totalPoints >= 100,
                        ),
                        _AchievementChip(
                          icon: Icons.local_fire_department_rounded,
                          label: '3 dias seguidos',
                          unlocked: p.currentStreak >= 3,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Explore por assunto',
                subtitle: 'Abra um tema por vez, aprenda no seu ritmo e depois teste seus conhecimentos.',
              ),
              const SizedBox(height: 12),
              for (final competition in mockCompetitions)
                _TopicPreviewCard(
                  competition: competition,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TopicDetailScreen(competition: competition),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cyanBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_rounded, color: AppColors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Dica: depois de estudar, abra a aba Quiz. Se errar uma questão, o app mostrará uma explicação para ajudar você a aprender.',
                        style: TextStyle(height: 1.4, color: AppColors.text),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _tab = 2),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Explorar os quizzes'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLearnPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.m),
      children: [
        const SectionTitle(
          title: 'Aprenda por assunto',
          subtitle: 'Leia a explicação, descubra curiosidades e depois comece o quiz do tema.',
        ),
        const SizedBox(height: 14),
        for (final competition in mockCompetitions)
          _TopicPreviewCard(
            competition: competition,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TopicDetailScreen(competition: competition),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuizPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.m),
      children: [
        const SectionTitle(
          title: 'Escolha seu desafio',
          subtitle: 'Todas as competições estão liberadas para jogar',
        ),
        const SizedBox(height: 14),
        for (final competition in mockCompetitions)
          AnimatedBuilder(
            animation: AppProgress.instance,
            builder: (context, _) => CompetitionCard(
              competition: competition,
              lastScore: AppProgress.instance.topicLastScore[competition.id],
              bestScore: AppProgress.instance.topicBestScore[competition.id],
              onParticipate: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(competition: competition),
                ),
              ),
              onLeaderboard: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LeaderboardScreen(competition: competition),
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LeaderboardScreen(competition: mockCompetitions.first),
            ),
          ),
          icon: const Icon(Icons.leaderboard_rounded),
          label: const Text('Abrir ranking'),
        ),
      ],
    );
  }

  Widget _buildStatsPage() {
    return AnimatedBuilder(
      animation: AppProgress.instance,
      builder: (context, _) {
        final progress = AppProgress.instance;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: AppColors.cyan,
                    size: 34,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Seu progresso em números',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Cada tentativa ajuda você a aprender um pouco mais.',
                    style: TextStyle(color: Color(0xFFD8E7F5), height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _StatBox(
                        value: '${progress.totalPoints}',
                        label: 'pontos',
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        value: '${progress.quizzesCompleted}',
                        label: 'quizzes',
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        value: '${(progress.accuracy * 100).round()}%',
                        label: 'acertos',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: appCardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.replay_circle_filled_rounded,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Revisar questões erradas (${progress.reviewItems.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pratique novamente as perguntas que você errou e releia as explicações.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: progress.reviewItems.isEmpty
                        ? null
                        : _openReview,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('Abrir revisão'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SectionTitle(
              title: 'Desempenho por assunto',
              subtitle: 'Veja onde você já praticou e o que pode revisar.',
            ),
            const SizedBox(height: 12),
            for (final topic in mockCompetitions) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: appCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(topic.icon, color: topic.color),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            topic.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Text(
                          '${AppProgress.instance.topicCorrect[topic.id] ?? 0}/${AppProgress.instance.topicAttempts[topic.id] ?? 0}',
                          style: TextStyle(
                            color: topic.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value:
                            (AppProgress.instance.topicAttempts[topic.id] ??
                                    0) ==
                                0
                            ? 0
                            : (AppProgress.instance.topicCorrect[topic.id] ??
                                      0) /
                                  (AppProgress.instance.topicAttempts[topic
                                          .id] ??
                                      1),
                        minHeight: 8,
                        backgroundColor: tintOf(topic.color),
                        color: topic.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (progress.quizzesCompleted == 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cyanBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Suas estatísticas aparecerão aqui depois que você concluir seu primeiro quiz.',
                  style: TextStyle(color: AppColors.text, height: 1.4),
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => setState(() => _tab = 4),
              icon: const Icon(Icons.person_outline),
              label: const Text('Personalizar meu perfil'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: appCardDecoration(),
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cyanBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyan.withAlpha(80),
                    width: 3,
                  ),
                ),
                child: Text(_avatar, style: const TextStyle(fontSize: 42)),
              ),
              const SizedBox(height: 12),
              Text(
                _displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Explorador(a) NucleAR',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ProfileMetric(
                      value: '${AppProgress.instance.totalPoints}',
                      label: 'Pontos',
                      icon: Icons.stars_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileMetric(
                      value: '${AppProgress.instance.quizzesCompleted}',
                      label: 'Quizzes',
                      icon: Icons.quiz_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileMetric(
                      value:
                          '${(AppProgress.instance.accuracy * 100).round()}%',
                      label: 'Acertos',
                      icon: Icons.track_changes_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personalização',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _editDisplayName,
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Alterar nome'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _chooseAvatar,
                icon: const Icon(Icons.face_retouching_natural_rounded),
                label: const Text('Escolher avatar'),
              ),
              const SizedBox(height: 14),
              const ListTile(
                leading: Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.gold,
                ),
                title: Text('Próxima conquista'),
                subtitle: Text(
                  'Complete mais quizzes para aumentar sua pontuação.',
                ),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => setState(() => _tab = 3),
                icon: const Icon(Icons.insights_rounded),
                label: const Text('Ver minhas estatísticas'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Entrar com outra conta'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Cadastrar nova conta'),
              ),
              const SizedBox(height: 6),
              const Text(
                'Nome, avatar e progresso são salvos localmente neste dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editDisplayName() async {
    final controller = TextEditingController(text: _displayName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como quer ser chamado(a)?'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          decoration: const InputDecoration(
            labelText: 'Nome de exibição',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      AppProgress.instance.updateProfile(name: result);
      setState(() => _displayName = result);
    }
  }

  Future<void> _chooseAvatar() async {
    const avatars = ['🚀', '⚛️', '🧪', '🛰️', '🌎', '🔬', '☢️', '💡'];
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final avatar in avatars)
              InkWell(
                onTap: () => Navigator.pop(context, avatar),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.cyanBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(avatar, style: const TextStyle(fontSize: 30)),
                ),
              ),
          ],
        ),
      ),
    );
    if (result != null && mounted) {
      AppProgress.instance.updateProfile(avatarValue: result);
      setState(() => _avatar = result);
    }
  }

  void _openReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Revisão de questões')),
          body: AnimatedBuilder(
            animation: AppProgress.instance,
            builder: (context, _) {
              final items = List<Map<String, dynamic>>.from(
                AppProgress.instance.reviewItems,
              );
              if (items.isEmpty) {
                return const Center(
                  child: Text('Tudo revisado! Nenhuma questão pendente.'),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Leia a pergunta, confira a resposta correta e marque quando já tiver revisado.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  for (final item in items)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['text']?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Resposta correta: ${(item['options'] as List)[item['correctIndex'] as int]}',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(item['explanation']?.toString() ?? ''),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () =>
                                    AppProgress.instance.removeReviewItem(item),
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Marcar como revisada'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool unlocked;
  const _AchievementChip({
    required this.icon,
    required this.label,
    required this.unlocked,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: unlocked ? AppColors.cyanBg : AppColors.background,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: unlocked
            ? AppColors.cyan.withAlpha(100)
            : AppColors.muted.withAlpha(50),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: unlocked ? AppColors.blue : AppColors.muted,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: unlocked ? AppColors.blue : AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (unlocked)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.check_circle, size: 13, color: AppColors.success),
          ),
      ],
    ),
  );
}

class _ProfileMetric extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _ProfileMetric({
    required this.value,
    required this.label,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: AppColors.cyan, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x26FFFFFF)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFCFE0F0)),
          ),
        ],
      ),
    ),
  );
}

class _TopicPreviewCard extends StatelessWidget {
  final Competition competition;
  final VoidCallback onTap;
  const _TopicPreviewCard({required this.competition, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: appCardDecoration(),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: tintOf(competition.color),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  competition.icon,
                  color: competition.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      competition.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${competition.questions.length} perguntas · Introdução e curiosidade',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: competition.color,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
