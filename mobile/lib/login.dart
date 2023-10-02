import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  topLeft:
                      Radius.circular(30.0), // Set the top-left corner radius
                  topRight:
                      Radius.circular(30.0), // Set the top-right corner radius
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(144, 0, 0, 0), 
                    Color.fromARGB(158, 237, 190, 21).withOpacity(1.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // color: const Color.fromARGB(1, 237, 189, 21)
                //     .withOpacity(0.7), // Background color of the small box
              ),
              height: 330, // Adjust the height as needed
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

                  // Email Field
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the corner radius here
                        color: Color.fromARGB(190, 217, 217, 217),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          border: InputBorder.none, // Remove the default border
                          filled: true,
                        ),
                        cursorColor: Color.fromARGB(211, 0, 0, 0),
                      ),
                    ),
                  ),

                  // Password Field
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the corner radius here
                        color: Color.fromARGB(225, 217, 217, 217),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          border: InputBorder.none, // Remove the default border
                          filled: true,
                        ),
                        cursorColor: const Color.fromARGB(211, 0, 0, 0),
                      ),
                    ),
                  ),

                  //Login Btn
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(100, 0, 0, 0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ), // Set the corner radius
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(114, 45)), // Set custom button size here
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