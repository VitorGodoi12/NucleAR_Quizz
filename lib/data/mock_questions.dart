import 'package:nuclear_quizdefinitivo/models/question.dart';

// Dados simulados: ficam apenas em memória, sem persistência.

const List<Question> medicineQuestions = [
  Question(
    text: 'Qual exame de imagem usa uma substância radioativa (radiofármaco) para mostrar o funcionamento de órgãos e tecidos?',
    options: [
      'Ressonância magnética',
      'Tomografia por emissão de pósitrons (PET)',
      'Ultrassonografia',
      'Endoscopia',
    ],
    correctIndex: 1,
    explanation: 'O PET utiliza um radiofármaco, como a glicose marcada com flúor-18, e detecta a radiação emitida para mapear o metabolismo do corpo. A ressonância usa campos magnéticos e ondas de rádio, e o ultrassom usa ondas sonoras: nenhum dos dois emprega material radioativo.',
  ),
  Question(
    text: 'O iodo-131 é um radioisótopo usado na medicina nuclear para tratar doenças de qual órgão?',
    options: ['Tireoide', 'Pulmão', 'Fígado', 'Estômago'],
    correctIndex: 0,
    explanation: 'A tireoide absorve iodo naturalmente. Por isso o iodo-131 chega a esse órgão e é usado no tratamento de hipertireoidismo e de alguns tipos de câncer de tireoide, atingindo pouco os demais tecidos.',
  ),
  Question(
    text:
        'Qual é o principal objetivo da radioterapia no tratamento do câncer?',
    options: [
      'Aquecer o corpo do paciente',
      'Substituir a cirurgia em todos os casos',
      'Tornar o paciente permanentemente radioativo',
      'Danificar as células tumorais e impedir que se multipliquem',
    ],
    correctIndex: 3,
    explanation: 'A radiação é direcionada ao tumor e danifica o DNA das células cancerosas, impedindo que se multipliquem. Na radioterapia externa o paciente não fica radioativo, e o tratamento pode ser combinado com cirurgia e quimioterapia.',
  ),
  Question(
    text: 'Para que a radiação gama é usada em seringas, luvas e outros materiais médicos descartáveis?',
    options: [
      'Deixar o material mais flexível',
      'Identificar o fabricante',
      'Esterilizar, eliminando microrganismos',
      'Torná-lo resistente a quedas',
    ],
    correctIndex: 2,
    explanation: 'A radiação gama elimina bactérias e vírus mesmo com o material já embalado e sem aquecê-lo, o que é ideal para itens sensíveis ao calor. Depois do processo, os produtos não ficam radioativos.',
  ),
];

const List<Question> agricultureQuestions = [
  Question(
    text: 'Um alimento que passa por irradiação para conservação fica radioativo?',
    options: [
      'Sim, permanece radioativo por semanas',
      'Sim, mas apenas as frutas',
      'Não, o alimento não se torna radioativo',
      'Depende da cor do alimento',
    ],
    correctIndex: 2,
    explanation: 'Na irradiação de alimentos, a energia atravessa o produto e elimina microrganismos e insetos, além de retardar o amadurecimento, mas não deixa material radioativo no alimento.',
  ),
  Question(
    text: 'Na técnica do inseto estéril, qual é o papel da radiação?',
    options: [
      'Esterilizar insetos criados em laboratório para reduzir a população da praga',
      'Matar todas as plantas ao redor',
      'Aumentar o tamanho dos insetos',
      'Atrair insetos para a lavoura',
    ],
    correctIndex: 0,
    explanation: 'Machos criados em laboratório são esterilizados por radiação e soltos no campo. Ao acasalarem com fêmeas selvagens, não geram descendentes, e a população da praga diminui, reduzindo o uso de inseticidas. A técnica é usada, por exemplo, contra a mosca-das-frutas.',
  ),
  Question(
    text: 'Como a radiação pode ajudar a criar variedades de plantas mais resistentes?',
    options: [
      'Inserindo metais nas sementes',
      'Provocando mutações aleatórias, entre as quais se selecionam as melhores plantas',
      'Congelando as sementes',
      'Pintando as sementes',
    ],
    correctIndex: 1,
    explanation: 'A irradiação de sementes acelera mutações, que também ocorrem na natureza. Os pesquisadores selecionam as plantas com características desejadas, como maior produtividade ou resistência a doenças.',
  ),
  Question(
    text: 'Para que servem isótopos usados como traçadores na agricultura?',
    options: [
      'Colorir frutas',
      'Aumentar a velocidade do trator',
      'Medir a temperatura do ar',
      'Acompanhar como as plantas absorvem nutrientes e fertilizantes',
    ],
    correctIndex: 3,
    explanation: 'Ao marcar um fertilizante com um isótopo, é possível detectar quanto a planta absorve e em quanto tempo. Isso ajuda a usar menos adubo, reduzindo custos e impacto ambiental.',
  ),
];

