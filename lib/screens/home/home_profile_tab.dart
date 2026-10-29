part of '../home_screen.dart';

mixin _HomeProfileTab on _HomeScreenStateBase {
  Widget _buildAccountPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: appCardDecoration(context: context),
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyan.withAlpha(80),
                    width: 3,
                  ),
                ),
                child: Text(_avatar, style: TextStyle(fontSize: 42)),
              ),
              const SizedBox(height: 12),
              Text(
                _displayName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explorador(a) NucleAR',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ProfileMetric(
                      value: '${_progress.totalPoints}',
                      label: 'Pontos',
                      icon: Icons.stars_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileMetric(
                      value: '${_progress.quizzesCompleted}',
                      label: 'Quizzes',
                      icon: Icons.quiz_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileMetric(
                      value:
                          '${(_progress.accuracy * 100).round()}%',
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _editDisplayName,
                icon: const Icon(Icons.edit_rounded),
                label: Text('Alterar nome'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _chooseAvatar,
                icon: const Icon(Icons.face_retouching_natural_rounded),
                label: Text('Escolher avatar'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.dark_mode_outlined),
                title: Text('Aparência'),
                subtitle: Text(_progress.themeMode),
                onTap: _chooseTheme,
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
                label: Text('Ver minhas estatísticas'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                icon: const Icon(Icons.login_rounded),
                label: Text('Entrar com outra conta'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text('Cadastrar nova conta'),
              ),
              const SizedBox(height: 6),
              Text(
                'Nome, avatar e progresso são salvos localmente neste dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
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
        title: Text('Como quer ser chamado(a)?'),
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
            child: Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('Salvar'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      await _progress.updateProfile(name: result);
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
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final avatar in avatars)
              InkWell(
                onTap: () => Navigator.pop(context, avatar),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(avatar, style: TextStyle(fontSize: 30)),
                ),
              ),
          ],
        ),
      ),
    );
    if (result != null && mounted) {
      await _progress.updateProfile(avatarValue: result);
      setState(() => _avatar = result);
    }
  }

  Future<void> _chooseTheme() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text('Aparência do aplicativo'),
        children: [
          for (final mode in ['Sistema', 'Claro', 'Escuro'])
            RadioListTile<String>(
              value: mode,
              groupValue: _progress.themeMode,
              title: Text(mode),
              onChanged: (value) => Navigator.pop(dialogContext, value),
            ),
        ],
      ),
    );
    if (selected != null) await _progress.updateProfile(theme: selected);
  }

}
