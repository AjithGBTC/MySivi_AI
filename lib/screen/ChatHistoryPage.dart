import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/ChatProvider.dart';
import 'chat_screen.dart';

class ChatHistoryPage extends StatelessWidget {
  final ScrollController scroll;
  const ChatHistoryPage({super.key, required this.scroll});

  @override
  Widget build(BuildContext context) {
    final chatProv = context.watch<ChatProvider>();
    final users = chatProv.chats.keys.toList().reversed.toList();

    return ListView.builder(
      controller: scroll,
      itemCount: users.length,
      itemBuilder: (_, i) {
        String user = users[i];
        String lastMsg = chatProv.chats[user]!.last["msg"] ?? "";
        String time = DateTime.now().toLocal().toString().substring(11, 16);

        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: user)),
            );
          },
          child: Container(
            child: ListTile(

              leading: CircleAvatar(
                backgroundColor: Colors.green,
                  child: Text(user[0].toUpperCase(),style: TextStyle(color: Colors.white),)),
              title: Text(user,),
              subtitle: Text(lastMsg),
              trailing: Text("${time} hour ago"),
            ),
          ),
        );
      },
    );
  }
}