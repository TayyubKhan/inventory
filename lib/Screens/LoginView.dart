import 'package:flutter/material.dart';
import 'package:INVENTORY/Screens/HomePage.dart';
import 'package:INVENTORY/Repository/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _passwordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          style: const TextStyle(color: Colors.black),
          controller: _usernameController,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            labelText: 'Enter Username',
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87), // Unfocused border
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black), // Focused border
            ),
            hintText: 'Enter Username', // Change hint text
            hintStyle: TextStyle(color: Colors.grey[400]), // Change hint color
            filled: false,
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          style: const TextStyle(color: Colors.black),
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            labelText: 'Enter Password',
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87), // Unfocused border
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black), // Focused border
            ),
            hintText: 'Enter Password', // Change hint text
            hintStyle: TextStyle(color: Colors.grey[400]), // Change hint color
            filled: false,
            fillColor: Colors.black, // Change field color
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _login();
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black87)),
          onPressed: _isLoading ? null : _login,
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
        ),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username and password cannot be empty.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await LoginRepo().loginRepo(
        'https://a.thekhantraders.com/api/user_login.php?type=get',
        {'user': username, 'pass': password},
      ).then((value) async {
        if (value['status'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'userId', value['user_dats'][0]['id'].toString());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Username or Password is Wrong'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Username and password cannot be empty.'),
            duration: Duration(seconds: 2),
          ),
        );
      });

      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error: $error';
      setState(() {});
    }
  }
}
