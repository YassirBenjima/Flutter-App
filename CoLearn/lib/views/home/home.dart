import 'package:colearn/consts/consts.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: whiteColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_outline,
              color: whiteColor,
            ),
          ),
        ],
      ),
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

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section de bienvenue
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
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Découvrez de nouveaux cours et développez vos compétences",
                  style: TextStyle(
                    color: fontGrey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Section cours populaires
          Text(
            "Cours populaires",
            style: TextStyle(
              color: whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // Liste des cours
          _buildCourseCard(
            title: "Flutter Development",
            instructor: "Yassir Benjima",
            rating: 4.8,
            students: 1250,
            price: "Gratuit",
            image: "assets/images/course1.jpg",
          ),
          const SizedBox(height: 15),
          _buildCourseCard(
            title: "Dart Programming",
            instructor: "CoLearn Team",
            rating: 4.9,
            students: 890,
            price: "Gratuit",
            image: "assets/images/course2.jpg",
          ),
          const SizedBox(height: 15),
          _buildCourseCard(
            title: "Mobile App Design",
            instructor: "Design Expert",
            rating: 4.7,
            students: 2100,
            price: "Gratuit",
            image: "assets/images/course3.jpg",
          ),

          const SizedBox(height: 30),

          // Section catégories
          Text(
            "Catégories",
            style: TextStyle(
              color: whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _buildCategoryCard(
                  title: "Développement",
                  icon: Icons.code,
                  color: lightBlue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildCategoryCard(
                  title: "Design",
                  icon: Icons.palette,
                  color: golden,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildCategoryCard(
                  title: "Business",
                  icon: Icons.business,
                  color: orangeMedium,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildCategoryCard(
                  title: "Marketing",
                  icon: Icons.trending_up,
                  color: orangeDark,
                ),
              ),
            ],
          ),
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
  }) {
    return Container(
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
            child: Icon(
              Icons.play_circle_outline,
              color: lightBlue,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  instructor,
                  style: TextStyle(
                    color: fontGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: golden,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "(${students} étudiants)",
                      style: TextStyle(
                        color: fontGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                price,
                style: TextStyle(
                  color: lightBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Commencer",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkFontGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whiteColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: darkFontGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: whiteColor.withOpacity(0.1)),
            ),
            child: TextField(
              style: const TextStyle(color: whiteColor),
              decoration: InputDecoration(
                hintText: "Rechercher des cours...",
                hintStyle: TextStyle(color: fontGrey),
                prefixIcon: Icon(Icons.search, color: fontGrey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                "Recherchez des cours pour commencer",
                style: TextStyle(
                  color: fontGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mes cours",
            style: TextStyle(
              color: whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    color: fontGrey,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Aucun cours en cours",
                    style: TextStyle(
                      color: fontGrey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Inscrivez-vous à un cours pour commencer",
                    style: TextStyle(
                      color: fontGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profil utilisateur
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
                  child: Icon(
                    Icons.person,
                    color: lightBlue,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Utilisateur CoLearn",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "user@colearn.com",
                  style: TextStyle(
                    color: fontGrey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Options du profil
          _buildProfileOption(
            icon: Icons.edit,
            title: "Modifier le profil",
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.settings,
            title: "Paramètres",
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.help,
            title: "Aide",
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: "Se déconnecter",
            onTap: () {
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: darkFontGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whiteColor.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: lightBlue),
        title: Text(
          title,
          style: TextStyle(
            color: whiteColor,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: fontGrey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
