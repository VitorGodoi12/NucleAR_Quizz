# NucleAR Quiz

Aplicativo educativo em Flutter e Dart que apresenta aplicações da tecnologia nuclear na medicina, agricultura, indústria e geração de energia. O conteúdo é organizado por temas e complementado com quizzes, explicações das respostas e acompanhamento de progresso.

## Integrantes da equipe

> **PREENCHER antes da entrega:** nome completo e RM de cada integrante.

| Nome | RM |
| ---- | -- |
| [PREENCHER] | [PREENCHER] |
| [PREENCHER] | [PREENCHER] |
| [PREENCHER] | [PREENCHER] |

## Empresa / parceiro

CTMSP / Amazul (Challenge FIAP 2026).

## Descrição resumida da solução

O usuário se cadastra (ou entra), estuda um tema na aba **Aprender**, responde ao quiz com cronômetro de 30 s por pergunta, recebe explicação nas respostas incorretas, acumula pontos, acompanha estatísticas, revisa questões erradas e compara sua pontuação no ranking. Login, cadastro e ranking são demonstrativos: a versão não possui backend nem sincroniza dados entre dispositivos (os dados ficam salvos localmente com `shared_preferences`).

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
- **Conteúdo:** 4 temas com 6 perguntas cada (24 no total), todas com explicação, e textos de estudo na tela de cada tema cobrindo os assuntos do quiz.
- **Placar:** ranking geral ou por tema (filtro por chips; cada quiz tem uma ordem diferente de participantes fictícios), pódio com avatares, posição real do usuário, quanto falta para subir de posição e botão para jogar o quiz do tema.
- **Gerenciamento de estado:** `StatefulWidget` + `setState()` no quiz (cronômetro, resposta selecionada, pontuação), nas abas da Home, na escolha de avatar e na visibilidade da senha.
- **Formulário e validação:** cadastro e login com `Form`, `GlobalKey<FormState>`, `TextFormField`, validadores (`lib/utils/validators.dart`) e resposta ao usuário por `SnackBar` e `AlertDialog`.

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

> **PREENCHER antes da entrega:** link do vídeo no YouTube publicado como **não listado**.

Link: [PREENCHER]

O vídeo deve mostrar a execução em emulador ou dispositivo físico, todas as telas, a navegação, o formulário com validação e a atualização de estado (duração máxima indicada no enunciado: 5 minutos).
