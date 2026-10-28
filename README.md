# NucleAR Quiz

Aplicativo educativo em Flutter e Dart que apresenta aplicações da tecnologia nuclear na medicina, agricultura, indústria e geração de energia. O conteúdo é organizado por temas e complementado com quizzes, explicações das respostas e acompanhamento de progresso.

## Funcionalidades

- Tela de boas-vindas, login demonstrativo e cadastro validado.
- Navegação entre início, aprendizagem, quiz, estatísticas e perfil.
- Conteúdos e detalhes para quatro temas relacionados à tecnologia nuclear.
- Quizzes com cronômetro, pontuação, feedback e explicações.
- Progresso, ranking demonstrativo e revisão de questões incorretas.
- Dados de progresso e perfil salvos localmente no dispositivo.

Login, cadastro e ranking são demonstrativos. Esta versão não possui backend nem sincroniza dados entre dispositivos.

## Equipe e parceiro

- Integrantes e RMs: preencher com os dados da equipe antes da entrega.
- Parceiro: CTMSP / Amazul.

## Tecnologias

- Flutter e Dart
- `shared_preferences` para persistência local
- `flutter_test` para testes automatizados

## Executar em Android

1. Instale o Flutter e configure o Android SDK.
2. Inicie um emulador Android ou conecte um dispositivo físico com depuração USB.
3. Na pasta deste projeto, execute:

```bash
flutter pub get
flutter run
```

## Verificações

```bash
flutter analyze
flutter test
```

## Vídeo da demonstração

Adicionar o link do vídeo narrado no YouTube como “não listado”. A demonstração deve apresentar a execução em emulador ou dispositivo físico, todas as telas, navegação, formulário e validação e a atualização de estado. Duração máxima indicada no enunciado: 5 minutos.
