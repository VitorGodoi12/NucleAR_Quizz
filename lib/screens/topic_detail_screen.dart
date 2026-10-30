import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/models/competition.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/widgets/gradient_header.dart';

/// Página dedicada a um tema, com introdução, explicação, curiosidade e acesso ao quiz.
class TopicDetailScreen extends StatelessWidget {
  final Competition competition;
  const TopicDetailScreen({super.key, required this.competition});

  List<_LearningSection> get _learningSections {
    switch (competition.id) {
      case 'medicina':
        return const [
          _LearningSection(
            'O que significa usar tecnologia nuclear na saúde?',
            'Na medicina, a radiação e materiais radioativos são utilizados de forma controlada para investigar o funcionamento do corpo e auxiliar alguns tratamentos. A técnica escolhida depende da pergunta clínica: observar a atividade de um órgão é diferente de produzir uma imagem de sua estrutura ou tratar uma doença.',
            Icons.health_and_safety_rounded,
          ),
          _LearningSection(
            'Medicina nuclear: observar funções',
            'Em exames de medicina nuclear, uma pequena quantidade de radiofármaco é administrada ao paciente. Esse composto se concentra em determinadas regiões ou acompanha processos do organismo. Equipamentos detectam a radiação emitida e ajudam a criar imagens funcionais. No PET, por exemplo, é possível estudar a atividade metabólica dos tecidos. O resultado é interpretado por profissionais de saúde junto com outras informações clínicas.',
            Icons.monitor_heart_rounded,
          ),
          _LearningSection(
            'Radioterapia: tratar com precisão',
            'A radioterapia utiliza radiação ionizante para danificar o material genético das células-alvo e dificultar que elas continuem se multiplicando. O tratamento é planejado para concentrar a dose na região que precisa ser tratada e reduzir a exposição dos tecidos saudáveis próximos. O tipo de tratamento, a dose e a duração variam conforme a doença e a avaliação da equipe especializada.',
            Icons.center_focus_strong_rounded,
          ),
          _LearningSection(
            'E a segurança?',
            'Todo procedimento precisa ter uma justificativa médica e seguir protocolos de proteção radiológica. A equipe considera os benefícios esperados, controla a exposição e orienta o paciente sobre os cuidados necessários. Radiação não é sinônimo automático de perigo: o risco depende, entre outros fatores, do tipo de radiação, da dose e da forma de exposição.',
            Icons.shield_rounded,
          ),
          _LearningSection(
            'Radiofármacos e meia-vida',
            'Radiofármacos são medicamentos que contêm um radioisótopo. Cada um é escolhido pelo comportamento no corpo e pelo tempo que leva para perder atividade, chamado de meia-vida. O tecnécio-99m, usado em cintilografias, emite radiação gama detectável e tem meia-vida de cerca de 6 horas. O iodo-131 é absorvido pela tireoide e pode ser usado no tratamento de hipertireoidismo e de alguns tipos de câncer dessa glândula. Meia-vida curta ajuda a reduzir a exposição depois do exame.',
            Icons.science_rounded,
          ),
          _LearningSection(
            'Esterilização por radiação',
            'Seringas, luvas, gazes e outros materiais descartáveis podem ser esterilizados com radiação gama ou feixes de elétrons já dentro da embalagem. A radiação elimina bactérias e vírus sem aquecer o produto, o que é ideal para itens sensíveis ao calor. Depois do processo, os materiais não ficam radioativos e seguem para uso normal.',
            Icons.sanitizer_rounded,
          ),
          _LearningSection(
            'Tempo, distância e blindagem',
            'Quem trabalha com radiação aplica três ideias básicas: reduzir o tempo de exposição, aumentar a distância da fonte e usar blindagem adequada, como paredes e aventais de chumbo. Dosímetros individuais registram a dose recebida, e as equipes seguem limites e protocolos de segurança. Esses cuidados valem na medicina, na indústria e na pesquisa.',
            Icons.security_rounded,
          ),
        ];
      case 'agricultura':
        return const [
          _LearningSection(
            'Por que usar técnicas nucleares no campo?',
            'A ciência nuclear pode ajudar pesquisadores a entender processos que não são fáceis de acompanhar apenas observando uma planta ou um solo. Métodos com isótopos permitem rastrear o caminho de água e nutrientes, avaliar práticas agrícolas e desenvolver formas de produzir alimentos com melhor uso dos recursos.',
            Icons.eco_rounded,
          ),
          _LearningSection(
            'Rastreando água e nutrientes',
            'Alguns isótopos funcionam como marcadores científicos. Ao medir onde eles aparecem e em que quantidade, pesquisadores conseguem estudar como as plantas absorvem nutrientes, como a água se movimenta no solo e quanto de um fertilizante é aproveitado pela cultura. Essas informações podem orientar a irrigação e o manejo do solo, evitando desperdícios e ajudando a proteger o ambiente.',
            Icons.water_drop_rounded,
          ),
          _LearningSection(
            'Controle de pragas',
            'Uma aplicação conhecida é a Técnica do Inseto Estéril. Nesse método, insetos de uma espécie-alvo são criados em condições controladas, esterilizados com uma dose planejada de radiação e liberados em áreas monitoradas. Como não produzem descendentes, a reprodução da população pode diminuir ao longo do tempo. A técnica é específica para determinadas espécies e costuma fazer parte de uma estratégia integrada de controle.',
            Icons.pest_control_rounded,
          ),
          _LearningSection(
            'Irradiação de alimentos',
            'A irradiação utiliza energia para reduzir microrganismos ou insetos e pode atrasar alguns processos de deterioração. Ela é aplicada sob regras e doses estabelecidas para cada finalidade. O alimento irradiado não se torna automaticamente radioativo: o processo transfere energia, não adiciona uma fonte radioativa ao alimento. A irradiação também não substitui higiene, armazenamento adequado nem boas práticas de produção.',
            Icons.grain_rounded,
          ),
          _LearningSection(
            'Melhoramento de plantas por mutação',
            'A radiação pode provocar mutações aleatórias no material genético de sementes e plantas. A maioria não traz vantagem, mas algumas geram características desejáveis, como maior tolerância à seca ou a doenças. Os pesquisadores selecionam as melhores plantas e as cruzam ao longo de várias gerações. Esse método não é o mesmo que inserir genes de outras espécies.',
            Icons.spa_rounded,
          ),
          _LearningSection(
            'Pesquisa nuclear no campo brasileiro',
            'No Brasil, instituições como o Centro de Energia Nuclear na Agricultura (CENA/USP), em Piracicaba (SP), usam isótopos e outras técnicas nucleares para estudar solo, plantas, água e alimentos. Os resultados ajudam a entender como usar melhor fertilizantes e água, e a produzir alimentos com mais eficiência e menor impacto ambiental.',
            Icons.biotech_rounded,
          ),
        ];
      case 'industria':
        return const [
          _LearningSection(
            'O papel da tecnologia nuclear na indústria',
            'Na indústria, algumas técnicas utilizam a capacidade da radiação de atravessar materiais ou interagir de maneiras diferentes com cada substância. Isso permite inspecionar produtos sem desmontá-los, medir características durante a fabricação e verificar a qualidade de peças que precisam ser confiáveis.',
            Icons.precision_manufacturing_rounded,
          ),
          _LearningSection(
            'Radiografia industrial',
            'Assim como uma radiografia médica mostra estruturas internas do corpo, a radiografia industrial pode revelar o interior de soldas, tubulações e componentes. Diferenças na passagem da radiação ajudam a identificar possíveis trincas, poros ou falhas internas. Como a peça não precisa ser cortada para ser examinada, o método é chamado de ensaio não destrutivo.',
            Icons.search_rounded,
          ),
          _LearningSection(
            'Medir sem tocar',
            'Medidores nucleares podem verificar a espessura, a densidade ou o nível de certos materiais durante um processo de produção. O equipamento compara a radiação emitida ou detectada depois de interagir com o material. Essa medição pode ser rápida e contínua, ajudando a manter produtos dentro das especificações e a reduzir desperdícios.',
            Icons.straighten_rounded,
          ),
          _LearningSection(
            'Proteção e controle de qualidade',
            'Fontes de radiação industrial exigem procedimentos rigorosos, equipamentos adequados, sinalização, treinamento e controle de acesso. A atividade é realizada por profissionais qualificados, seguindo normas de proteção radiológica. O benefício da inspeção depende de usar o método correto e interpretar os resultados de forma técnica.',
            Icons.verified_user_rounded,
          ),
          _LearningSection(
            'Detectores de fumaça',
            'Detectores de fumaça do tipo iônico possuem uma câmara com uma quantidade muito pequena de amerício-241. A radiação ioniza o ar dentro da câmara e gera uma corrente elétrica fraca. Quando a fumaça entra, a corrente muda e o alarme dispara. A fonte fica selada e protegida, e o aparelho não deve ser aberto nem descartado de forma inadequada.',
            Icons.smoke_free_rounded,
          ),
          _LearningSection(
            'Modificando materiais com radiação',
            'Feixes de elétrons e outras radiações podem alterar a estrutura de polímeros, criando ligações entre as cadeias do material. Isso torna isolantes de cabos elétricos, tubos e embalagens mais resistentes ao calor e ao desgaste. O material tratado não fica radioativo.',
            Icons.cable_rounded,
          ),
        ];
      default:
        return const [
          _LearningSection(
            'De onde vem a energia nuclear?',
            'O núcleo de um átomo contém prótons e nêutrons. Em certos átomos pesados, como o urânio-235, o núcleo pode se dividir após absorver um nêutron. Esse processo é chamado fissão nuclear e libera energia, além de outros nêutrons que podem provocar novas fissões.',
            Icons.bubble_chart_rounded,
          ),
          _LearningSection(
            'Da fissão à eletricidade',
            'Em uma usina nuclear, a energia liberada nas fissões aquece um fluido, geralmente água. O calor é usado para produzir vapor, que movimenta uma turbina conectada a um gerador elétrico. Depois, o vapor é resfriado e condensado para que a água possa voltar ao ciclo. A turbina e o gerador transformam a energia térmica em movimento e, então, em eletricidade.',
            Icons.electric_bolt_rounded,
          ),
          _LearningSection(
            'O que é uma reação em cadeia?',
            'Os nêutrons liberados em uma fissão podem atingir outros núcleos e causar novas fissões. Em um reator, essa reação em cadeia é controlada por sistemas próprios, que regulam a quantidade de nêutrons e o calor produzido. O projeto também inclui sistemas de resfriamento, barreiras de contenção e monitoramento para manter a operação dentro de limites seguros.',
            Icons.hub_rounded,
          ),
          _LearningSection(
            'Benefícios e responsabilidades',
            'Durante a geração elétrica, a usina não queima carvão ou gás para produzir calor e, por isso, suas emissões diretas de dióxido de carbono durante a operação são baixas. Mesmo assim, a energia nuclear exige planejamento, manutenção, preparação para emergências e gestão de resíduos radioativos. Avaliar essa fonte de energia significa considerar tanto sua contribuição para o fornecimento elétrico quanto seus custos, impactos e responsabilidades de longo prazo.',
            Icons.balance_rounded,
          ),
          _LearningSection(
            'Controle e camadas de segurança',
            'O reator é projetado com várias camadas de proteção. Barras de controle, feitas de materiais que absorvem nêutrons, são inseridas ou retiradas do núcleo para regular a reação em cadeia. Sistemas de refrigeração removem o calor, e barreiras sucessivas, como o vaso de pressão e o prédio de contenção, ajudam a conter materiais radioativos.',
            Icons.tune_rounded,
          ),
          _LearningSection(
            'Programa Nuclear da Marinha',
            'Conduzido pelo CTMSP desde 1979, o Programa Nuclear da Marinha busca dominar tecnologias do ciclo do combustível nuclear e de plantas de geração de energia elétrica. Esse conhecimento fortalece a capacitação científica e industrial do país. A Amazul, empresa pública ligada ao Ministério da Defesa, atua em apoio a esses projetos.',
            Icons.sailing_rounded,
          ),
          _LearningSection(
            'Angra 1 e Angra 2',
            'As usinas nucleares Angra 1 e Angra 2 ficam em Angra dos Reis (RJ) e fornecem eletricidade ao sistema elétrico brasileiro. O princípio é o mesmo explicado acima: fissão, vapor, turbina e gerador. A operação segue regras de segurança, fiscalização por órgãos reguladores e monitoramento ambiental.',
            Icons.location_city_rounded,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = competition.color;
    return Scaffold(
      appBar: AppBar(title: Text(competition.theme)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              AppSpacing.m,
              AppSpacing.m,
              0,
            ),
            child: _TopicIllustration(competition: competition),
          ),
          GradientHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(competition.icon, color: Colors.white, size: 34),
                ),
                const SizedBox(height: 18),
                Text(
                  competition.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  competition.description,
                  style: TextStyle(
                    color: Color(0xFFD8E7F5),
                    height: 1.55,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(
                      icon: Icons.menu_book_rounded,
                      text: 'Leitura rápida',
                    ),
                    _Pill(
                      icon: Icons.quiz_rounded,
                      text: '${competition.questions.length} perguntas',
                    ),
                    const _Pill(
                      icon: Icons.timer_outlined,
                      text: '30 s por pergunta',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leia e aprenda',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Antes do desafio, entenda os conceitos. Leia cada parte com calma e depois teste o que aprendeu no quiz.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.55,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: tintOf(context, color),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withAlpha(35)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: accentOnSurface(context, color),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${_learningSections.length} partes para estudar • cerca de 4–6 minutos de leitura',
                          style: TextStyle(
                            color: accentOnSurface(context, color),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < _learningSections.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(17),
                    decoration: appCardDecoration(context: context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: color.withAlpha(24),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _learningSections[i].icon,
                                color: accentOnSurface(context, color),
                                size: 23,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  '${i + 1}. ${_learningSections[i].title}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                    fontSize: 17,
                                    height: 1.3,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _learningSections[i].body,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.75,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                      SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Antes de começar o quiz',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Tente explicar com suas próprias palavras o que leu. Se algum conceito ainda estiver confuso, volte à seção correspondente. Aprender não é decorar: é entender como e por que algo funciona.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: tintOf(context, color),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withAlpha(55)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        color: accentOnSurface(context, color),
                        size: 27,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Você sabia?',
                              style: TextStyle(
                                color: accentOnSurface(context, color),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              competition.curiosity,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: competition,
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      'Li o conteúdo — iniciar quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Responda no seu ritmo e aprenda com as explicações.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningSection {
  final String title;
  final String body;
  final IconData icon;
  const _LearningSection(this.title, this.body, this.icon);
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white.withAlpha(45)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

/// Ilustração vetorial local para cada tema: não depende de imagens externas.
class _TopicIllustration extends StatelessWidget {
  final Competition competition;
  const _TopicIllustration({required this.competition});

  @override
  Widget build(BuildContext context) {
    final color = competition.color;
    final (mainIcon, leftIcon, rightIcon, eyebrow) = switch (competition.id) {
      'medicina' => (
        Icons.biotech_rounded,
        Icons.favorite_rounded,
        Icons.monitor_heart_rounded,
        'CIÊNCIA QUE CUIDA',
      ),
      'agricultura' => (
        Icons.eco_rounded,
        Icons.grass_rounded,
        Icons.spa_rounded,
        'CIÊNCIA NO CAMPO',
      ),
      'industria' => (
        Icons.precision_manufacturing_rounded,
        Icons.factory_rounded,
        Icons.troubleshoot_rounded,
        'TECNOLOGIA EM AÇÃO',
      ),
      _ => (
        Icons.bolt_rounded,
        Icons.brightness_5_rounded,
        Icons.electric_bolt_rounded,
        'ENERGIA E INOVAÇÃO',
      ),
    };

    return Container(
      height: 184,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tintOf(context, color),
            color.withAlpha(45),
            Theme.of(context).colorScheme.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withAlpha(35)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -44,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            left: 95,
            bottom: -72,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withAlpha(35), width: 18),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 22,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                leftIcon,
                color: accentOnSurface(context, color),
                size: 23,
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: 27,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                rightIcon,
                color: accentOnSurface(context, color),
                size: 23,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(225),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(35),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(
                mainIcon,
                color: accentOnSurface(context, color),
                size: 56,
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(225),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                eyebrow,
                style: TextStyle(
                  color: accentOnSurface(context, color),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 18,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: color.withAlpha(170),
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}
