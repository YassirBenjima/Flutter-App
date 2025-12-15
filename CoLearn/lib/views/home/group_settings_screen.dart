import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> groupDetails;
  const GroupSettingsScreen({super.key, required this.groupDetails});

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  late List<dynamic> members;

  @override
  void initState() {
    super.initState();
    members = widget.groupDetails['members'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Paramètres du Groupe", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
               "Membres (${members.length})", 
               style: const TextStyle(color: lightBlue, fontSize: 18, fontWeight: FontWeight.bold)
             ),
             const SizedBox(height: 10),
             Expanded(
               child: ListView.builder(
                 itemCount: members.length,
                 itemBuilder: (context, index) {
                   final m = members[index];
                   bool isMe = m['id'] == ApiService.currentUser?['id'];

                   return Card(
                     color: Colors.grey[900],
                     child: ListTile(
                       leading: CircleAvatar(child: Text(m['fullName'][0])),
                       title: Text(m['fullName'], style: const TextStyle(color: Colors.white)),
                       trailing: !isMe
                           ? IconButton(
                               icon: const Icon(Icons.delete, color: Colors.red),
                               onPressed: () {
                                 Get.defaultDialog(
                                   title: "Exclure membre ?",
                                   middleText: "Voulez-vous vraiment exclure ${m['fullName']} ?",
                                   textConfirm: "Oui",
                                   textCancel: "Non",
                                   confirmTextColor: Colors.white,
                                   onConfirm: () async {
                                     Get.back();
                                     bool ok = await ApiService.kickMember(
                                       widget.groupDetails['id'], 
                                       m['id'], 
                                       ApiService.currentUser!['id']
                                     );
                                     if (ok) {
                                       setState(() {
                                         members.removeAt(index);
                                       });
                                       Get.snackbar("Succès", "Membre exclu");
                                     }
                                   }
                                 );
                               },
                             )
                           : null,
                     ),
                   );
                 },
               ),
             )
          ],
        ),
      ),
    );
  }
}
