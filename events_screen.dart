import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _store = StorageService();
  final List<Map<String, dynamic>> _events = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final rows = await _store.events();
    if (!mounted) return;
    setState(() { _events..clear()..addAll(rows); _loading = false; });
  }

  Future<void> _add() async {
    final name = TextEditingController();
    final date = await showDatePicker(context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDate: DateTime.now());
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0));
    if (time == null || !mounted) return;
    final ok = await showDialog<bool>(context: context, builder: (ctx) =>
      AlertDialog(title: const Text('Nome do evento'),
        content: TextField(controller: name, autofocus: true,
          decoration: const InputDecoration(hintText: 'Ex.: evento da guilda')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Guardar')),
        ]));
    if (ok != true || name.text.trim().isEmpty) return;
    final start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final id = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
    setState(() => _events.add({'id': id, 'name': name.text.trim(), 'start': start.toIso8601String()}));
    await _store.saveEvents(_events);
    await NotificationService.instance.schedule(id: id, title: 'Evento registado',
      body: name.text.trim(), when: start);
  }

  Future<void> _remove(int index) async {
    await NotificationService.instance.cancel(_events[index]['id'] as int);
    setState(() => _events.removeAt(index));
    await _store.saveEvents(_events);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Calendário de eventos')),
    floatingActionButton: FloatingActionButton.extended(onPressed: _add,
      icon: const Icon(Icons.add), label: const Text('Evento')),
    body: _loading ? const Center(child: CircularProgressIndicator())
      : _events.isEmpty ? const Center(child: Text('Ainda não há eventos registados.'))
      : ListView.builder(padding: const EdgeInsets.all(16), itemCount: _events.length,
        itemBuilder: (context, i) {
          final e = _events[i];
          final start = DateTime.parse(e['start'] as String);
          return Card(child: ListTile(
            leading: const Icon(Icons.event, color: Colors.lightBlueAccent),
            title: Text(e['name'] as String),
            subtitle: Text(DateFormat('dd/MM/yyyy – HH:mm').format(start)),
            onLongPress: () => _remove(i),
          ));
        }),
  );
}
