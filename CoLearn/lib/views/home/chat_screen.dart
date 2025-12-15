import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String groupName;
  const ChatScreen({super.key, required this.groupName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    // Poll every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    List<dynamic> raw = await ApiService.getMessages(widget.groupName);
    if (!mounted) return;
    
    final myName = ApiService.currentUser?['fullName'] ?? "Moi";

    setState(() {
      messages = raw.map((m) => {
        "text": m['content'] ?? m['text'], // Backend sends 'content', fallback to 'text'
        "sender": m['sender'] ?? "Anonyme",
        "isMe": m['sender'] == myName
      }).toList().cast<Map<String, dynamic>>();
      
      // Auto scroll only if at bottom? For now just keep it simple.
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

      await ApiService.sendMessage(myName, text, widget.groupName);
      _fetchMessages(); // Refresh to be sure
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60, // Add a bit of buffer
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
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ListView.builder(
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
