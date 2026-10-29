import 'package:nuclear_quizdefinitivo/models/participant.dart';

// Participantes fictícios (placar geral = soma dos quatro temas).
const List<Participant> mockParticipants = [
  Participant(
    name: 'Ana Souza',
    avatar: '🧬',
    score: 280,
    topicScores: {'medicina': 70, 'agricultura': 60, 'industria': 80, 'energia': 70},
  ),
  Participant(
    name: 'Felipe Costa',
    avatar: '🛰️',
    score: 240,
    topicScores: {'medicina': 60, 'agricultura': 70, 'industria': 50, 'energia': 60},
  ),
  Participant(
    name: 'Carla Mendes',
    avatar: '🔬',
    score: 220,
    topicScores: {'medicina': 50, 'agricultura': 60, 'industria': 60, 'energia': 50},
  ),
  Participant(
    name: 'Bruno Lima',
    avatar: '⚛️',
    score: 200,
    topicScores: {'medicina': 60, 'agricultura': 40, 'industria': 50, 'energia': 50},
  ),
  Participant(
    name: 'Elisa Rocha',
    avatar: '🧪',
    score: 180,
    topicScores: {'medicina': 40, 'agricultura': 50, 'industria': 50, 'energia': 40},
  ),
  Participant(
    name: 'Diego Alves',
    avatar: '🔭',
    score: 160,
    topicScores: {'medicina': 40, 'agricultura': 40, 'industria': 30, 'energia': 50},
  ),
  Participant(
    name: 'Marina Oliveira',
    avatar: '🌎',
    score: 140,
    topicScores: {'medicina': 30, 'agricultura': 40, 'industria': 40, 'energia': 30},
  ),
  Participant(
    name: 'Rafael Santos',
    avatar: '💡',
    score: 120,
    topicScores: {'medicina': 30, 'agricultura': 30, 'industria': 40, 'energia': 20},
  ),
  Participant(
    name: 'Júlia Martins',
    avatar: '🚀',
    score: 100,
    topicScores: {'medicina': 20, 'agricultura': 30, 'industria': 20, 'energia': 30},
  ),
  Participant(
    name: 'Lucas Ferreira',
    avatar: '☢️',
    score: 80,
    topicScores: {'medicina': 20, 'agricultura': 10, 'industria': 30, 'energia': 20},
  ),
];
