/// Funções de validação usadas nos formulários (retornam null se válido).
class Validators {
  static String? notEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $fieldName.';
    }
    return null;
  }

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe o nome.';
    if (text.length < 2) return 'O nome deve ter pelo menos 2 caracteres.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe o e-mail.';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    return valid ? null : 'Digite um e-mail válido, como nome@exemplo.com.';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha.';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    return null;
  }

  /// Nome de exibição simulado a partir do e-mail (usado no login simulado).
  static String nameFromEmail(String email) {
    final local = email.trim().split('@').first;
    if (local.isEmpty) return 'Participante';
    return local[0].toUpperCase() + local.substring(1);
  }
}
