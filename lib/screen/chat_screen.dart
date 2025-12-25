import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/ChatProvider.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String user;
  const ChatScreen({super.key, required this.user});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgCtrl = TextEditingController();

  Future<void> fetchReceiver() async {
    try {
      final res = await http.get(
        Uri.parse("https://dummyjson.com/comments?limit=10"),
      );
      String msg = jsonDecode(res.body)["comments"][0]["body"].toString();
      context.read<ChatProvider>().addReceiverMessage(widget.user, msg);
    } catch (_) {
      context.read<ChatProvider>().addReceiverMessage(
        widget.user,
        "API Error - random message",
      );
    }
  }

  @override
  void initState() {
    super.initState();
   // fetchReceiver();
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = context.watch<ChatProvider>();
    final chatList = chatProv.chats[widget.user] ?? [];

    return Scaffold(
      appBar: AppBar(title: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                minRadius: 15,
                  child: Text(widget.user[0])),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user,style: TextStyle(fontSize: 17),),
                  SizedBox(height: 5,),
                  Text("Online",style: TextStyle(fontSize: 11),)
                ],
              )
            ],
          )
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: chatList.length,
              itemBuilder: (_, i) {
                var m = chatList[i];
                bool sender = m["type"] == "sender";
                String msg = m["msg"] ?? "";
                String initial = widget.user[0].toUpperCase();

                return Row(
                  mainAxisAlignment:
                  sender ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!sender) CircleAvatar(child: Text(initial)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: sender ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18),
                            bottomRight:  Radius.circular(18),
                        topLeft:  Radius.circular(18),topRight:  Radius.circular(2),),

                      ),
                      child: Text(
                        msg,
                        style: TextStyle(color: sender ? Colors.white : Colors
                            .black),
                      ),
                    ),
                    if (sender) ...[
                      const SizedBox(width: 6),
                      CircleAvatar(child: Text(initial)),
                    ]
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      hintText: "Message",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (msgCtrl.text
                          .trim()
                          .isEmpty) return;
                      context.read<ChatProvider>().sendMessage(
                          widget.user, msgCtrl.text);
                      msgCtrl.clear();
                      fetchReceiver();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}