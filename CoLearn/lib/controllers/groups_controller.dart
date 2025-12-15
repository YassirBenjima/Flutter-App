import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:colearn/services/api_service.dart';

class GroupsController extends GetxController {
  var myGroups = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    isLoading.value = true;
    var groups = await ApiService.getGroups();
    
    // Map backend response to UI model if fields differ, or use directly
    // Backend returns: id, name, nextSession, icon, color, inviteLink
    // UI expects: name, members (missing in backend for now, default to 1), nextSession, color (hex string), icon (string name)
    
    myGroups.value = groups.map((g) {
      return {
        "id": g['id'], // Store ID for chat linking
        "name": g['name'],
        "members": g['members'] != null ? (g['members'] as List).length : 1, // Calculate members if list returned
        "nextSession": g['nextSession'],
        "color": _parseColor(g['color']),
        "icon": _parseIcon(g['icon']),
        "inviteLink": g['inviteLink']
      };
    }).toList().cast<Map<String, dynamic>>();
    
    isLoading.value = false;
  }

  // 2. Create Group
  void createGroup(String name, String time) async {
    Get.back(); // Close dialog first or after? Usually before loading.
    
    Get.snackbar("Création...", "Veuillez patienter", showProgressIndicator: true, backgroundColor: Colors.black54, colorText: Colors.white);

    bool success = await ApiService.createGroup(name, time);

    if (success) {
      await fetchGroups(); // Refresh list
      Get.snackbar("Succès", "Le groupe '$name' a été créé !",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Erreur", "Impossible de créer le groupe.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // 3. Join Group
  void joinGroup(String link) async {
    Get.back(); // Close dialog
    
    Get.snackbar("Recherche...", "Tentative de rejoindre...",
        showProgressIndicator: true, backgroundColor: Colors.black54, colorText: Colors.white);

    var joinedGroup = await ApiService.joinGroup(link);

    if (joinedGroup != null) {
      await fetchGroups(); // Refresh
      Get.snackbar("Succès", "Vous avez rejoint: ${joinedGroup['name']}",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Erreur", "Groupe introuvable ou erreur.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Helpers
  Color _parseColor(String? colorStr) {
    if (colorStr == null) return Colors.blue;
    try {
      if (colorStr.startsWith("0x")) {
        return Color(int.parse(colorStr));
      }
      return Colors.blue;
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case "code": return Icons.code;
      case "storage": return Icons.storage;
      case "school": return Icons.school;
      case "flutter_dash": return Icons.flutter_dash;
      case "coffee": return Icons.coffee;
      case "palette": return Icons.palette;
      default: return Icons.group;
    }
  }
}
