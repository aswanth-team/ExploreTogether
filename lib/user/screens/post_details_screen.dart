import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final String username; // Username passed as a parameter
  final String postId; // Post ID passed as a parameter

  // Constructor accepts username and postId
  PostDetailScreen({
    required this.username,
    required this.postId,
  });

  // Simulating post data with unique postId and username
  final List<Map<String, dynamic>> userPosts = [
    {
      'postId': 'post12345', // Unique postId
      'username': 'aswanth123', // Username for post
      'userImage': 'assets/profile/aswanth.webp', // User image for post
      'location': 'New York',
      'description': 'The city that never sleeps. Amazing places to visit!',
      'images': ['assets/bg2.jpg', 'assets/b3.jpg', 'assets/bg4.jpg'],
      'currentIndex': 0,
      'completed': true,
      'rating': 4.5,
      'friends': ['friend1', 'friend2', 'friend3'],
      'tripDuration': '5 days',
      'tripPlaces': ['Central Park', 'Statue of Liberty', 'Times Square'],
      'tripFeedback': 'Amazing experience, would definitely visit again!',
      'userGender': 'Male', // User gender
      'userDOB': 'January 1, 1995', // User DOB
    },
    {
      'postId': '67890', // Another unique postId
      'username': 'john_doe', // Username for post
      'userImage': 'assets/profile/john_doe.webp', // User image for post
      'location': 'Paris',
      'description':
          'Romantic city with iconic landmarks like the Eiffel Tower.',
      'images': [
        'assets/posts/post4.jpg',
        'assets/posts/post5.jpg',
        'assets/posts/post6.jpg'
      ],
      'currentIndex': 0,
      'completed': false,
      'rating': null,
      'friends': [],
      'tripDuration': '3 days',
      'tripPlaces': ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame Cathedral'],
      'tripFeedback': 'The trip was great but could have been longer.',
      'userGender': 'Female', // User gender
      'userDOB': 'March 5, 1992', // User DOB
    },
  ];

  // Method to find the post by both username and postId
  Map<String, dynamic> _getPostData() {
    return userPosts.firstWhere(
      (post) => post['postId'] == postId && post['username'] == username,
      orElse: () => {}, // Returns an empty map if no post is found
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = _getPostData();

    // If post is not found, show a placeholder or error message
    if (post.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Post Detail'),
        ),
        body: Center(
          child: Text('Post not found!'),
        ),
      );
    }

    final isCompleted = post['completed'];
    final rating = post['rating'];
    final friends = post['friends'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail #$postId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info section at the top (User image, Username, Gender, DOB)
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(post['userImage']),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'], // Display the username
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(post['userGender']), // Display the gender
                    Text(post['userDOB']), // Display the DOB
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Image Gallery with Swipeable < and > buttons
            Column(
              children: [
                Container(
                  height: 200.0,
                  child: Stack(
                    children: [
                      Image.asset(post['images'][post['currentIndex']],
                          fit: BoxFit.cover, width: double.infinity),
                      Positioned(
                        left: 10.0,
                        top: 90.0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_left,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            // Update the current index
                            if (post['currentIndex'] > 0) {
                              post['currentIndex']--;
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 10.0,
                        top: 90.0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_right,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            // Update the current index
                            if (post['currentIndex'] <
                                post['images'].length - 1) {
                              post['currentIndex']++;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Location and Description
            Text(
              'Location: ${post['location']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(post['description']),
            SizedBox(height: 8.0),

            // Trip Duration and Plans
            Text(
              'Trip Duration: ${post['tripDuration']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Places to visit: ${post['tripPlaces'].join(', ')}'),

            // If completed, show additional details
            if (isCompleted) ...[
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.green[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Completed',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8.0),
                        Text('Trip Completed', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    if (rating != null)
                      Text('Rating: $rating', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8.0),
                    Text('Friends: ${friends.join(', ')}'),
                    SizedBox(height: 8.0),
                    Text('Feedback: ${post['tripFeedback']}'),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}