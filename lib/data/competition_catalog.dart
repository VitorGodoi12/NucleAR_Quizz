import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nuclear_quizdefinitivo/data/mock_competitions.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';

/// Catálogo carregado uma vez no início do aplicativo.
class CompetitionCatalog {
  CompetitionCatalog(Iterable<Competition> competitions)
    : competitions = List.unmodifiable(competitions);

  final List<Competition> competitions;

  static Future<CompetitionCatalog> load({AssetBundle? bundle}) async {
    final jsonText = await (bundle ?? rootBundle).loadString(
      'assets/data/questions.json',
    );
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('O catálogo de perguntas deve ser um objeto JSON.');
    }
    return CompetitionCatalog(buildCompetitions(decoded));
  }
}
