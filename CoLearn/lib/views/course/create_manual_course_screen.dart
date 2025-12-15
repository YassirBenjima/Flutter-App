import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateManualCourseScreen extends StatefulWidget {
  const CreateManualCourseScreen({super.key});

  @override
  State<CreateManualCourseScreen> createState() => _CreateManualCourseScreenState();
}

class _CreateManualCourseScreenState extends State<CreateManualCourseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  // Dropdown values
  String selectedLevel = "Débutant";
  String selectedLanguage = "Français";
  String selectedCategory = "Développement"; // Default

  final List<String> levelOptions = ["Débutant", "Intermédiaire", "Avancé"];
  final List<String> languageOptions = ["Français", "Anglais", "Espagnol", "Arabe"];
  final List<String> categoryOptions = ["Développement", "Data Science", "Design", "Business", "Marketing", "Histoire"];

  // List of Modules
  List<Map<String, String>> modules = [];

  void _addQuiz() {
    TextEditingController titleCtrl = TextEditingController(text: "Quiz: ");
    List<Map<String, dynamic>> tempQuestions = [];

    Get.defaultDialog(
      title: "Créer un Quiz",
      backgroundColor: Colors.grey[900],
      titleStyle: const TextStyle(color: Colors.white),
      content: StatefulBuilder(
        builder: (context, setStateBuilder) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(hintText: "Titre du Quiz", hintStyle: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 15),
                
                // List of Added Questions
                if (tempQuestions.isNotEmpty)
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                    child: ListView.builder(
                      itemCount: tempQuestions.length,
                      itemBuilder: (ctx, idx) => ListTile(
                        dense: true,
                        title: Text("Q${idx+1}: ${tempQuestions[idx]['q']}", style: const TextStyle(color: Colors.white), maxLines: 1),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => setStateBuilder(() => tempQuestions.removeAt(idx)),
                        ),
                      ),
                    ),
                  ),

                ElevatedButton.icon(
                  onPressed: () {
                    _showAddQuestionDialog((newQuestion) {
                      setStateBuilder(() {
                        tempQuestions.add(newQuestion);
                      });
                    });
                  }, 
                  icon: const Icon(Icons.add), 
                  label: const Text("Ajouter une Question")
                ),
              ],
            ),
          );
        }
      ),
      textConfirm: "Sauvegarder le Quiz",
      confirmTextColor: Colors.white,
      buttonColor: Colors.amber[700],
      onConfirm: () {
        if (titleCtrl.text.isNotEmpty && tempQuestions.isNotEmpty) {
          // FORMAT THE QUIZ CONTENT STRING
          String info = "Quiz généré manuellement.\n\n";
          for (int i = 0; i < tempQuestions.length; i++) {
            var q = tempQuestions[i];
            info += "Question ${i+1}: ${q['q']}\n";
            info += "Options: A) ${q['options'][0]}, B) ${q['options'][1]}, C) ${q['options'][2]}, D) ${q['options'][3]}\n";
            info += "Correct Answer: ${['A','B','C','D'][q['correctIndex']]}) ${q['options'][q['correctIndex']]}\n\n";
          }

          setState(() {
            modules.add({
              "title": titleCtrl.text,
              "content": info,
              "videoUrl": "" // No video for quizzes usually
            });
          });
          Get.back();
        } else {
             Get.snackbar("Erreur", "Ajoutez au moins une question", colorText: Colors.white);
        }
      },
      textCancel: "Annuler",
    );
  }

  void _showAddQuestionDialog(Function(Map<String, dynamic>) onSave) {
    TextEditingController qCtrl = TextEditingController();
    TextEditingController opt1 = TextEditingController();
    TextEditingController opt2 = TextEditingController();
    TextEditingController opt3 = TextEditingController();
    TextEditingController opt4 = TextEditingController();
    int correctIndex = 0;

    Get.defaultDialog(
      title: "Ajouter Question",
      backgroundColor: Colors.grey[850],
      content: StatefulBuilder(
        builder: (ctx, setInnerState) {
          return Column(
            children: [
              TextField(controller: qCtrl, decoration: const InputDecoration(hintText: "Question", hintStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              TextField(controller: opt1, decoration: const InputDecoration(hintText: "Option A", hintStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              TextField(controller: opt2, decoration: const InputDecoration(hintText: "Option B", hintStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              TextField(controller: opt3, decoration: const InputDecoration(hintText: "Option C", hintStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              TextField(controller: opt4, decoration: const InputDecoration(hintText: "Option D", hintStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              const Text("Réponse Correcte:", style: TextStyle(color: Colors.white)),
              DropdownButton<int>(
                value: correctIndex,
                dropdownColor: Colors.grey[800],
                items: const [
                  DropdownMenuItem(value: 0, child: Text("Option A", style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 1, child: Text("Option B", style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 2, child: Text("Option C", style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 3, child: Text("Option D", style: TextStyle(color: Colors.white))),
                ],
                onChanged: (val) => setInnerState(() => correctIndex = val!),
              )
            ],
          );
        }
      ),
      textConfirm: "OK",
      onConfirm: () {
        if (qCtrl.text.isNotEmpty && opt1.text.isNotEmpty && opt2.text.isNotEmpty) {
           onSave({
             'q': qCtrl.text,
             'options': [opt1.text, opt2.text, opt3.text, opt4.text],
             'correctIndex': correctIndex
           });
           Get.back();
        }
      }
    );
  }

  void _addModule() {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController contentCtrl = TextEditingController();
    TextEditingController videoCtrl = TextEditingController(); // NEW

    Get.defaultDialog(
      title: "Ajouter un Module",
      backgroundColor: Colors.grey[900],
      titleStyle: const TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: titleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Titre du Module",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: contentCtrl,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Contenu...",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: videoCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Lien YouTube (Oprionnel)",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.video_library, color: Colors.red),
            ),
          ),
        ],
      ),
      textConfirm: "Ajouter",
      confirmTextColor: Colors.white,
      buttonColor: lightBlue,
      onConfirm: () {
        if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
          setState(() {
            modules.add({
              "title": titleCtrl.text,
              "content": contentCtrl.text,
              "videoUrl": videoCtrl.text // Save it
            });
          });
          Get.back();
        }
      },
      textCancel: "Annuler",
    );
  }

  void _submitCourse() async {
    if (_titleController.text.isEmpty || modules.isEmpty) {
      Get.snackbar("Erreur", "Titre et au moins un module requis", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Map<String, dynamic> courseData = {
      "title": _titleController.text,
      "description": _descController.text,
      "level": selectedLevel,
      "language": selectedLanguage == "Français" ? "fr" : (selectedLanguage == "Anglais" ? "en" : selectedLanguage.toLowerCase().substring(0, 2)),
      "category": selectedCategory,
      "modules": modules
    };

    bool unique = await ApiService.createManualCourse(courseData);
    if (unique) {
      Get.back();
      Get.snackbar("Succès", "Cours créé avec succès !", backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Erreur", "Impossible de créer le cours.", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: const Text("Créer un Cours (Manuel)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Titre du cours", _titleController),
            const SizedBox(height: 15),
            _buildTextField("Description", _descController, maxLines: 3),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildDropdown("Niveau", selectedLevel, levelOptions, (val) => setState(() => selectedLevel = val!))),
                const SizedBox(width: 10),
                Expanded(child: _buildDropdown("Langue", selectedLanguage, languageOptions, (val) => setState(() => selectedLanguage = val!))),
              ],
            ),
            const SizedBox(height: 15),
             _buildDropdown("Catégorie", selectedCategory, categoryOptions, (val) => setState(() => selectedCategory = val!)),
             const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Modules", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      onPressed: _addModule, 
                      tooltip: "Ajouter une Leçon",
                      icon: const Icon(Icons.add_circle, color: lightBlue, size: 30)
                    ),
                    IconButton(
                      onPressed: _addQuiz,
                      tooltip: "Ajouter un Quiz", 
                      icon: const Icon(Icons.quiz, color: Colors.amber, size: 30)
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(modules[index]['title']!, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      modules[index]['content']!, 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey)
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          modules.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitCourse,
                style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
                child: const Text("Publier le Cours", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
