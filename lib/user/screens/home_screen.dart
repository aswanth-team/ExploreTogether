import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_application_1/user/screens/post_details_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> posts = [
    {
      'images': ['assets/bg2.jpg', 'assets/bg3.jpg', 'assets/bg2.jpg'],
      'location': 'Paris, France',
      'locationDescription': 'The city of lights and love.',
      'tripDuration': '5 Days',
      'userImage': 'assets/profile/aswanth.webp',
      'userName': 'Aswanth',
    },
    {
      'images': ['assets/bg4.jpg', 'assets/bg5.jpg'],
      'location': 'Kyoto, Japan',
      'locationDescription': 'A city of temples and traditions.',
      'tripDuration': '7 Days',
      'userImage': 'assets/profile/sagar.jpg',
      'userName': 'Sagar',
    },
    {
      'images': ['assets/logo.jpg', 'assets/bg6.jpg', 'assets/bg7.jpg'],
      'location': 'New York, USA',
      'locationDescription': 'The city that never sleeps.',
      'tripDuration': '3 Days',
      'userImage': 'assets/profile/ajmal.webp',
      'userName': 'Ajmal',
    },
    {
      'images': ['assets/logo.jpg', 'assets/bg6.jpg', 'assets/bg7.jpg'],
      'location': 'New York, USA',
      'locationDescription': 'The city that never sleeps.',
      'tripDuration': '3 Days',
      'userImage': 'assets/profile/ajmal.webp',
      'userName': 'Ajmal',
    },
  ];

  String filterLocation = '';
  String filterDuration = '';
  List<Map<String, dynamic>> filteredPosts = [];
  bool isFilterVisible = false;

  // Create a TextEditingController for the search bar
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPosts = posts;
  }

  void applyFilters() {
    setState(() {
      filteredPosts = posts.where((post) {
        bool matchesLocation = filterLocation.isEmpty ||
            post['location'].toLowerCase().contains(filterLocation.toLowerCase());
        bool matchesDuration = filterDuration.isEmpty ||
            post['tripDuration'].toLowerCase().contains(filterDuration.toLowerCase());
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                            child: Text('Reset', style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              applyFilters();
                              toggleFilterPopup();
                            },
                            child: Text('Apply', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: toggleFilterPopup,
                        child: Text('Close', style: TextStyle(color: Colors.black)),
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
                  images: post['images'],
                  location: post['location'],
                  locationDescription: post['locationDescription'],
                  tripDuration: post['tripDuration'],
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
  final List<String> images;
  final String location;
  final String locationDescription;
  final String tripDuration;
  final String userImage;
  final String userName;

  UserPost({
    required this.index,
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(widget.userImage),
                ),
                SizedBox(width: 10),
                Text(
                  widget.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                          borderRadius: BorderRadius.circular(15), // Adjusting border radius
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
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: _nextImage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.location,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.locationDescription,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.tripDuration,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(postIndex: widget.index),
                    ),
                  );
                },
                child: Text('Show More', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

