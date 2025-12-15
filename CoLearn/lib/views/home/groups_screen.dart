import 'package:colearn/consts/consts.dart';
import 'package:colearn/controllers/groups_controller.dart';
import 'package:colearn/views/home/group_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupsController());

    // Dialog Logic
    final nameController = TextEditingController();
    final timeController = TextEditingController();

    void showCreateDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Créer un nouveau groupe", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: "Nom",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
              ),
              TextField(
                controller: timeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: "Session (ex: Mar 10h)",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Annuler", style: TextStyle(color: Colors.red))),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  controller.createGroup(nameController.text, timeController.text);
                  nameController.clear();
                  timeController.clear();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
              child: const Text("Créer"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mes Groupes", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // JOIN BUTTON
          TextButton.icon(
            onPressed: () {
              final linkController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text("Rejoindre un groupe", style: TextStyle(color: Colors.white)),
                  content: TextField(
                    controller: linkController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "colearn.app/join/...",
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (linkController.text.isNotEmpty) controller.joinGroup(linkController.text);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
                      child: const Text("Rejoindre"),
                    )
                  ],
                ),
              );
            },
            icon: const Icon(Icons.link, color: lightBlue),
            label: const Text("Rejoindre", style: TextStyle(color: lightBlue)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCreateDialog,
        backgroundColor: lightBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Créer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vos Groupes Actifs", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.myGroups.length,
                itemBuilder: (context, index) {
                  final group = controller.myGroups[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: group['color'].withOpacity(0.2),
                        child: Icon(group['icon'], color: group['color'], size: 24),
                      ),
                      title: Text(group['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text("${group['members']} membres • ${group['nextSession']}", style: TextStyle(color: Colors.grey[400], fontSize: 12)),

                      // 1. SHARE ICON (Copies THIS group's link)
                      trailing: IconButton(
                        icon: const Icon(Icons.share, color: lightBlue),
                        onPressed: () {
                          String link = group['inviteLink'] ?? "colearn.app/join/generic";
                          Clipboard.setData(ClipboardData(text: link));
                          Get.snackbar("Lien copié !", link, backgroundColor: Colors.blueGrey, colorText: Colors.white);
                        },
                      ),

                      // 2. TAP TO OPEN DETAILS (Tabs)
                      onTap: () {
                        Get.to(() => GroupDetailsScreen(
                          groupId: group['id'], 
                          groupName: group['name']
                        ));
                      },
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}