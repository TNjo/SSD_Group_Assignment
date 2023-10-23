import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/screens/login_page.dart';
import 'package:mobile/main.dart';
import 'package:mockito/mockito.dart'; // Replace with the actual import path for your code

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseUser extends Mock implements User {}
class MockFirebaseUserCredential extends Mock implements UserCredential {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
 // Import the LoginPage widget

void main() {
  group('LoginPage Widget Test', () {
    // Create a test key for the email field for easy widget identification
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginButton = find.byType(ElevatedButton);

    testWidgets('LoginPage widget renders', (WidgetTester tester) async {
      // Build the LoginPage widget
      await tester.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      // Verify that the LoginPage widget renders on the screen
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('Entering email and password triggers login function', (WidgetTester tester) async {

      // Build the LoginPage widget
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));

      // Enter text into the email field
    
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password');

      // Tap the login button
      await tester.tap(loginButton);

      // Rebuild the widget
      await tester.pump();

      // Verify that the login function was triggered
      // You can check if the expected navigation occurred, but this depends on your app's structure
    });

    // Add more test cases as needed
  });
}
