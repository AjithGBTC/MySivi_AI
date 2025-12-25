import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/UserProvider.dart';
import 'chat_screen.dart';

class UsersPage extends StatelessWidget {
  final ScrollController scroll;
  const UsersPage({super.key, required this.scroll});

  @override
  Widget build(BuildContext context) {

    final userProv = context.watch<UserProvider>();

    return Scaffold(
      body: ListView.builder(
        controller: scroll,
        itemCount: userProv.users.length,
        itemBuilder: (_, i) {
          String name = userProv.users[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(name[0].toUpperCase(),style: TextStyle(color: Colors.white),),
            ),
            title: Text(name,),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: name)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () {
          String mockName = "User ${userProv.users.length + 1}";
          userProv.addUser(mockName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$mockName added • User added")),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}