
import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Classement 🏆", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("Aucun classement disponible", style: TextStyle(color: Colors.grey)));
          }

          var users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
               var user = users[index];
               int rank = index + 1;
               bool isMe = user['id'] == ApiService.currentUser?['id'];

               Color rankColor = Colors.white;
               if (rank == 1) rankColor = Colors.amber;
               if (rank == 2) rankColor = Colors.grey[300]!;
               if (rank == 3) rankColor = Colors.brown[300]!;

               return Card(
                 color: isMe ? lightBlue.withOpacity(0.2) : Colors.grey[900],
                 margin: const EdgeInsets.only(bottom: 12),
                 child: ListTile(
                   leading: CircleAvatar(
                      backgroundColor: rankColor.withOpacity(0.2),
                      child: Text("#$rank", style: TextStyle(color: rankColor, fontWeight: FontWeight.bold)),
                   ),
                   title: Text(
                     user['fullName'] ?? "Utilisateur", 
                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                   ),
                   subtitle: Row(
                     children: [
                       // Display Badges
                       ...(user['badges'] as List).map((badge) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(badge, style: const TextStyle(fontSize: 12)),
                       )),
                     ],
                   ),
                   trailing: Text(
                     "${user['xp']} XP", 
                     style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)
                   ),
                 ),
               );
            },
          );
        },
      ),
    );
  }
}
