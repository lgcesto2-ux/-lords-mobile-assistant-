# Lords Mobile Assistant — versão inicial 0.1

Aplicação Flutter para Android e Windows. Esta versão serve para registo manual, planeamento e lembretes locais. Não se liga à conta Lords Mobile, não lê dados internos do jogo e não executa ações no jogo.

## Incluído
- Painel principal adaptável a ecrãs pequenos e largos.
- Temporizadores de construção/treino com contagem decrescente, persistência local e notificação agendada.
- Registo local dos cinco recursos.
- Registo da hora de fim do escudo, com lembrete 10 minutos antes (ou na hora, se faltar menos).
- Calendário manual de eventos com notificação à hora marcada.
- Dados guardados no dispositivo com `shared_preferences`.

## Arquitetura
- `screens/`: interface e fluxos de cada módulo.
- `services/storage_service.dart`: persistência local.
- `services/notification_service.dart`: notificações agendadas.
- `main.dart`: inicialização e tema.
- Evolução recomendada: separar modelos/repositórios, adicionar base SQLite/Drift e testes de unidade.

## Requisitos
- Flutter SDK estável instalado.
- Android: Android Studio/SDK e dispositivo ou emulador.
- Windows: Windows 10/11, Visual Studio com workload **Desktop development with C++** e Flutter desktop habilitado.

## Executar
Na pasta do projeto:

```bash
flutter doctor
flutter pub get
flutter devices
```

Android:
```bash
flutter run -d <ID_DO_DISPOSITIVO>
```

Windows (num computador Windows):
```bash
flutter config --enable-windows-desktop
flutter run -d windows
```

Testes:
```bash
flutter analyze
flutter test
```

Build:
```bash
flutter build apk --release
flutter build windows --release
```

## Notificações e execução em segundo plano
As notificações são agendadas pelo sistema operativo; a aplicação não precisa de ficar aberta para o sistema apresentar uma notificação já agendada. No Android, o utilizador tem de autorizar notificações. Fabricantes podem aplicar restrições de bateria; permitir atividade em segundo plano/alarme para a aplicação pode ser necessário. O Android pode exigir permissões adicionais para alarmes exatos, por isso esta versão usa agendamento inexato para reduzir requisitos. No Windows, as notificações dependem das definições de notificações do Windows e da configuração de identidade da aplicação.

Não há execução contínua de um bot em segundo plano. O sistema operativo pode suspender a aplicação; o desenho correto para lembretes é agendar notificações locais.

## Integrações oficiais: o que falta
Não foi implementada integração com IGG/Lords Mobile. Leitura automática de poder, recursos, tropas, edifícios, escudos ou eventos exigiria uma API oficial/documentada da IGG, ou um método de exportação explicitamente permitido. Antes de ligar qualquer serviço:
1. confirmar com a IGG que a API existe e autoriza esse uso;
2. usar OAuth/token oficial, se disponibilizado — nunca pedir palavra-passe da conta;
3. respeitar limites, termos e permissões da plataforma;
4. manter a app apenas em leitura quando não houver autorização explícita para ações.

Captura/análise de imagens poderá ser acrescentada como ferramenta assistida: o utilizador escolhe uma captura de ecrã e a app extrai informação visível para confirmação manual. Não inclui leitura clandestina do ecrã, controlo remoto, macros ou interação automática com o jogo.

## Notas técnicas
- O identificador Windows e GUID no `NotificationService` são valores de desenvolvimento; para distribuição, definir identidade própria e pacote de instalação.
- Para produção Android, confirmar a configuração do plugin de notificações indicada pela versão instalada. Executar `flutter pub get` e seguir os avisos do plugin se o Gradle/compile SDK precisar de atualização.
- Os dados são locais e não sincronizam entre Android e Windows. Sincronização exigiria backend próprio, autenticação segura e consentimento.
