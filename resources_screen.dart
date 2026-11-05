import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});
  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  static const names = ['Comida', 'Madeira', 'Pedra', 'Minério', 'Ouro'];
  final _store = StorageService();
  final Map<String, TextEditingController> _controllers = {
    for (final name in names) name: TextEditingController(),
  };
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final rows = await _store.resources();
    for (final row in rows) {
      final key = row['name'] as String?;
      if (_controllers.containsKey(key)) _controllers[key]!.text = '${row['value'] ?? ''}';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final rows = _controllers.entries.map((e) =>
      {'name': e.key, 'value': e.value.text.trim()}).toList();
    await _store.saveResources(rows);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recursos guardados neste dispositivo.')));
  }

  @override
  void dispose() { for (final c in _controllers.values) { c.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Recursos')),
    body: _loading ? const Center(child: CircularProgressIndicator())
      : ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Introduz os valores que aparecem no jogo.'),
        const SizedBox(height: 14),
        for (final name in names) Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(controller: _controllers[name],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: name, suffixText: 'unidades',
              border: const OutlineInputBorder())),
        ),
        FilledButton.icon(onPressed: _save,
          icon: const Icon(Icons.save_outlined), label: const Text('Guardar')),
      ]),
  );
}
