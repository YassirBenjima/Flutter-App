import 'package:colearn/consts/consts.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // REQUIRED for kIsWeb

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> users = [];
  bool isLoading = true;

  // 1. DYNAMIC URL HELPER
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth'; // For Web
    } else {
      return 'http://10.0.2.2:8080/api/auth'; // For Android Emulator
    }
  }

  // Fetch users from Spring Boot
  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users'); // Uses the helper above

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e"); // Check console for this
      Get.snackbar("Error", "Could not load users. Check Server.");
      setState(() => isLoading = false);
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/users/$id'); // Uses the helper above
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "User deleted");
        fetchUsers(); // Refresh list
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // ... Keep your existing build code ...
    // (The Scaffold, AppBar, and Body remain exactly the same)
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAll(() => const LoginScreen()),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gestion des Utilisateurs",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Check if list is empty
            users.isEmpty
                ? const Text("No users found.")
                : Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(user['fullName'] != null ? user['fullName'][0].toUpperCase() : "?"),
                      ),
                      title: Text(user['fullName'] ?? "Unknown"),
                      subtitle: Text("${user['email']} • ${user['role'] ?? 'N/A'}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteUser(user['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}