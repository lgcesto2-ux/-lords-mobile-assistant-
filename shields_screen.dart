import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class ShieldsScreen extends StatefulWidget {
  const ShieldsScreen({super.key});
  @override
  State<ShieldsScreen> createState() => _ShieldsScreenState();
}

class _ShieldsScreenState extends State<ShieldsScreen> {
  final _store = StorageService();
  DateTime? _expiry;
  bool _loading = true;
  static const _noticeId = 71001;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final rows = await _store.shields();
    if (rows.isNotEmpty) _expiry = DateTime.tryParse(rows.first['expiry'] as String? ?? '');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _choose() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, firstDate: now,
      lastDate: now.add(const Duration(days: 365)), initialDate: _expiry ?? now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context,
      initialTime: TimeOfDay.fromDateTime(_expiry ?? now.add(const Duration(hours: 24))));
    if (time == null) return;
    final end = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (!end.isAfter(DateTime.now())) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolhe uma data futura.')));
      return;
    }
    setState(() => _expiry = end);
    await _store.saveShields([{'expiry': end.toIso8601String()}]);
    await NotificationService.instance.cancel(_noticeId);
    await NotificationService.instance.schedule(id: _noticeId,
      title: 'Lembrete de escudo', body: 'O horário registado para o escudo chegou.',
      when: end.subtract(const Duration(minutes: 10)).isAfter(DateTime.now())
        ? end.subtract(const Duration(minutes: 10)) : end);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Escudos')),
    body: _loading ? const Center(child: CircularProgressIndicator())
      : Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.shield_outlined, size: 64, color: Colors.lightBlueAccent),
          const SizedBox(height: 16),
          const Text('Fim do escudo registado', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(_expiry == null ? 'Ainda não definido'
            : DateFormat('dd/MM/yyyy – HH:mm').format(_expiry!),
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: _choose, icon: const Icon(Icons.edit_calendar),
            label: const Text('Definir horário')),
          const SizedBox(height: 10),
          const Text('O lembrete é local; não ativa nem renova o escudo no jogo.',
            textAlign: TextAlign.center),
        ]))),
  );
}
