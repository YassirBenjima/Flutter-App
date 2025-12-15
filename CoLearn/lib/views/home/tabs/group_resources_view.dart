import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupResourcesView extends StatefulWidget {
  final int groupId;
  const GroupResourcesView({super.key, required this.groupId});

  @override
  State<GroupResourcesView> createState() => _GroupResourcesViewState();
}

class _GroupResourcesViewState extends State<GroupResourcesView> {
  List<dynamic> resources = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    var res = await ApiService.getGroupResources(widget.groupId);
    if(mounted) setState(() { resources = res; isLoading = false; });
  }

  void _add() {
    final titleCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    Get.defaultDialog(
      title: "Ajouter Ressource",
      content: Column(
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: "Titre")),
          TextField(controller: urlCtrl, decoration: const InputDecoration(hintText: "URL (Drive, PDF...)")),
        ],
      ),
      onConfirm: () async {
        if (titleCtrl.text.isNotEmpty && urlCtrl.text.isNotEmpty) {
          Get.back();
          await ApiService.addGroupResource(widget.groupId, titleCtrl.text, urlCtrl.text);
          _fetch();
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
        onPressed: _add,
        mini: true,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (ctx, i) {
          final r = resources[i];
          IconData icon = Icons.link;
          if (r['type'] == 'PDF') icon = Icons.picture_as_pdf;
          
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              leading: Icon(icon, color: Colors.green),
              title: Text(r['title'], style: const TextStyle(color: Colors.white)),
              subtitle: Text(r['url'], style: const TextStyle(color: Colors.grey)),
              onTap: () async {
                final uri = Uri.parse(r['url']);
                if (await canLaunchUrl(uri)) launchUrl(uri);
              },
            ),
          );
        },
      ),
    );
  }
}
