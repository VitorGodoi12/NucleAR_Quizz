import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/models/question.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

// Metadados das competições. O conteúdo das perguntas vem de assets/data/questions.json.
const List<Competition> competitionMetadata = [
  Competition(
    id: 'medicina',
    title: 'Nuclear na Medicina',
    theme: 'Saúde',
    description: 'Descubra como radiofármacos ajudam a observar órgãos, como a radioterapia pode tratar tumores e como a radiação esteriliza materiais médicos. Cada aplicação utiliza técnicas específicas, com planejamento e controle de segurança.',
    curiosity: 'No exame PET, um radiofármaco em quantidade controlada ajuda a revelar a atividade de tecidos e órgãos, complementando outras informações clínicas.',
    icon: Icons.medical_services_rounded,
    color: AppColors.health,
    questions: [],
    resultsReleased: true,
  ),
  Competition(
    id: 'agricultura',
    title: 'Nuclear na Agricultura',
    theme: 'Agricultura',
    description: 'Veja como técnicas nucleares podem ajudar a conservar alimentos, acompanhar a absorção de nutrientes pelas plantas e reduzir populações de determinadas pragas. O objetivo é apoiar a produção e o controle de qualidade com métodos monitorados.',
    curiosity: 'A irradiação transfere energia ao alimento para reduzir microrganismos e pragas; ela não adiciona material radioativo ao produto.',
    icon: Icons.agriculture_rounded,
    color: AppColors.agro,
    questions: [],
    resultsReleased: true,
  ),
  Competition(
    id: 'industria',
    title: 'Nuclear na Indústria',
    theme: 'Indústria',
    description: 'Conheça aplicações que permitem inspecionar soldas e componentes por dentro sem destruí-los, medir a espessura de produtos e modificar propriedades de alguns materiais. Essas técnicas ajudam a detectar falhas e manter padrões de qualidade.',
    curiosity: 'Alguns detectores de fumaça do tipo iônico usam uma quantidade muito pequena de amerício-241 dentro de uma câmara protegida.',
    icon: Icons.precision_manufacturing_rounded,
    color: AppColors.industry,
    questions: [],
    resultsReleased: true,
  ),
  Competition(
    id: 'energia',
    title: 'Geração de Energia',
    theme: 'Energia',
    description: 'Entenda como a fissão nuclear libera calor, como esse calor é convertido em eletricidade e quais cuidados são necessários para operar uma usina. O tema também apresenta iniciativas brasileiras de pesquisa e desenvolvimento nuclear.',
    curiosity: 'Durante a geração de eletricidade, uma usina nuclear não libera CO₂ pela queima de combustível; ainda assim, há impactos e resíduos que precisam ser gerenciados.',
    icon: Icons.bolt_rounded,
    color: AppColors.energy,
    questions: [],
    resultsReleased: true,
  ),
];

List<Competition> buildCompetitions(Map<String, dynamic> questionData) {
  return [
    for (final metadata in competitionMetadata)
      metadata.withQuestions(_questionsFor(questionData, metadata.id)),
  ];
}

List<Question> _questionsFor(Map<String, dynamic> data, String topicId) {
  final rawQuestions = data[topicId];
  if (rawQuestions is! List || rawQuestions.isEmpty) {
    throw FormatException('Não há perguntas cadastradas para "$topicId".');
  }
  return [
    for (final raw in rawQuestions)
      if (raw is Map<String, dynamic>) Question.fromJson(raw)
      else if (raw is Map) Question.fromJson(Map<String, dynamic>.from(raw))
      else throw FormatException('Pergunta inválida no tema "$topicId".'),
  ];
}
