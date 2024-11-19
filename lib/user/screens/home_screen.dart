import 'package:flutter/material.dart';
import 'post_details_screen.dart';
import 'users_profile_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> users = [
    {
      "userImage": "assets/profile/aswanth.webp",
      "userName": "aswanth123",
      "userFullName": "Aswanth Kumar",
      "userBio":
          "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
      "userGender": "Male",
      "userDOB": "January 1, 1995",
      "userPosts": [
        {
          "tripLocation": "New York",
          "tripLocationdescription":
              "The city that never sleeps. Amazing places to visit!",
          "locationImages": [
            "assets/bg2.jpg",
            "assets/bg4.jpg",
            "assets/bg4.jpg",
          ],
          "tripCompleted": true,
          "tripDuration": 5,
          "tripRating": 4.5,
          "tripFeedback": "nice",
          "postId": "post1"
        },
        {
          "tripLocation": "New York",
          "tripLocationdescription":
              "The city that never sleeps. Amazing places to visit!",
          "tripDuration": 5,
          "locationImages": [
            "assets/bg2.jpg",
            "assets/b4.jpg",
            "assets/bg4.jpg",
          ],
          "tripCompleted": false,
          "tripRating": null,
          "tripFeedback": null,
          "postId": "post1"
        }
      ],
      "tripPhotos": [
        'assets/profile/aswanth.webp',
        "assets/bg2.jpg",
        "assets/bg4.jpg",
        "assets/bg4.jpg",
      ],
      "userSocialLinks": {
        "instagram": "https://www.instagram.com/aswanth123",
        "facebook": "https://www.facebook.com/aswanth.kumar",
        "gmail": "aswanth.kumar@gmail.com",
        "twitter": "https://x.com/__x"
      },
    },
    {
      "userImage": "assets/profile/sagar.jpg",
      "userName": "sagar123",
      "userFullName": "Sagar Sree",
      "userBio":
          "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
      "userGender": "Male",
      "userDOB": "January 1, 1995",
      "userPosts": [
        {
          "tripLocation": "New York",
          "tripLocationdescription":
              "The city that never sleeps. Amazing places to visit!",
          "locationImages": [
            "assets/bg2.jpg",
            "assets/b4.jpg",
            "assets/bg4.jpg",
          ],
          "tripCompleted": true,
          "tripDuration": 5,
          "tripRating": 4.5,
          "tripFeedback": "nice",
          "postId": "post1"
        },
        {
          "tripLocation": "New York",
          "tripLocationdescription":
              "The city that never sleeps. Amazing places to visit!",
          "tripDuration": 5,
          "locationImages": [
            "assets/bg2.jpg",
            "assets/b4.jpg",
            "assets/bg4.jpg",
          ],
          "tripCompleted": false,
          "tripRating": null,
          "tripFeedback": null,
          "postId": "post1"
        }
      ],
      "tripPhotos": [
        'assets/profile/sagar.jpg',
        "assets/bg2.jpg",
        "assets/bg4.jpg",
        "assets/bg4.jpg",
      ],
      "userSocialLinks": {
        "instagram": "https://www.instagram.com/aswanth123",
        "facebook": "https://www.facebook.com/aswanth.kumar",
        "gmail": "aswanth.kumar@gmail.com",
        "twitter": "https://x.com/__x"
      },
    },
  ];
  late List<Map<String, dynamic>> posts;

  List<Map<String, dynamic>> _generatePostFeed(
      List<Map<String, dynamic>> users) {
    List<Map<String, dynamic>> allPosts = [];
    for (var user in users) {
      for (var post in user["userPosts"]) {
        allPosts.add({
          "postId": post["postId"],
          "images": post["locationImages"],
          "location": post["tripLocation"],
          "locationDescription": post["tripLocationdescription"],
          "tripDuration": post["tripDuration"],
          "userImage": user["userImage"],
          "userName": user["userName"],
        });
      }
    }

    // Shuffle posts to ensure posts from the same user are not consecutive
    allPosts.shuffle();
    return _interleavePostsByUser(allPosts);
  }

  List<Map<String, dynamic>> _interleavePostsByUser(
      List<Map<String, dynamic>> posts) {
    Map<String, List<Map<String, dynamic>>> userPosts = {};
    for (var post in posts) {
      userPosts.putIfAbsent(post['userName'], () => []).add(post);
    }

    List<Map<String, dynamic>> result = [];
    while (userPosts.isNotEmpty) {
      for (var user in userPosts.keys.toList()) {
        if (userPosts[user]!.isNotEmpty) {
          result.add(userPosts[user]!.removeAt(0));
        }
        if (userPosts[user]!.isEmpty) {
          userPosts.remove(user);
        }
      }
    }
    return result;
  }

  String filterLocation = '';
  String filterDuration = '';
  List<Map<String, dynamic>> filteredPosts = [];
  bool isFilterVisible = false;

  // Create a TextEditingController for the search bar
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    posts = _generatePostFeed(users);
    filteredPosts = posts;
  }

  void applyFilters() {
    setState(() {
      filteredPosts = posts.where((post) {
        bool matchesLocation = filterLocation.isEmpty ||
            post['location']
                .toLowerCase()
                .contains(filterLocation.toLowerCase());
        bool matchesDuration = filterDuration.isEmpty ||
            post['tripDuration']
                .toLowerCase()
                .contains(filterDuration.toLowerCase());
        return matchesLocation && matchesDuration;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      filterLocation = '';
      filterDuration = '';
      filteredPosts = posts;
    });
  }

  void toggleFilterPopup() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      filterLocation = query;
      if (query.isEmpty) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.where((post) {
          return post['location'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _searchController, // Set the controller here
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by location',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // Adjust the padding
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        filterLocation = '';
                        filteredPosts = posts;
                        _searchController.clear(); // Clear the search text
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: toggleFilterPopup,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isFilterVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            filterLocation = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            filterDuration = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              resetFilters();
                              toggleFilterPopup();
                            },
                            child: Text('Reset',
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              applyFilters();
                              toggleFilterPopup();
                            },
                            child: Text('Apply',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: toggleFilterPopup,
                        child: Text('Close',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return UserPost(
                  index: index,
                  postId: post['postId'], // Pass postId here
                  images: post['images'],
                  location: post['location'],
                  locationDescription: post['locationDescription'],
                  tripDuration: post['tripDuration'].toString(),
                  userImage: post['userImage'],
                  userName: post['userName'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserPost extends StatefulWidget {
  final int index;
  final String postId; // Add postId here
  final List<String> images;
  final String location;
  final String locationDescription;
  final String tripDuration;
  final String userImage;
  final String userName;

  UserPost({
    required this.index,
    required this.postId, // Accept postId in the constructor
    required this.images,
    required this.location,
    required this.locationDescription,
    required this.tripDuration,
    required this.userImage,
    required this.userName,
  });

  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  void _nextImage() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousImage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the post details screen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              postId: widget.postId, // Pass postId
              username: widget.userName, // Pass userName
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigating to the ProfilePage with the username parameter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersProfilePage(
                              username: widget.userName), // Passing username
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(widget.userImage),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigating to the ProfilePage with the username parameter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersProfilePage(
                              username: widget.userName), // Passing username
                        ),
                      );
                    },
                    child: Text(
                      widget.userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _nextImage,
                child: Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              widget.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 10,
                        top: 100,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: _previousImage,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 100,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                          onPressed: _nextImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Reduced padding here to decrease the gap
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.location,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Reduced padding here to decrease the gap
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.locationDescription,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              // Reduced padding here to decrease the gap
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Duration Plan : ${widget.tripDuration}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
