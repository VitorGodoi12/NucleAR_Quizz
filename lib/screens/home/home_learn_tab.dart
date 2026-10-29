part of '../home_screen.dart';

mixin _HomeLearnTab on _HomeScreenStateBase {
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
        for (final competition in _competitions)
          _TopicPreviewCard(
            competition: competition,
            onTap: () => Navigator.pushNamed(context, AppRoutes.topic, arguments: competition),
          ),
      ],
    );
  }

}
