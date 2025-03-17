import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TabMenuPage extends StatefulWidget {
  final String username;
  final String avatarUrl;

  const TabMenuPage({
    super.key,
    required this.username,
    required this.avatarUrl,
  });

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> {
  late String _username;
  late String _avatarUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = widget.username;
    _avatarUrl = widget.avatarUrl;
  }

  void _logOut() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My App"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Home", icon: Icon(Icons.home)),
              Tab(text: "Contact", icon: Icon(Icons.contact_mail)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('home')),
            Text('Contact'),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_avatarUrl),
                  ),
                  Text(
                    _username,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _logOut, child: Text("Logout")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
