import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
  try {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Sign in the user with Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch the user's role from Firestore
    String uid = userCredential.user!.uid;
    String userRole = await _getUserRole(uid);

    // Navigate based on the user's role and pass the email
    if (userRole == "site_manager") {
      Navigator.pushNamed(context, '/sm_navbar', arguments: {'email': email, 'password': password, 'role': userRole, 'uid': uid});

    } else if (userRole == "supplier") {
      Navigator.pushNamed(context, '/sp_navbar', arguments: {'email': email, 'password': password, 'role': userRole, 'uid': uid});
    }

    // Clear the text fields after successful login
    emailController.clear();
    passwordController.clear();
  } catch (e) {
    // Handle login errors (e.g., invalid credentials)
    print('Error during login: $e');
  }
}


  Future<String> _getUserRole(String uid) async {
    // Fetch user role from Firestore based on the user's UID
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists and contains the 'role' field
    if (userSnapshot.exists && userSnapshot.data() != null) {
      return userSnapshot.get('role');
    } else {
      // Handle the case where the 'role' field is missing or the document doesn't exist
      return "Unknown"; // You can choose to handle this case differently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/home_img.jpg", // Replace with your image asset path
            height: double.infinity,
            width: double.infinity,
            scale: 0.1,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(0, 90, 90,
                      90), // You can change the transparent color to any color you want
                  const Color.fromARGB(110, 0, 0, 0),
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(
                      1.0), // Adjust the opacity and color as needed
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(144, 0, 0, 0),
                    Color.fromARGB(158, 237, 190, 21).withOpacity(1.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: 330,
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0),

                  // Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromARGB(190, 217, 217, 217),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                        cursorColor: Color.fromARGB(211, 0, 0, 0),
                      ),
                    ),
                  ),

                  // Password Field
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromARGB(225, 217, 217, 217),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          border: InputBorder.none,
                          filled: true,
                        ),
                        cursorColor: Color.fromARGB(211, 0, 0, 0),
                      ),
                    ),
                  ),

                  // Login Btn
                  SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(100, 0, 0, 0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(114, 45)),
                    ),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
