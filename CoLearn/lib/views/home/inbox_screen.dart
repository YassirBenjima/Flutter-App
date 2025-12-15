

import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:colearn/views/home/direct_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Messagerie", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getInbox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 60, color: Colors.grey[700]),
                  const SizedBox(height: 10),
                  Text("Aucun message", style: TextStyle(color: Colors.grey[600]))
                ],
              ),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[800]),
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              var partner = item['partner'];
              var lastMsg = item['lastMessage'];
              // Basic formatting (Java Instant/LocalDateTime might need formatting, lets just show raw or simplified)
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: lightBlue,
                  child: Text(partner['fullName'][0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: Text(partner['fullName'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                   lastMsg, 
                   maxLines: 1, 
                   overflow: TextOverflow.ellipsis,
                   style: const TextStyle(color: Colors.grey)
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Get.to(() => DirectChatScreen(
                    otherUserId: partner['id'], 
                    otherUserName: partner['fullName']
                  ))?.then((_) => setState(() {})); // Refresh on return
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatDialog,
        backgroundColor: lightBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showNewChatDialog() {
    final emailController = TextEditingController();
    Get.defaultDialog(
      title: "Nouveau message",
      content: Column(
        children: [
          const Text("Entrez l'email de l'utilisateur :"),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: "Discuter",
      textCancel: "Annuler",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (emailController.text.isEmpty) return;
        
        Get.back(); // Close dialog
        
        // Show loading
        Get.showSnackbar(const GetSnackBar(
          message: "Recherche en cours...", 
          duration: Duration(seconds: 1),
          showProgressIndicator: true,
        ));

        var user = await ApiService.findUserByEmail(emailController.text.trim());
        
        if (user != null) {
          // Check if it's yourself
          if (user['id'] == ApiService.currentUser?['id']) {
            Get.snackbar("Erreur", "Vous ne pouvez pas vous écrire à vous-même.", backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }

          Get.to(() => DirectChatScreen(
            otherUserId: user['id'],
            otherUserName: user['fullName'],
          ))?.then((_) => setState(() {})); 
        } else {
          Get.snackbar("Introuvable", "Aucun utilisateur trouvé avec cet email.", backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    );
  }
}