const List<Question> industryQuestions = [
  Question(
    text: 'Para que é usada a gamagrafia industrial?',
    options: [
      'Pintar peças metálicas',
      'Fabricar parafusos',
      'Inspecionar soldas e peças por dentro, sem danificá-las',
      'Cortar chapas de aço',
    ],
    correctIndex: 2,
    explanation: 'Semelhante a uma radiografia, a gamagrafia usa radiação para revelar falhas internas em soldas, tubulações e peças. É um ensaio não destrutivo e aumenta a segurança de estruturas como dutos e aeronaves.',
  ),
  Question(
    text: 'Como medidores nucleares ajudam na produção de papel, chapas e plásticos?',
    options: [
      'Definindo a cor do produto',
      'Controlando a espessura do material durante a fabricação',
      'Contando os funcionários da fábrica',
      'Gerando eletricidade para a linha de produção',
    ],
    correctIndex: 1,
    explanation: 'Parte da radiação é absorvida ao atravessar o material, e a quantidade que passa indica a espessura. Assim a máquina se ajusta automaticamente, sem contato com o produto e com menos desperdício.',
  ),
  Question(
    text: 'Muitos detectores de fumaça residenciais (tipo iônico) contêm uma pequena quantidade de qual elemento radioativo?',
    options: [
      'Plutônio-239',
      'Urânio enriquecido',
      'Césio-137',
      'Amerício-241',
    ],
    correctIndex: 3,
    explanation: 'Detectores iônicos usam uma quantidade mínima de amerício-241 para ionizar o ar dentro da câmara. Quando a fumaça entra, a corrente elétrica muda e o alarme dispara. Em uso normal não há risco, mas o descarte deve seguir as normas.',
  ),
  Question(
    text: 'Por que feixes de elétrons e radiação são usados na fabricação de cabos elétricos e polímeros?',
    options: [
      'Para deixar o cabo radioativo e facilitar sua localização',
      'Para reduzir o preço do cobre',
      'Para melhorar a resistência e a durabilidade do material',
      'Para trocar a cor do plástico',
    ],
    correctIndex: 2,
    explanation: 'A radiação cria ligações entre as cadeias do polímero (processo chamado reticulação), tornando o material mais resistente ao calor e ao desgaste. O produto final não fica radioativo.',
  ),
];

const List<Question> energyQuestions = [
  Question(
    text: 'O que acontece na fissão nuclear usada nas usinas?',
    options: [
      'O combustível queima como o carvão',
      'Núcleos pesados, como o de urânio-235, se dividem e liberam energia',
      'Átomos de hidrogênio são produzidos a partir do ar',
      'A água é transformada em urânio',
    ],
    correctIndex: 1,
    explanation: 'Na fissão, um nêutron atinge um núcleo de urânio-235, que se divide em núcleos menores liberando muito calor. Esse calor gera vapor, que move turbinas e produz eletricidade. Não há queima nem chama.',
  ),
  Question(
    text: 'Qual é uma vantagem ambiental da geração nuclear de eletricidade?',
    options: [
      'Não produz nenhum resíduo',
      'Dispensa controles de segurança',
      'Usa o vento como combustível',
      'Não emite CO₂ durante a operação',
    ],
    correctIndex: 3,
    explanation: 'Durante a operação, usinas nucleares não emitem gás carbônico, o que ajuda a reduzir as emissões ligadas ao aquecimento global. Elas geram resíduos, em pequeno volume e gerenciados com rigor, por isso afirmar que não produzem nenhum resíduo está incorreto.',
  ),
  Question(
    text: 'O Programa Nuclear da Marinha (PNM), conduzido pelo CTMSP desde 1979, busca dominar tecnologias relacionadas a quê?',
    options: [
      'Exploração de petróleo',
      'Produção de alimentos',
      'Ciclo do combustível nuclear e planta de geração de energia elétrica',
      'Telefonia celular',
    ],
    correctIndex: 2,
    explanation: 'O PNM desenvolve o domínio do ciclo do combustível nuclear e de uma planta nuclear de geração de energia elétrica, com aplicações militares e civis, contribuindo para a inovação, a indústria nacional e a autonomia tecnológica do país.',
  ),
  Question(
    text: 'Em qual município brasileiro ficam as usinas nucleares Angra 1 e Angra 2?',
    options: [
      'Angra dos Reis (RJ)',
      'Santos (SP)',
      'Salvador (BA)',
      'Fortaleza (CE)',
    ],
    correctIndex: 0,
    explanation: 'As usinas Angra 1 e Angra 2 ficam em Angra dos Reis, no Rio de Janeiro, na Central Nuclear Almirante Álvaro Alberto.',
  ),
];
