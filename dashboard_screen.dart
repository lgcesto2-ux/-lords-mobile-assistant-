import 'package:flutter/material.dart';
import 'timers_screen.dart';
import 'resources_screen.dart';
import 'shields_screen.dart';
import 'events_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <_Module>[
      _Module('Temporizadores', Icons.timer_outlined, const TimersScreen()),
      _Module('Recursos', Icons.inventory_2_outlined, const ResourcesScreen()),
      _Module('Escudos', Icons.shield_outlined, const ShieldsScreen()),
      _Module('Calendário', Icons.event_outlined, const EventsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LORDS ASSISTANT'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Tooltip(message: 'Assistente local', child: Icon(Icons.circle, color: Colors.greenAccent, size: 11)),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 4 : 2;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('CENTRAL DE CONTROLO',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.blueGrey[200], letterSpacing: 1.5)),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: constraints.maxWidth >= 760 ? 1.7 : 1.25,
                  children: const [
                    _StatCard('Poder', '—', 'Registo manual'),
                    _StatCard('Recursos', '5 tipos', 'Valores locais'),
                    _StatCard('Temporizadores', 'Ativos', 'Construção e treino'),
                    _StatCard('Integração', 'Manual', 'Sem acesso ao jogo'),
                  ],
                ),
                const SizedBox(height: 26),
                Text('MÓDULOS', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.builder(
                  itemCount: modules.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => module.screen)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(module.icon, size: 34, color: Colors.lightBlueAccent),
                              const SizedBox(height: 10),
                              Text(module.title, textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.info_outline, color: Colors.lightBlueAccent),
                      SizedBox(width: 12),
                      Expanded(child: Text(
                        'Os dados são registados manualmente e guardados neste dispositivo. '
                        'Esta versão não inicia sessão, não lê a conta e não executa ações dentro do jogo.',
                      )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Module {
  final String title;
  final IconData icon;
  final Widget screen;
  _Module(this.title, this.icon, this.screen);
}

class _StatCard extends StatelessWidget {
  final String title, value, subtitle;
  const _StatCard(this.title, this.value, this.subtitle);

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ]),
    ),
  );
}
