# NucleAR Quiz

Aplicativo educativo em Flutter e Dart que apresenta aplicações da tecnologia nuclear na medicina, agricultura, indústria e geração de energia. O conteúdo é organizado por temas e complementado com quizzes, explicações das respostas e acompanhamento de progresso.

## Integrantes da equipe

| Nome | RM |
| ---- | -- |
| Vitor Costa de Godoi | 568448 |
| Lucas Pompeu | 567010 |
| Felipe Cuesta Puerta de Oliveira | 567703 |
| João Victor De Souza Braz | 566862 |

## Empresa / parceiro

CTMSP / Amazul (Challenge FIAP 2026).

## Descrição resumida da solução

O usuário se cadastra (ou entra), estuda um tema na aba **Aprender**, responde ao quiz (6 perguntas sorteadas por partida, com cronômetro de 40 s por pergunta e pontos em dobro para respostas dadas em até 32 s, ou em modo treino, sem cronômetro), recebe explicação nas respostas incorretas, acumula pontos, acompanha estatísticas, revisa questões erradas e compara sua pontuação no ranking. Login, cadastro e ranking são demonstrativos: a versão não possui backend nem sincroniza dados entre dispositivos (os dados ficam salvos localmente com `shared_preferences`).

## Telas e navegação

| # | Tela | Como se chega |
| - | ---- | ------------- |
| 1 | Boas-vindas | Abertura do app |
| 2 | Login | Boas-vindas → *Entrar* |
| 3 | Cadastro | Boas-vindas → *Cadastrar-se* (formulário validado + Dialog) |
| 4 | Home (abas Início, Aprender, Quiz, Estatísticas, Perfil) | Login/Cadastro |
| 5 | Detalhe do tema | Home → Início/Aprender → tema |
| 6 | Quiz | Home → Quiz → *Participar* ou Detalhe do tema |
| 7 | Resultado | Fim do quiz (recebe pontos, acertos e erros por parâmetro) |
| 8 | Placar | Home → Quiz → *Placar* ou Resultado |
| 9 | Revisão de questões | Home → Estatísticas → *Abrir revisão* |

A navegação usa `Navigator` (`push`, `pop`, `pushReplacement`, `pushAndRemoveUntil` e `popUntil`) com passagem de parâmetros pelos construtores das telas.

## Requisitos da Sprint atendidos

- **Navegação entre telas:** 9 telas conectadas, com avanço e retorno e passagem de parâmetros (`Competition`, `userName`, `WrongAnswer`).
- **Protótipo visual funcional:** tema único (`lib/theme/app_theme.dart`) com cores, espaçamentos e componentes reutilizáveis; uso de `Scaffold`, `AppBar`, `Column`, `Row`, `Container`, `Padding`, `SizedBox`, `Card`, `Image`, `Icon`, `ListView` e `GridView`; dados mockados.
- **Conteúdo:** 4 temas com 12 perguntas cada (48 no total, 6 sorteadas a cada partida), todas com explicação, e textos de estudo na tela de cada tema cobrindo os assuntos do quiz.
- **Placar:** ranking geral ou por tema (filtro por chips; cada quiz tem uma ordem diferente de participantes fictícios), pódio com avatares, posição real do usuário, quanto falta para subir de posição e botão para jogar o quiz do tema.
- **Gerenciamento de estado:** `StatefulWidget` + `setState()` no quiz (cronômetro, resposta selecionada, pontuação), nas abas da Home, na escolha de avatar e na visibilidade da senha; `Provider` + `ChangeNotifier` (`AppProgress`) para o progresso do usuário e `Provider` para o catálogo de perguntas.
- **Formulário e validação:** cadastro e login com `Form`, `GlobalKey<FormState>`, `TextFormField`, validadores (`lib/utils/validators.dart`) e resposta ao usuário por `SnackBar` e `AlertDialog`.

## Tecnologias

- Flutter e Dart
- `provider` para estado compartilhado entre telas
- `shared_preferences` para persistência local
- `flutter_test` para testes automatizados

## Executar pelo VS Code

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install) e as extensões **Flutter** e **Dart** no VS Code.
2. Abra a pasta do projeto no VS Code.
3. Execute `flutter pub get` pelo terminal integrado.
4. Selecione um dispositivo ou navegador na barra inferior e pressione **F5** (ou escolha **Run > Start Debugging**).

## Executar pelo CMD

1. Abra o CMD na pasta do projeto.
2. Baixe as dependências e inicie o aplicativo:

```cmd
flutter pub get
flutter run
```

Para conferir os dispositivos disponíveis, execute `flutter devices`. Para iniciar em um dispositivo específico, use `flutter run -d ID_DO_DISPOSITIVO`.

## Verificações

```bash
flutter analyze
flutter test
```

## Vídeo da demonstração

> **PREENCHER antes da entrega:** link do vídeo no YouTube publicado como **não listado**.

Link: [PREENCHER]

O vídeo deve mostrar a execução em emulador ou dispositivo físico, todas as telas, a navegação, o formulário com validação e a atualização de estado (duração máxima indicada no enunciado: 5 minutos).
