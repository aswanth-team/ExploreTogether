import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> posts = [
    {
      'images': ['assets/bg2.jpg', 'assets/bg3.jpg'],
      'location': 'Paris, France',
      'locationDescription': 'The city of lights and love.',
      'tripDuration': '5 Days',
      'userImage': 'assets/images/user1.jpg',
      'userName': 'Alice Johnson',
    },
    {
      'images': ['assets/bg4.jpg', 'assets/bg5.jpg'],
      'location': 'Kyoto, Japan',
      'locationDescription': 'A city of temples and traditions.',
      'tripDuration': '7 Days',
      'userImage': 'assets/images/user2.jpg',
    },
    {
      'images': ['assets/logo.jpg','assets/bg6.jpg', 'assets/bg7.jpg'],
      'location': 'New York, USA',
      'locationDescription': 'The city that never sleeps.',
      'tripDuration': '3 Days',
      'userImage': 'assets/images/user3.jpg',
      'userName': 'John Smith',
    },
  ];

  String filterLocation = '';
  String filterDuration = '';
  List<Map<String, dynamic>> filteredPosts = [];
  bool isFilterVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LocationSearchDelegate(
                  posts: posts,
                  onSearch: (String location) {
                    setState(() {
                      filterLocation = location;
                      applyFilters();
                    });
                  },
                ),
              );
            },
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

class LocationSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> posts;
  final Function(String) onSearch;

  LocationSearchDelegate({required this.posts, required this.onSearch});

  @override
  String get searchFieldLabel => 'Search by location';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = posts.where((post) {
      return post['location']
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return ListTile(
          title: Text(post['location']),
          onTap: () {
            onSearch(post['location']);
            close(context, post['location']);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = posts.where((post) {
      return post['location']
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final post = suggestions[index];
        return ListTile(
          title: Text(post['location']),
          onTap: () {
            onSearch(post['location']);
            close(context, post['location']);
          },
        );
      },
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(widget.userImage),
                  ),
                  SizedBox(width: 8),
                  Text(widget.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  if (_currentPage > 0)
                    Positioned(
                      left: 10,
                      top: 100,
                      child: GestureDetector(
                        onTap: _previousImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  if (_currentPage < widget.images.length - 1)
                    Positioned(
                      right: 10,
                      top: 100,
                      child: GestureDetector(
                        onTap: _nextImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.images.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      spacing: 4.0,
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${widget.location}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(widget.locationDescription, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text('Duration: ${widget.tripDuration}', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostDetailScreen(postIndex: widget.index)),
                    );
                  },
                  child: Text('See Other Posts >', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final int postIndex;

  PostDetailScreen({required this.postIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail #$postIndex'),
      ),
      body: Center(
        child: Text('Full details of Post #$postIndex'),
      ),
    );
  }
}
