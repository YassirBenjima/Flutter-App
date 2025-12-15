import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'course_details_screen.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final TextEditingController _topicController = TextEditingController();

  // Default values
  String selectedLevel = "Débutant";
  String selectedLanguage = "fr";

  // Loading state variables
  bool _isGenerating = false;
  String _loadingText = "";

  // The Logic
  Future<void> _handleGenerate() async {
    if (_topicController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez entrer un sujet (ex: Python)", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() {
      _isGenerating = true;
      _loadingText = "Initialisation de l'IA...";
    });

    try {
      // 1. Simulate "AI Thinking" (The Wow Factor)
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _loadingText = "Analyse du sujet '${_topicController.text}'...");

      await Future.delayed(const Duration(seconds: 1));
      setState(() => _loadingText = "Structuration des modules...");

      await Future.delayed(const Duration(seconds: 1));
      setState(() => _loadingText = "Rédaction du contenu pédagogique...");

      // 2. Call Real Backend
      final courseData = await ApiService.generateCourse(
          _topicController.text,
          selectedLevel,
          selectedLanguage
      );

      // 3. Navigate to Result
      Get.off(() => CourseDetailsScreen(courseData: courseData));

    } catch (e) {
      Get.snackbar("Erreur", "La génération a échoué. Vérifiez votre serveur Spring Boot.", backgroundColor: Colors.red, colorText: Colors.white);
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Générateur IA", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isGenerating
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // A nice spinner
              const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(color: lightBlue, strokeWidth: 3),
              ),
              const SizedBox(height: 30),
              // Changing text
              Text(
                _loadingText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Que voulez-vous apprendre ?",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Notre IA va créer un cours complet, adapté à votre niveau, en quelques secondes.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // INPUT: Topic
              const Text("Sujet du cours", style: TextStyle(color: lightBlue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ex: Intelligence Artificielle, Yoga, Marketing...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),

              // INPUT: Options Row
              Row(
                children: [
                  // LEVEL Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Niveau", style: TextStyle(color: lightBlue, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLevel,
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              items: ["Débutant", "Intermédiaire", "Expert"]
                                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                                  .toList(),
                              onChanged: (v) => setState(() => selectedLevel = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // LANGUAGE Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Langue", style: TextStyle(color: lightBlue, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLanguage,
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: "fr", child: Text("Français 🇫🇷")),
                                DropdownMenuItem(value: "en", child: Text("English 🇺🇸")),
                              ],
                              onChanged: (v) => setState(() => selectedLanguage = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // GENERATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _handleGenerate,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: const Text("Générer le Cours", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}