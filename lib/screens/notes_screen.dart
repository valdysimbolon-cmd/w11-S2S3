import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/notes_repository.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});
  final _repo = NotesRepository();

  Future<String?> _askTitle(BuildContext context, {String initial = ''}) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial.isEmpty ? 'Catatan baru' : 'Ubah catatan'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tulis catatan'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _repo.watch(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada catatan'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              return ListTile(
                title: Text(d['title'] as String),
                onTap: () async {
                  final title =
                      await _askTitle(context, initial: d['title'] as String);
                  if (title != null && title.isNotEmpty) {
                    await _repo.update(d.id, title);
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _repo.delete(d.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await _askTitle(context);
          if (title != null && title.isNotEmpty) {
            await _repo.add(title);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}