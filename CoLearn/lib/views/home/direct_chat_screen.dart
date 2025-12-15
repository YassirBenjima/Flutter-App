

import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DirectChatScreen extends StatefulWidget {
  final int otherUserId;
  final String otherUserName;
  
  const DirectChatScreen({super.key, required this.otherUserId, required this.otherUserName});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  int? myId;

  @override
  void initState() {
    super.initState();
    myId = ApiService.currentUser?['id'];
    _fetchMessages();
    // Poll every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    if (myId == null) return;
    List<dynamic> raw = await ApiService.getConversation(widget.otherUserId);
    if (!mounted) return;
    
    setState(() {
      messages = raw.map((m) {
        // Backend returns: sender: {id: ..., fullName: ...}
        int senderId = m['sender']['id']; 
        return {
          "text": m['content'],
          "sender": m['sender']['fullName'],
          "isMe": senderId == myId
        };
      }).toList().cast<Map<String, dynamic>>();
    });
  }

  void sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      String text = _msgController.text;
      _msgController.clear();
      
      final myName = ApiService.currentUser?['fullName'] ?? "Moi";

      // Optimistic update
      setState(() {
        messages.add({
          "text": text,
          "isMe": true,
          "sender": myName
        });
      });
      _scrollToBottom();

      await ApiService.sendDirectMessage(widget.otherUserId, text);
      _fetchMessages(); // Refresh to be sure
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60, 
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.otherUserName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: messages.isEmpty 
             ? const Center(child: Text("Aucun message", style: TextStyle(color: Colors.grey)))
             : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['isMe'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 4),
                            child: Text(
                              msg['sender'], 
                              style: const TextStyle(
                                color: Colors.grey, 
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? lightBlue : Colors.grey[800],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(2),
                              bottomRight: isMe ? const Radius.circular(2) : const Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            msg['text'] ?? "", 
                            style: const TextStyle(color: Colors.white)
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Écrivez un message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: lightBlue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
