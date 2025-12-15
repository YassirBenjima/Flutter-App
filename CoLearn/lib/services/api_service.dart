import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For kIsWeb check

class ApiService {
  // 1. IP CONFIGURATION
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth';
    } else {
      // Android Emulator IP
      return 'http://10.0.2.2:8080/api/auth';
    }
  }

  // --- CURRENT USER STORAGE ---
  static Map<String, dynamic>? currentUser;

  // --- AUTHENTICATION ---

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String expertiseLevel,
    required String learningStyle,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'role': role,
          'expertiseLevel': expertiseLevel,
          'learningStyle': learningStyle,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        currentUser = data; // Store user
        return data;
      } else {
        throw Exception('Erreur Inscription (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        currentUser = data; // Store logged in user
        return data;
      } else {
        throw Exception('Erreur Connexion: Vérifiez vos identifiants');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<bool> updateProfile(int id, String fullName, String password) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/users/$id');
      print("✏️ Updating Profile ID: $id at $url");

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
         Map<String, dynamic> updatedUser = json.decode(utf8.decode(response.bodyBytes));
         // Update local session
         if (currentUser != null) {
            currentUser!['fullName'] = updatedUser['fullName'] ?? fullName;
            // Don't store password locally
         }
         return true;
      } else {
         return false;
      }
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
  
  // --- ADMIN METHODS ---

  static Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur chargement utilisateurs');
      }
    } catch (e) {
      throw Exception('Erreur Admin: $e');
    }
  }

  static Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur suppression: $e');
    }
  }

  // --- AI COURSE GENERATOR & COURSES ---

  static Future<Map<String, dynamic>> generateCourse(String topic, String level, String language) async {
    try {
      if (currentUser == null) throw Exception("User not logged in");
      String url = baseUrl.replaceAll('/auth', '/courses/generate');
      print("✨ Generating course at: $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'topic': topic,
          'level': level,
          'language': language,
          'userId': currentUser!['id']
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("Generation failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<List<dynamic>> getMyCourses() async {
    try {
      if (currentUser == null) return [];
      String url = baseUrl.replaceAll('/auth', '/courses?userId=${currentUser!['id']}');
      print("🔍 Fetching courses from: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

  // --- UNLOCK MODULE (Fixed: Returns bool to confirm success) ---
  static Future<bool> unlockModule(int moduleId) async {
    try {
      // 1. Build URL
      String url = baseUrl.replaceAll('/auth', '/courses/modules/$moduleId/unlock');
      print("🔓 Unlocking Module ID: $moduleId at $url");

      // 2. Send PUT Request
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // 3. Return True if Success
      if (response.statusCode == 200) {
        print("✅ SUCCESS: Module saved as unlocked in DB.");
        return true;
      } else {
        print("❌ ERROR: Server rejected save. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ EXCEPTION during save: $e");
      return false;
    }
  }

  static Future<bool> completeCourse(int courseId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/courses/$courseId/complete');
      print("🏆 Completing Course ID: $courseId at $url");

      final response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        print("✅ SUCCESS: Course marked as completed.");
        return true;
      } else {
        print("❌ ERROR: Failed to mark course complete.");
        return false;
      }
    } catch (e) {
      print("❌ EXCEPTION during course complete: $e");
      return false;
    }
  }

  // --- CHAT SYSTEM ---

  static Future<List<dynamic>> getMessages(String groupName) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/chat/$groupName');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  static Future<void> sendMessage(String sender, String content, String groupName) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/chat');
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': sender,
          'content': content,
          'groupName': groupName
        }),
      );
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // --- GROUPS SYSTEM ---

  static Future<bool> createGroup(String name, String nextSession) async {
    try {
      if (currentUser == null) return false;
      String url = baseUrl.replaceAll('/auth', '/groups/create');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'nextSession': nextSession,
          'userId': currentUser!['id']
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error creating group: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> joinGroup(String inviteLink) async {
    try {
      if (currentUser == null) return null;
      String url = baseUrl.replaceAll('/auth', '/groups/join');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'inviteLink': inviteLink,
          'userId': currentUser!['id']
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print("Error joining group: $e");
      return null;
    }
  }

  static Future<List<dynamic>> getGroups() async {
    try {
      if (currentUser == null) return [];
      String url = baseUrl.replaceAll('/auth', '/groups?userId=${currentUser!['id']}');
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return [];
    } catch (e) {
      print("Error fetching groups: $e");
      return [];
    }
  }

  // --- PASSWORD RESET ---

  static Future<void> requestPasswordReset({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (response.statusCode != 200) throw Exception("Erreur demande");
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  static Future<void> verifyResetCode({required String email, required String code}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code}),
      );
      if (response.statusCode != 200) throw Exception('Code invalide');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  static Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/confirm-reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code, 'newPassword': newPassword}),
      );
      if (response.statusCode != 200) throw Exception('Échec reset');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // --- GOOGLE OAUTH ---

  static Future<Map<String, dynamic>> loginWithGoogle({required String idToken}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/oauth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur Google Auth');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  // --- INSTRUCTOR FEATURES ---

  static Future<List<dynamic>> getInstructorCourses() async {
    try {
      String url = baseUrl.replaceAll('/auth', '/courses/instructor');
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return [];
    } catch (e) {
      print("Error fetching instructor courses: $e");
      return [];
    }
  }

  static Future<bool> createManualCourse(Map<String, dynamic> courseData) async {
    try {
      if (currentUser == null) return false;
      
      String url = baseUrl.replaceAll('/auth', '/courses/manual');
      
      // Inject userId
      courseData['userId'] = currentUser!['id'];

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(courseData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error creating manual course: $e");
      return false;
    }
  }

  // --- ENROLLMENT ---
  static Future<Map<String, dynamic>?> enrollCourse(int courseId) async {
    try {
      if (currentUser == null) return null;
      
      String url = baseUrl.replaceAll('/auth', '/courses/$courseId/enroll');
      print("🎓 Enrolling in Course ID: $courseId");

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': currentUser!['id']}),
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        print("Failed to enroll: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error enrolling in course: $e");
      return null;
    }
  }

  // --- DELETE COURSE ---
  static Future<bool> deleteCourse(int courseId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/courses/$courseId');
      final response = await http.delete(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting course: $e");
      return false;
    }
  }

  // --- SEARCH COURSES ---
  static Future<List<dynamic>> searchCourses(String query) async {
    try {
      if (query.isEmpty) return [];
      String url = baseUrl.replaceAll('/auth', '/courses/search?query=$query');
      print("Searching: $url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        return json.decode(body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error searching courses: $e");
      return [];
    }
  }

  // --- COMMENTS ---
  static Future<List<dynamic>> getComments(int courseId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/comments/course/$courseId');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
         return json.decode(utf8.decode(response.bodyBytes));
      }
      return [];
    } catch (e) {
      print("Error fetching comments: $e");
      return [];
    }
  }

  static Future<bool> addComment(int courseId, String content) async {
    try {
      if (currentUser == null) return false;
      String url = baseUrl.replaceAll('/auth', '/comments/course/$courseId');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': currentUser!['id'],
          'content': content
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error adding comment: $e");
      return false;
    }
  }

  // --- MESSAGING ---
  static Future<List<dynamic>> getConversation(int otherUserId) async {
    try {
      if (currentUser == null) return [];
      String url = baseUrl.replaceAll('/auth', '/messages/conversation?user1=${currentUser!['id']}&user2=$otherUserId');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
         return json.decode(utf8.decode(response.bodyBytes));
      }
      return [];
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  static Future<bool> sendDirectMessage(int receiverId, String content) async {
    try {
      if (currentUser == null) return false;
      String url = baseUrl.replaceAll('/auth', '/messages');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderId': currentUser!['id'],
          'receiverId': receiverId,
          'content': content
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error sending message: $e");
      return false;
    }
  }

  static Future<List<dynamic>> getInbox() async {
    try {
      if (currentUser == null) return [];
      String url = baseUrl.replaceAll('/auth', '/messages/inbox/${currentUser!['id']}');
      print("📬 GET Inbox: $url");
      final response = await http.get(Uri.parse(url));
      print("📬 Inbox Status: ${response.statusCode}");
      if (response.statusCode == 200) {
         var data = json.decode(utf8.decode(response.bodyBytes));
         print("📬 Inbox Data Count: ${(data as List).length}");
         return data;
      }
      print("📬 Failed Inbox Body: ${response.body}");
      return [];
    } catch (e) {
      print("❌ Error fetching inbox: $e");
      return [];
    }
  }

  // --- RATING ---
  static Future<double?> rateCourse(int courseId, double rating) async {
    try {
      if (currentUser == null) return null;
      String url = baseUrl.replaceAll('/auth', '/courses/$courseId/rate');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rating': rating}),
      );

      if (response.statusCode == 200) {
         var data = json.decode(response.body);
         return data['newAverage'];
      }
      return null;
    } catch (e) {
      print("Error rating course: $e");
    }
  }

  // --- GAMIFICATION / LEADERBOARD ---
  static Future<List<dynamic>> getLeaderboard() async {
    try {
      String url = baseUrl.replaceAll('/auth', '/leaderboard');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching leaderboard: $e");
      return [];
    }
  }
  static Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/users/lookup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error searching user: $e");
      return null;
    }
  }

  // --- GROUP FEATURES (Tasks, Events, Resources, Admin) ---

  // ADMIN
  static Future<Map<String, dynamic>?> getGroupDetails(int groupId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/details');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error fetching group details: $e");
      return null;
    }
  }

  static Future<bool> kickMember(int groupId, int userId, int adminId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/kick');
      final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'adminId': adminId, 'userId': userId})
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error kicking member: $e");
      return false;
    }
  }

  // TASKS
  static Future<List<dynamic>> getGroupTasks(int groupId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/tasks');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return jsonDecode(utf8.decode(response.bodyBytes));
      return [];
    } catch (e) { return []; }
  }

  static Future<bool> addGroupTask(int groupId, String title) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/tasks');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title})
      );
      return response.statusCode == 200;
    } catch (e) { return false; }
  }

  static Future<bool> updateTaskStatus(int taskId, String status) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/tasks/$taskId');
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status})
      );
      return response.statusCode == 200;
    } catch (e) { return false; }
  }

  // EVENTS
  static Future<List<dynamic>> getGroupEvents(int groupId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/events');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return jsonDecode(utf8.decode(response.bodyBytes));
      return [];
    } catch (e) { return []; }
  }

  static Future<bool> addGroupEvent(int groupId, String title, String link, String startTime) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/events');
      final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'link': link,
            'startTime': startTime // ISO 8601 string
          })
      );
      return response.statusCode == 200;
    } catch (e) { return false; }
  }

  // RESOURCES
  static Future<List<dynamic>> getGroupResources(int groupId) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/resources');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return jsonDecode(utf8.decode(response.bodyBytes));
      return [];
    } catch (e) { return []; }
  }

  static Future<bool> addGroupResource(int groupId, String title, String urlLink) async {
    try {
      String url = baseUrl.replaceAll('/auth', '/groups/$groupId/resources');
      final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'url': urlLink,
            'type': 'LINK'
          })
      );
      return response.statusCode == 200;
    } catch (e) { return false; }
  }
}