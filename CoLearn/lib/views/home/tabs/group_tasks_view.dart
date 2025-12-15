import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupTasksView extends StatefulWidget {
  final int groupId;
  const GroupTasksView({super.key, required this.groupId});

  @override
  State<GroupTasksView> createState() => _GroupTasksViewState();
}

class _GroupTasksViewState extends State<GroupTasksView> {
  List<dynamic> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    var res = await ApiService.getGroupTasks(widget.groupId);
    if(mounted) setState(() { tasks = res; isLoading = false; });
  }

  void _addTask() {
    final controller = TextEditingController();
    Get.defaultDialog(
      title: "Nouvelle Tâche",
      content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Titre de la tâche")),
      onConfirm: () async {
        if (controller.text.isNotEmpty) {
          Get.back();
          await ApiService.addGroupTask(widget.groupId, controller.text);
          _fetchTasks();
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
        onPressed: _addTask,
        mini: true,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, i) {
          final t = tasks[i];
          bool isDone = t['status'] == 'DONE';
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              leading: Checkbox(
                value: isDone,
                onChanged: (val) async {
                  await ApiService.updateTaskStatus(t['id'], val == true ? 'DONE' : 'TODO');
                  _fetchTasks();
                },
                activeColor: Colors.blue,
              ),
              title: Text(t['title'], style: TextStyle(
                color: Colors.white,
                decoration: isDone ? TextDecoration.lineThrough : null
              )),
              subtitle: Text(t['status'], style: const TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
