import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/screens/login_screen.dart'; // Import LoginScreen for logout

// HomeScreen widget that is shown after successful login
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blueGrey, // Set the app bar color
        actions: [
          // Logout button in the top right corner
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate back to the login screen (user logs out)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome message
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // User info (Just a placeholder here, you could display actual data)
            Text(
              'You are logged in as: [User Name]',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30),
            // List of options (Example placeholders)
            ElevatedButton(
              onPressed: () {
                // Navigate to another feature screen (You can create this screen)
                print('Navigating to Profile Settings');
              },
              child: Text('Go to Profile Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to another feature screen (You can create this screen)
                print('Navigating to App Features');
              },
              child: Text('Explore App Features'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Logout button
            ElevatedButton(
              onPressed: () {
                // Logout user and go back to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button color for logout
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
