import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'post_details_screen.dart';

class UsersProfilePage extends StatefulWidget {
  final String username; // Accept the username from the previous screen

  UsersProfilePage({required this.username});

  @override
  _UsersProfilePageState createState() => _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  bool isBioExpanded =
      false; // Controls the expansion of the bio and other details
  final List<Map<String, dynamic>> users = [
    {
      "userImage": "assets/profile/aswanth.webp",
      "userName": "aswanth123",
      "fullName": "Aswanth Kumar",
      "userBio":
          "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
      "userGender": "Male",
      "userDOB": "January 1, 1995",
      "userPosts": [
        {
          "location": "New York",
          "description": "The city that never sleeps. Amazing places to visit!",
          "images": [
            "assets/bg2.jpg",
            "assets/b4.jpg",
            "assets/bg4.jpg",
            "assets/b4.jpg",
            "assets/bg4.jpg"
          ],
          "currentIndex": 0,
          "completed": true,
          "rating": 4.5,
          "friends": ["friend1", "friend2"],
          "postId": "post12345"
        },
        {
          "location": "Paris",
          "description":
              "Romantic city with iconic landmarks like the Eiffel Tower.",
          "images": ["assets/bg3.jpg", "assets/b2.jpg", "assets/bg4.jpg"],
          "currentIndex": 0,
          "completed": false,
          "rating": 0,
          "friends": [],
          "postId": "post12346"
        }
      ],
      "tripPhotos": ["assets/trip/bg1.jpg", "assets/trip/bg2.jpg"],
      "socialLinks": {
        "instagram": "https://www.instagram.com/aswanth123",
        "facebook": "https://www.facebook.com/aswanth.kumar",
        "gmail": "aswanth.kumar@gmail.com"
      },
    },
    {
      "userImage": "assets/profile/sagar.jpg",
      "userName": "Sagar",
      "fullName": "Sagar",
      "userBio": '',
      "userGender": 'Male',
      "userDOB": "users",
      "userPosts": [
        {
          "location": "Kyoto, Japan",
          "description": "A city of temples and traditions.",
          "images": ["assets/bg4.jpg", "assets/bg5.jpg"],
          "currentIndex": 0,
          "completed": false,
          "rating": 0,
          "friends": [],
          "postId": "67890"
        }
      ],
      "tripPhotos": [],
      "socialLinks": {
        "instagram": "https://www.instagram.com/aswanth123",
        "facebook": "https://www.facebook.com/aswanth.kumar",
        "gmail": "aswanth.kumar@gmail.com"
      },
    },
    {
      "userImage": "assets/profile/ajmal.webp",
      "userName": "Ajmal",
      "fullName": "Ajmal U K",
      "userBio": '',
      "userGender": 'male',
      "userDOB": 'doc',
      "userPosts": [
        {
          "location": "New York, USA",
          "description": "The city that never sleeps.",
          "images": ["assets/logo.jpg", "assets/bg6.jpg", "assets/bg7.jpg"],
          "currentIndex": 0,
          "completed": true,
          "rating": 5,
          "friends": ['Ajmal', 'Achu'],
          "postId": "11223"
        }
      ],
      "tripPhotos": [],
      "socialLinks": {
        "instagram": "https://www.instagram.com/aswanth123",
        "facebook": "https://www.facebook.com/aswanth.kumar",
        "gmail": "aswanth.kumar@gmail.com"
      },
    }
    // Add more users if necessary
  ];
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    // Find the user by username
    userData = users.firstWhere((user) => user['userName'] == widget.username);
  }

  bool isPostsSelected = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(userData['userName']), // Display the username in the AppBar
      ),
      body: Column(
        children: [
          // User Profile Section
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.15,
                  backgroundImage: AssetImage(userData['userImage']),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Display the full name here
                Text(
                  userData['fullName'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                // Display Bio with possible multiple lines
                _buildBioSection(),
                SizedBox(height: screenHeight * 0.02),
                // Chat Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(username: userData['userName']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Set the background color to green
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12), // Adjust padding to reduce width
                    minimumSize: const Size(
                        150, 50), // Set a minimum size (width, height)
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the content
                    children: [
                      Icon(
                        Icons.chat, // Add the chat icon
                        color: Colors.white, // Set icon color to white
                        size: screenWidth *
                            0.05, // Adjust size based on screen width
                      ),
                      SizedBox(width: 8), // Space between the icon and text
                      Text(
                        'Chat',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Toggle Buttons for Posts and Trip Photos
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleButton(
                  label: 'Posts',
                  isSelected: isPostsSelected,
                  onPressed: () {
                    setState(() {
                      isPostsSelected = true;
                    });
                  },
                ),
                _buildToggleButton(
                  label: 'Trip Photos',
                  isSelected: !isPostsSelected,
                  onPressed: () {
                    setState(() {
                      isPostsSelected = false;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
              height:
                  screenHeight * 0.02), // Gap between buttons and grid content
          // Content Section (Posts or Trip Photos)
          Expanded(
            child: isPostsSelected
                ? _buildPostsGrid(screenWidth)
                : _buildTripPhotosGrid(screenWidth),
          ),
        ],
      ),
    );
  }

  // Custom Toggle Button Styling
  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  // Bio Section - Conditionally expandable with links
  Widget _buildBioSection() {
    return Column(
      children: [
        // Show truncated bio by default
        Text(
          isBioExpanded
              ? userData['userBio']
              : _truncateBio(userData['userBio']), // Truncate Bio by default
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        if (isBioExpanded) ...[
          SizedBox(height: 10),
          Text('Gender: ${userData['userGender']}'),
          Text('DOB: ${userData['userDOB']}'),
          SizedBox(height: 10),
          // Show social links when expanded
          _buildSocialLinks(),
        ],
        InkWell(
          onTap: _toggleBioExpansion,
          child: Text(
            isBioExpanded ? 'less...' : 'more...',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Truncate Bio text to the first line that fits screen width
  String _truncateBio(String bio) {
    int maxLength = 80; // Max characters visible before truncating
    return bio.length > maxLength ? bio.substring(0, maxLength) + '...' : bio;
  }

  // Toggle Bio and links expansion
  void _toggleBioExpansion() {
    setState(() {
      isBioExpanded = !isBioExpanded;
    });
  }

  // Build the social media links (displayed only when bio is expanded)
  // Build the social media links (displayed only when bio is expanded)
  Widget _buildSocialLinks() {
    List<Widget> links = [];
    final socialLinks = userData['socialLinks'];

    // Instagram
    if (socialLinks['instagram']?.isNotEmpty ?? false) {
      links.add(_buildLinkText(socialLinks['instagram']!));
    }
    // Facebook
    if (socialLinks['facebook']?.isNotEmpty ?? false) {
      links.add(_buildLinkText(socialLinks['facebook']!));
    }
    // X (Twitter) - Added null check for 'x'
    if (socialLinks['x']?.isNotEmpty ?? false) {
      links.add(_buildLinkText(socialLinks['x']!));
    }
    // Gmail
    if (socialLinks['gmail']?.isNotEmpty ?? false) {
      links.add(_buildLinkText('mailto:${socialLinks['gmail']}'));
    }

    // Return the links as a column
    return Column(
      children: links,
    );
  }

  // Build clickable link text with truncation for long URLs
  Widget _buildLinkText(String url) {
    String truncatedUrl = url.length > 30
        ? url.substring(0, 30) + '...'
        : url; // Truncate link text
    return GestureDetector(
      onTap: () => _openLink(url),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          '🔗 $truncatedUrl',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  // Open the link in the browser
  void _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Build the grid for user posts
  Widget _buildPostsGrid(double screenWidth) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth < 600 ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8, // Adjust aspect ratio for taller grid items
      ),
      itemCount: userData['userPosts'].length,
      itemBuilder: (context, index) {
        final post = userData['userPosts'][index];
        int currentIndex = post['currentIndex'];
        bool isCompleted = post['completed'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(
                  postId: post['postId'], // Pass postId
                  username: userData['userName'], // Pass username
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              color: isCompleted ? Colors.green[100] : Colors.white,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        post['images'][currentIndex],
                        fit: BoxFit.cover,
                        height: screenWidth * 0.25,
                        width: double.infinity, // Fill width
                      ),
                    ),
                    if (currentIndex > 0)
                      Positioned(
                        top: 10,
                        left: 5,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () {
                            setState(() {
                              if (currentIndex > 0) {
                                post['currentIndex'] = currentIndex - 1;
                              } else {
                                post['currentIndex'] =
                                    post['images'].length - 1;
                              }
                            });
                          },
                        ),
                      ),
                    if (currentIndex < post['images'].length - 1)
                      Positioned(
                        top: 10,
                        right: 5,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 20),
                          onPressed: () {
                            setState(() {
                              if (currentIndex < post['images'].length - 1) {
                                post['currentIndex'] = currentIndex + 1;
                              } else {
                                post['currentIndex'] = 0;
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['location'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      if (isCompleted) ...[
                        SizedBox(height: 10),
                        Text(
                          'Rating: ${post['rating']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build the grid for trip photos
  Widget _buildTripPhotosGrid(double screenWidth) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth < 600 ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: userData['tripPhotos'].length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              userData['tripPhotos'][index],
              fit: BoxFit.cover,
              height: screenWidth * 0.3, // Reduced height
            ),
          ),
        );
      },
    );
  }
}

class ChatPage extends StatelessWidget {
  final String username;

  ChatPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $username'),
      ),
      body: Center(
        child: Text('Chat interface with $username'),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UsersProfilePage(username: 'aswanth123'), // Pass the username here
    ));
