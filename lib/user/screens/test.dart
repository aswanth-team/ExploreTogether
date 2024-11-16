import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/screens/users_profile_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = UserProfile(
      userImage: 'assets/profile/aswanth.webp',
      userName: 'Aswanth',
      bio: 'Travel enthusiast and photographer',
      userPosts: [
        {
          'location': 'New York',
          'images': ['assets/post1.jpg', 'assets/post2.jpg'],
        },
        {
          'location': 'Paris',
          'images': ['assets/post3.jpg', 'assets/post4.jpg'],
        },
      ],
      tripPhotos: ['assets/bg2.jpg', 'assets/bg3.jpg', 'assets/bg4.jpg'],
    );

    return MaterialApp(
      home: ProfilePage(userProfile: userProfile),
    );
  }
}
