import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'post_details_screen.dart';
import 'users_profile_screen.dart';
import 'users.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          "locationDescription": post["tripLocationDescription"],
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
  bool isUploadPopupVisible = false;
  bool isTripImagePopupVisible = false;
  bool isPostSelected = false;
  bool isTripImageSelected = false;

  // Create a TextEditingController for the search bar
  TextEditingController _searchController = TextEditingController();
  TextEditingController visitingPlacesController = TextEditingController();

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

  void toggleUploadPopup() {
    setState(() {
      isUploadPopupVisible = !isUploadPopupVisible;
    });
  }

  void toggleTripImagePopup() {
    setState(() {
      isTripImagePopupVisible = !isTripImagePopupVisible;
    });
  }

  Future<void> _pickImages(BuildContext context, String type) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      onFileLoading: (file) {
        // Handle file loading progress here if needed
      },
    );

    if (result != null) {
      final List<PlatformFile> images = result.files;
      // Handle the selected images here
      // For example: images.forEach((image) => print(image.name));
    }
  }

  void _uploadPost() {
    // Implement the UploadPost function here
    // ...
    toggleUploadPopup();
  }

  void _uploadTripImage() {
    // Implement the TripImageUpload function here
    // ...
    toggleTripImagePopup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: toggleUploadPopup,
        ),
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
          if (isUploadPopupVisible)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: toggleUploadPopup,
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: _uploadPost,
                            child: Text('Upload',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isPostSelected = true;
                                isTripImageSelected = false;
                              });
                              _pickImages(context, 'post');
                            },
                            child: Text('Post'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isPostSelected = false;
                                isTripImageSelected = true;
                              });
                              _pickImages(context, 'trip');
                            },
                            child: Text('Story'),
                          ),
                        ],
                      ),
                      if (isPostSelected)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            // Implement the file upload box for post images here
                            ElevatedButton(
                              onPressed: () => _pickImages(context, 'post'),
                              child: Text('Select Images'),
                            ),
                            Text('Location'),
                            SizedBox(height: 10),
                            // Implement the location input box with suggestions here
                            TextField(
                              controller: visitingPlacesController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Text('Location Description'),
                            SizedBox(height: 10),
                            // Implement the location description input box here
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Location Description',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Text('Trip Duration'),
                            SizedBox(height: 10),
                            // Implement the trip duration input box here
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Trip Duration',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Text('Visiting Places'),
                            SizedBox(height: 10),
                            // Implement the visiting places input box here
                            TextField(
                              controller: visitingPlacesController,
                              decoration: InputDecoration(
                                labelText: 'Visiting Places',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      if (isTripImageSelected)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            // Implement the file upload box for trip images here
                            ElevatedButton(
                              onPressed: () => _pickImages(context, 'trip'),
                              child: Text('Select Images'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (isTripImagePopupVisible)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: toggleTripImagePopup,
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: _uploadTripImage,
                            child: Text('Upload',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Implement the file upload box for trip images here
                      ElevatedButton(
                        onPressed: () => _pickImages(context, 'trip'),
                        child: Text('Select Images'),
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
