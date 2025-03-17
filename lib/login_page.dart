import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tab_menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController.text = 'karn.yong@melivecode.com';
    _passwordController.text = 'melivecode';
  }

  Future<void> _login() async {
    final url = Uri.parse('https://www.melivecode.com/api/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "username": _usernameController.text,
      "password": _passwordController.text,
    });

    print("Request Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("jsonResponse: ${jsonResponse}");
        _showSnackBar(jsonResponse['message']);
        _navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:
                (context) => TabMenuPage(
                  username: jsonResponse['user']['username'],
                  avatarUrl: jsonResponse['user']['avatar'],
                ),
          ),
        );
      } else if (response.statusCode == 401) {
        _showSnackBar("Unexpected error: ${response.statusCode}");
      }
    } catch (error) {
      _showSnackBar("Failed to connect to server");
      print("Error: $error");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://melivecode.com/img/logo.png',
                            width: 150,
                            height: 150,
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your Password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _login();
                              }
                            },

                            child: const Text("Login"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
