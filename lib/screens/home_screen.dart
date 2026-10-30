// ignore_for_file: unused_element

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/data/competition_catalog.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/competition_card.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';
import 'package:nuclear_quizdefinitivo/widgets/section_title.dart';

part 'home/home_dashboard_tab.dart';
part 'home/home_learn_tab.dart';
part 'home/home_quiz_tab.dart';
part 'home/home_stats_tab.dart';
part 'home/home_profile_tab.dart';
part 'home/home_actions.dart';

int _randomIndex(int max) => math.Random().nextInt(max);

/// Área principal com navegação inferior: Início, Aprender, Quiz, Estatísticas e Perfil.
class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

abstract interface class _HomeHost {
  int get _tab;
  set _tab(int value);
  String get _displayName;
  set _displayName(String value);
  String get _avatar;
  set _avatar(String value);
  AppProgress get _progress;
  List<Competition> get _competitions;
  void _openRandomQuiz();
  void _openGeneralLeaderboard();
  void _openReview();
}

abstract class _HomeScreenStateBase extends State<HomeScreen>
    implements _HomeHost {
  int _tab = 0;
  late String _displayName;
  late String _avatar;
  AppProgress get _progress => context.read<AppProgress>();
  List<Competition> get _competitions =>
      context.read<CompetitionCatalog>().competitions;
}

class _HomeScreenState extends _HomeScreenStateBase
    with
        _HomeDashboardTab,
        _HomeLearnTab,
        _HomeQuizTab,
        _HomeStatsTab,
        _HomeProfileTab,
        _HomeActions {
  @override
  void initState() {
    super.initState();
    _displayName = widget.userName;
    _avatar = _progress.avatar;
    _progress.addListener(_syncProfile);
  }

  void _syncProfile() {
    if (!mounted) return;
    setState(() {
      if (_progress.displayName.isNotEmpty) {
        _displayName = _progress.displayName;
      }
      _avatar = _progress.avatar;
    });
  }

  @override
  void dispose() {
    _progress.removeListener(_syncProfile);
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
            onPressed: () async {
              await _progress.updateProfile(name: '');
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.welcome,
                  (_) => false,
                );
              }
            },
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
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final tone = enabled
        ? accentOnSurface(context, color)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      decoration: appCardDecoration(context: context),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tintOf(context, tone),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: tone, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: enabled
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
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
      color: unlocked
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: unlocked
            ? AppColors.cyan.withAlpha(100)
            : Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: unlocked
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: unlocked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (unlocked)
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(
              Icons.check_circle,
              size: 13,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF72D99A)
                  : AppColors.success,
            ),
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
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFFCFE0F0))),
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
    decoration: appCardDecoration(context: context),
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
                  color: tintOf(context, competition.color),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  competition.icon,
                  color: accentOnSurface(context, competition.color),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${competition.questions.length} perguntas · Introdução e curiosidade',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: accentOnSurface(context, competition.color),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
