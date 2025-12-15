import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:colearn/views/course/create_course_screen.dart';
import 'package:colearn/views/home/groups_screen.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ CORRECT IMPORT (Only one)
// Removed invalid import

import 'package:colearn/views/course/create_manual_course_screen.dart';

import '../course/course_details_screen.dart';

import 'package:colearn/views/profile/leaderboard_screen.dart'; // NEW IMPORT
import 'package:colearn/views/home/inbox_screen.dart'; // Add import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        title: Text(
          "CoLearn",
          style: TextStyle(
            color: lightBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const GroupsScreen());
            },
            icon: Icon(Icons.groups_outlined, color: whiteColor),
            tooltip: "Mes Groupes",
          ),
          IconButton(
            onPressed: () {
               Get.to(() => const InboxScreen());
            }, 
            icon: Icon(Icons.mail_outline, color: whiteColor),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.person_outline, color: whiteColor),
            color: darkFontGrey,
            onSelected: (value) {
              if (value == 'leaderboard') {
                Get.to(() => const LeaderboardScreen());
              } else if (value == 'profile') {
                setState(() {
                  _currentIndex = 3; // Switch to Profile tab
                });
              } else if (value == 'logout') {
                ApiService.currentUser = null;
                Get.offAll(() => const LoginScreen());
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'leaderboard', // NEW ITEM
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber),
                      SizedBox(width: 10),
                      Text("Classement 🏆", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Profil", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Se déconnecter", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      // --- MAGIC BUTTON ---
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CreateCourseScreen());
        },
        backgroundColor: lightBlue,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text("Générer Cours IA",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null,

      body: _getBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkFontGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: darkFontGrey,
          selectedItemColor: lightBlue,
          unselectedItemColor: fontGrey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Cours',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildSearchTab();
      case 2:
        return _buildCoursesTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  String selectedCategory = "Tout"; // Default "Tout" or null
  final List<Map<String, dynamic>> categories = [
    {"title": "Tout", "icon": Icons.category, "color": Colors.grey},
    {"title": "Développement", "icon": Icons.code, "color": Colors.blue},
    {"title": "Data Science", "icon": Icons.analytics, "color": Colors.purple},
    {"title": "Design", "icon": Icons.palette, "color": Colors.orange},
    {"title": "Business", "icon": Icons.business, "color": Colors.green},
    {"title": "Marketing", "icon": Icons.campaign, "color": Colors.redAccent},
    {"title": "Histoire", "icon": Icons.history_edu, "color": Colors.brown},
  ];

  // --- HOME TAB ---
  Widget _buildHomeTab() {
    bool isInstructor = (ApiService.currentUser?['role']?.toString().toUpperCase() ?? '') == 'FORMATEUR';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightBlue.withOpacity(0.1), lightBlue.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: lightBlue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenue sur CoLearn",
                  style: TextStyle(color: whiteColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  isInstructor 
                    ? "Gérez vos cours et créez du contenu."
                    : "Découvrez de nouveaux cours et développez vos compétences",
                  style: TextStyle(color: fontGrey, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // INSTRUCTOR DASHBOARD vs STUDENT VIEW
          if (isInstructor) ...[
             Text(
              "Tableau de bord Formateur",
              style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                 Get.to(() => const CreateManualCourseScreen());
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Créer un Nouveau Cours", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
             Text(
              "Vos cours publiés",
              style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Vos cours publiés", style: TextStyle(color: fontGrey)),
            const SizedBox(height: 10),
            
            FutureBuilder<List<dynamic>>(
              future: ApiService.getMyCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Vous n'avez pas encore publié de cours.", style: TextStyle(color: fontGrey));
                }

                return Column(
                  children: snapshot.data!.map((course) {
                    return _buildCourseItem(course, onDelete: () {
                       Get.defaultDialog(
                          title: "Supprimer le cours ?",
                          middleText: "Cette action est irréversible.\nTout le contenu sera perdu.",
                          backgroundColor: Colors.grey[900],
                          titleStyle: const TextStyle(color: Colors.white),
                          middleTextStyle: const TextStyle(color: Colors.white70),
                          textConfirm: "Supprimer",
                          textCancel: "Annuler",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () async {
                            bool success = await ApiService.deleteCourse(course['id']);
                            Get.back(); // Close Dialog
                            if (success) {
                              Get.snackbar("Succès", "Cours supprimé", backgroundColor: Colors.green, colorText: Colors.white);
                              setState(() {}); // Refresh List
                            } else {
                              Get.snackbar("Erreur", "Échec de la suppression", backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          }
                       );
                    });
                  }).toList(),
                );
              },
            ),

          ] else ...[
             // Categories Section (For filtering)
             Text(
              "Catégories",
              style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  bool isSelected = selectedCategory == cat['title'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                         if (isSelected) {
                           selectedCategory = "Tout";
                         } else {
                           selectedCategory = cat['title'];
                         }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? lightBlue : darkFontGrey,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? lightBlue : whiteColor.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(cat['icon'], color: isSelected ? Colors.white : cat['color'], size: 20), // Smaller icon
                          const SizedBox(width: 8),
                          Text(
                            cat['title'], 
                            style: TextStyle(
                              color: isSelected ? Colors.white : fontGrey, 
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 30),

             Text(
              "Cours du Professeurs",
              style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            // DYNAMIC INSTRUCTOR COURSES
            FutureBuilder<List<dynamic>>(
              future: ApiService.getInstructorCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucun cours disponible pour le moment.", style: TextStyle(color: fontGrey));
                }
                
                // FILTERING LOGIC
                List<dynamic> courses = snapshot.data!;
                if (selectedCategory != "Tout") {
                  courses = courses.where((c) => c['category'] == selectedCategory).toList();
                }

                if (courses.isEmpty) {
                   return Text("Aucun cours dans cette catégorie.", style: TextStyle(color: fontGrey));
                }

                return Column(
                  children: courses.map((course) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: _buildCourseCard(
                        title: course['title'] ?? "Cours",
                        instructor: (course['creator'] != null && course['creator']['fullName'] != null) 
                            ? course['creator']['fullName'] 
                            : "Formateur Inconnu", 
                        // REAL STATS
                        rating: (course['averageRating'] != null && course['averageRating'] > 0) 
                            ? double.parse(course['averageRating'].toString()) 
                            : 5.0, // Default to 5.0 if new
                        students: course['enrolledCount'] ?? 0, 
                        price: "Gratuit",
                        image: "assets/images/course1.jpg", 
                        onTap: () async {
                           // ENROLLMENT LOGIC
                           Get.snackbar("Inscription", "Ajout du cours à votre espace...", backgroundColor: Colors.blue, colorText: Colors.white);
                           
                           var newCourse = await ApiService.enrollCourse(course['id']);
                           
                           if (newCourse != null) {
                               Get.snackbar("Succès", "Cours ajouté !", backgroundColor: Colors.green, colorText: Colors.white);
                               // Navigate to the NEW (cloned) course
                               Get.to(() => CourseDetailsScreen(courseData: newCourse));
                               // Refresh UI to show it in "Mes Cours"
                               setState(() {});
                           } else {
                               Get.snackbar("Erreur", "Impossible de rejoindre le cours", backgroundColor: Colors.red, colorText: Colors.white);
                           }
                        }
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String instructor,
    required double rating,
    required int students,
    required String price,
    required String image,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: darkFontGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: whiteColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: lightBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.play_circle_outline, color: lightBlue, size: 40),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(instructor, style: TextStyle(color: fontGrey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: golden, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toString(), style: TextStyle(color: whiteColor, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text("($students étudiants)", style: TextStyle(color: fontGrey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(price, style: TextStyle(color: lightBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("Commencer", style: TextStyle(color: whiteColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({required String title, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkFontGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whiteColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- SEARCH TAB ---
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isSearching = false;

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: darkFontGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: whiteColor.withOpacity(0.1)),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: whiteColor),
              onSubmitted: (value) async {
                  if (value.trim().isEmpty) return;
                  setState(() => isSearching = true);
                  var results = await ApiService.searchCourses(value);
                  setState(() {
                    searchResults = results;
                    isSearching = false;
                  });
              },
              decoration: InputDecoration(
                hintText: "Rechercher des cours...",
                hintStyle: TextStyle(color: fontGrey),
                prefixIcon: Icon(Icons.search, color: fontGrey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchResults = []);
                  },
                )
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isSearching 
              ? const Center(child: CircularProgressIndicator())
              : searchResults.isEmpty
                ? Center(
                    child: Text(
                      searchController.text.isEmpty 
                        ? "Recherchez des cours par titre" 
                        : "Aucun résultat trouvé",
                      style: TextStyle(color: fontGrey, fontSize: 16)
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return _buildCourseItem(searchResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- MY COURSES TAB (Dynamic) ---
  Widget _buildCoursesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mes cours", style: TextStyle(color: whiteColor, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.getMyCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: lightBlue));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur de chargement", style: TextStyle(color: fontGrey)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, color: fontGrey, size: 80),
                        const SizedBox(height: 20),
                        Text("Aucun cours généré", style: TextStyle(color: fontGrey, fontSize: 18)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const CreateCourseScreen());
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
                          child: const Text("Générer mon premier cours", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                }

                // --- FILTER LOGIC ---
                final courses = snapshot.data!;
                final activeCourses = courses.where((c) => c['completed'] != true).toList();
                final completedCourses = courses.where((c) => c['completed'] == true).toList();

                return ListView(
                  children: [
                    // --- SECTION: EN COURS ---
                    if (activeCourses.isNotEmpty) ...[
                      Text("En cours", style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...activeCourses.map((course) => _buildCourseItem(
                        course, 
                        onDelete: () {
                           // UNENROLL / DELETE ACTION
                           Get.defaultDialog(
                             title: "Désinscription",
                             middleText: "Voulez-vous vraiment retirer ce cours de votre liste ?",
                             confirm: ElevatedButton(
                               onPressed: () async {
                                 Get.back(); // Close
                                 bool success = await ApiService.deleteCourse(course['id']);
                                 if (success) {
                                    setState(() {}); // Refresh list
                                    Get.snackbar("Succès", "Cours retiré", backgroundColor: Colors.green, colorText: Colors.white);
                                 } else {
                                    Get.snackbar("Erreur", "Impossible de supprimer", backgroundColor: Colors.red, colorText: Colors.white);
                                 }
                               },
                               style: ElevatedButton.styleFrom(backgroundColor: Colors.red), 
                               child: const Text("Oui, retirer", style: TextStyle(color: Colors.white))
                             ),
                             cancel: TextButton(onPressed: () => Get.back(), child: const Text("Annuler"))
                           );
                        }
                      )).toList(),
                      const SizedBox(height: 20),
                    ],

                    // --- SECTION: TERMINÉS ---
                    if (completedCourses.isNotEmpty) ...[
                      Text("Terminés", style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...completedCourses.map((course) => _buildCourseItem(
                        course, 
                        isCompleted: true,
                        onDelete: () {
                           // DELETE COMPLETED COURSE
                           Get.defaultDialog(
                             title: "Suppression",
                             middleText: "Voulez-vous supprimer ce cours terminé ?",
                             confirm: ElevatedButton(
                               onPressed: () async {
                                 Get.back();
                                 bool success = await ApiService.deleteCourse(course['id']);
                                 if (success) {
                                    setState(() {});
                                    Get.snackbar("Succès", "Cours supprimé", backgroundColor: Colors.green, colorText: Colors.white);
                                 }
                               },
                               style: ElevatedButton.styleFrom(backgroundColor: Colors.red), 
                               child: const Text("Supprimer", style: TextStyle(color: Colors.white))
                             ),
                             cancel: TextButton(onPressed: () => Get.back(), child: const Text("Annuler"))
                           );
                        }
                      )).toList(),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to avoid code duplication
  Widget _buildCourseItem(dynamic course, {bool isCompleted = false, VoidCallback? onDelete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: darkFontGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCompleted ? Colors.green.withOpacity(0.3) : whiteColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green.withOpacity(0.2) : lightBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.school,
            color: isCompleted ? Colors.green : lightBlue,
          ),
        ),
        title: Text(
          course['title'] ?? "Cours sans titre",
          style: const TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${course['level'] ?? 'Niveau inconnu'} • ${course['language']?.toUpperCase() ?? 'FR'}",
          style: TextStyle(color: fontGrey, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            Icon(Icons.arrow_forward_ios, color: fontGrey, size: 16),
          ],
        ),
        onTap: () async {
          // Wait for return
          await Get.to(() => CourseDetailsScreen(courseData: course));
          // Update List
          setState(() {});
        },
      ),
    );
  }

  // --- PROFILE TAB ---
  Widget _buildProfileTab() {
    // Get user data from ApiService
    // Use GetX or Provider for reactive state
    // For now, we rely on setState via the Future/Dialog return.
    Map<String, dynamic>? user = ApiService.currentUser;
    String name = user?['fullName'] ?? "Utilisateur CoLearn";
    String email = user?['email'] ?? "user@colearn.com";
    String role = user?['role'] ?? "Étudiant";
    // Construct avatar letter
    String letter = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkFontGrey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: whiteColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: lightBlue.withOpacity(0.2),
                  child: Text(letter, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: lightBlue)),
                ),
                const SizedBox(height: 15),
                Text(name, style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(email, style: TextStyle(color: fontGrey, fontSize: 16)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(5)),
                  child: Text(role.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10)),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildProfileOption(
            icon: Icons.edit, 
            title: "Modifier le profil", 
            onTap: () {
              _showEditProfileDialog(name);
            }
          ),
          _buildProfileOption(icon: Icons.settings, title: "Paramètres", onTap: () {}),
          _buildProfileOption(icon: Icons.help, title: "Aide", onTap: () {}),
          _buildProfileOption(
            icon: Icons.logout,
            title: "Se déconnecter",
            onTap: () {
              // Clear session locally
              ApiService.currentUser = null;
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(String currentName) {
    final nameController = TextEditingController(text: currentName);
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkFontGrey,
        title: const Text("Modifier le profil", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Nom complet",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Nouveau mot de passe (optionnel)",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (ApiService.currentUser == null) return;
              
              int userId = ApiService.currentUser!['id'];
              String newName = nameController.text.trim();
              String newPass = passwordController.text.trim();

              if (newName.isEmpty) {
                Get.snackbar("Erreur", "Le nom ne peut pas être vide", backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }

              // Call API
              bool success = await ApiService.updateProfile(userId, newName, newPass);
              
              if (success) {
                Get.back();
                Get.snackbar("Succès", "Profil mis à jour", backgroundColor: Colors.green, colorText: Colors.white);
                setState(() {}); // Refresh UI
              } else {
                Get.snackbar("Erreur", "Échec de la mise à jour", backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: darkFontGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whiteColor.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: lightBlue),
        title: Text(title, style: TextStyle(color: whiteColor, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: fontGrey, size: 16),
        onTap: onTap,
      ),
    );
  }
}