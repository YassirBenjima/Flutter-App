import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:colearn/views/home/group_settings_screen.dart';
import 'package:colearn/views/home/tabs/group_chat_view.dart';
import 'package:colearn/views/home/tabs/group_events_view.dart';
import 'package:colearn/views/home/tabs/group_resources_view.dart';
import 'package:colearn/views/home/tabs/group_tasks_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetailsScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  const GroupDetailsScreen({super.key, required this.groupId, required this.groupName});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  bool isAdmin = false;
  Map<String, dynamic>? groupDetails;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    var details = await ApiService.getGroupDetails(widget.groupId);
    if (details != null && mounted) {
      setState(() {
        groupDetails = details;
        if (ApiService.currentUser != null) {
          isAdmin = details['adminId'] == ApiService.currentUser!['id'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[900],
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                   Get.to(() => GroupSettingsScreen(groupDetails: groupDetails!));
                },
              )
          ],
          bottom: const TabBar(
            indicatorColor: lightBlue,
             labelColor: Colors.white,
             unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.chat), text: "Chat"),
              Tab(icon: Icon(Icons.check_circle), text: "Tâches"),
              Tab(icon: Icon(Icons.calendar_today), text: "Agenda"),
              Tab(icon: Icon(Icons.folder), text: "Docs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupChatView(groupName: widget.groupName),
            GroupTasksView(groupId: widget.groupId),
            GroupEventsView(groupId: widget.groupId),
            GroupResourcesView(groupId: widget.groupId),
          ],
        ),
      ),
    );
  }
}
