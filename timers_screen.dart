import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key});
  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  final _store = StorageService();
  final List<Map<String, dynamic>> _items = [];
  Timer? _ticker;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _load() async {
    final data = await _store.timers();
    if (!mounted) return;
    setState(() { _items..clear()..addAll(data); _loading = false; });
  }

  Future<void> _persist() => _store.saveTimers(_items);

  Future<void> _add() async {
    final name = TextEditingController(text: 'Construção');
    final mins = TextEditingController(text: '60');
    final accepted = await showDialog<bool>(context: context, builder: (ctx) =>
      AlertDialog(title: const Text('Novo temporizador'), content: Column(
        mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Nome')),
          TextField(controller: mins, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Duração (minutos)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Criar')),
        ]));
    final n = int.tryParse(mins.text.trim());
    if (accepted != true || n == null || n < 1 || name.text.trim().isEmpty) return;
    final end = DateTime.now().add(Duration(minutes: n));
    final id = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
    final item = {'id': id, 'name': name.text.trim(), 'end': end.toIso8601String()};
    setState(() => _items.add(item));
    await _persist();
    await NotificationService.instance.schedule(
      id: id, title: 'Temporizador concluído', body: name.text.trim(), when: end);
  }

  String _remaining(DateTime end) {
    final seconds = end.difference(DateTime.now()).inSeconds;
    if (seconds <= 0) return 'Concluído';
    final d = Duration(seconds: seconds);
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _remove(int index) async {
    final id = _items[index]['id'] as int;
    await NotificationService.instance.cancel(id);
    setState(() => _items.removeAt(index));
    await _persist();
  }

  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Temporizadores')),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _add, icon: const Icon(Icons.add), label: const Text('Adicionar')),
    body: _loading ? const Center(child: CircularProgressIndicator())
      : _items.isEmpty ? const Center(child: Text('Nenhum temporizador. Toque em Adicionar.'))
      : ListView.builder(padding: const EdgeInsets.all(16), itemCount: _items.length,
        itemBuilder: (context, i) {
          final item = _items[i];
          final end = DateTime.parse(item['end'] as String);
          final done = !end.isAfter(DateTime.now());
          return Card(child: ListTile(
            leading: Icon(done ? Icons.check_circle : Icons.timer,
              color: done ? Colors.greenAccent : Colors.lightBlueAccent),
            title: Text(item['name'] as String),
            subtitle: Text('Termina ${DateFormat('dd/MM/yyyy HH:mm').format(end)}'),
            trailing: Text(_remaining(end), style: const TextStyle(fontWeight: FontWeight.bold)),
            onLongPress: () => _remove(i),
          ));
        }),
  );
}
