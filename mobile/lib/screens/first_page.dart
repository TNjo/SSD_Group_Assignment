import 'package:flutter/material.dart';
import 'package:mobile/utils.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                const Color.fromARGB(0, 90, 90,90), // You can change the transparent color to any color you want
                const Color.fromARGB(97, 0, 0, 0),
                const Color.fromARGB(202, 0, 0, 0),
                const Color.fromARGB(255, 0, 0, 0)
                    .withOpacity(1.0), // Adjust the opacity and color as needed
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Align(
          alignment:
              Alignment.bottomLeft, // Aligns the text to the bottom-left corner
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 160.0, left: 30.0), // Adjust as needed
            child: Text(
              'Streamline \nYour \nConstruction Procurements',
              style: SafeGoogleFont(
                'Yu Gothic UI',
                fontSize: 34,
                fontWeight: FontWeight.w400,
                height: 1.8,
                letterSpacing: 2.24,
                color: const Color.fromARGB(255, 255, 255, 255),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: const Color.fromARGB(1, 237, 189, 21).withOpacity(0.7), // Background color of the small box
            height: 122, // Adjust the height as needed
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                //Login Btn
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

                //SignUp Btn
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
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
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}