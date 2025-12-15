import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupEventsView extends StatefulWidget {
  final int groupId;
  const GroupEventsView({super.key, required this.groupId});

  @override
  State<GroupEventsView> createState() => _GroupEventsViewState();
}

class _GroupEventsViewState extends State<GroupEventsView> {
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    var res = await ApiService.getGroupEvents(widget.groupId);
    if(mounted) setState(() { events = res; isLoading = false; });
  }

  void _addEvent() {
    final titleCtrl = TextEditingController();
    final linkCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: DateTime.now().toIso8601String());

    Get.defaultDialog(
      title: "Nouvel Événement",
      content: Column(
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: "Titre (ex: Réunion)")),
          TextField(controller: linkCtrl, decoration: const InputDecoration(hintText: "Lien (Zoom/Meet)")),
        ],
      ),
      onConfirm: () async {
        if (titleCtrl.text.isNotEmpty) {
          Get.back();
          await ApiService.addGroupEvent(widget.groupId, titleCtrl.text, linkCtrl.text, timeCtrl.text);
          _fetchEvents();
        }
      },
      textConfirm: "Ajouter",
      textCancel: "Annuler",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        mini: true,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (ctx, i) {
          final e = events[i];
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.orange),
              title: Text(e['title'], style: const TextStyle(color: Colors.white)),
              subtitle: Text(e['startTime'] ?? "Pas d'heure", style: const TextStyle(color: Colors.grey)),
              trailing: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(e['link']);
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
                child: const Text("Rejoindre"),
              ),
            ),
          );
        },
      ),
    );
  }
}
