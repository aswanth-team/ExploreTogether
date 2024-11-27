import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/screens/postScreen/post_details_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Required for File Handling
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Declare userData as a variable outside the class
Map<String, dynamic> userData = {
  "userImage": "assets/profile/aswanth.webp",
  "userName": "aswanth123",
  "userMobileNumber": 85423343242,
  "userFullName": "Aswanth K",
  "userBio":
      "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
  "userGender": "Male",
  "userDOB": "January 1, 1995",
  "userLocation": "Kannur, Kerala",
  "userSocialLinks": {
    "instagram": "https://www.instagram.com/a.swnth",
    "facebook": "https://www.facebook.com/aswanth.kumar",
    "gmail": "aswanth.kumar@gmail.com",
    "twitter": "https://x.com/__x"
  },
  "userPosts": [
    {
      "postId": "post1",
      "tripLocation": "vattavada",
      "tripLocationDescription":
          "The city that never sleeps. Amazing places to visit!",
      "locationImages": [
        "assets/locimage/vattavada1.jpg",
        "assets/locimage/vattavada2.jpg",
        "assets/locimage/vattavada4.jpg",
      ],
      "tripCompleted": true,
      "tripDuration": 6,
      "tripRating": 4.5,
      "tripBuddies": [
        'aswanth123',
        'ajmal12',
        'vyshnav221',
      ],
      "tripFeedback": "nice",
      "planToVisitPlaces": [
        'Mattupetty Dam',
        'Top Station',
        'Pampadum Shola National Park',
        'Vattavada Beauty View Point',
        ' Strawberry Farm',
        ' Pazhathottam View Point',
        ' Chilanthiyar Waterfall'
      ],
      "visitedPlaces": [
        'Mattupetty Dam',
        'Top Station',
        'Vattavada Beauty View Point'
      ],
    },
    {
      "postId": "post2",
      "tripLocation": "Manali",
      "tripLocationDescription":
          "Manali is a high-altitude Himalayan resort town in India’s northern Himachal Pradesh state.",
      "tripDuration": 7,
      "locationImages": [
        "assets/locimage/manali1.jfif",
        "assets/locimage/manali2.jfif",
        "assets/locimage/manali3.jpg",
        "assets/locimage/manali4.jpg",
      ],
      "tripCompleted": false,
      "tripRating": null,
      "tripBuddies": null,
      "tripFeedback": null,
      "planToVisitPlaces": [
        'Hadimba Mata Temple',
        'Solang',
        'Old Manali',
        'Hidimba Devi Temple',
        'Jogini Waterfall',
        'Shri Anjani Mahadev Mandir'
      ],
      "visitedPlaces": null,
    }
  ],
  "tripPhotos": [
    'assets/profile/aswanth.webp',
    "assets/locimage/andamanandnicobarislands11.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands33.webp",
  ],
};

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<dynamic> userPosts = userData['userPosts'] ?? [];
  final List<dynamic> tripPhotos = userData['tripPhotos'] ?? [];
  bool showPosts = true;
  // Update profile details
  void updateProfileDetails(Map<String, dynamic> updatedData) {
    setState(() {
      userData = updatedData;
    });
  }

  // Function to handle image picking and updating
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userData['userImage'] = pickedFile.path;
      });
    }
  }

  void deleteTripPhoto(String photoPath, String username) {
    // Remove the photo from the UI
    setState(() {
      tripPhotos.remove(photoPath);
    });

    // Call your backend function to delete the photo from the database
    // Your function to delete the trip photo from the database goes here
    print('Deleted trip photo: $photoPath by $username');
  }

  void deletePost(String postId, String username) {
    // Remove post from the UI
    setState(() {
      userPosts.removeWhere((post) => post['postId'] == postId);
    });

    // Call your backend function to delete the post from the database
    // Your function to delete the post from the database goes here
    print('Deleted post: $postId by $username');
  }

  // Edit profile dialog
  void editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController fullNameController =
            TextEditingController(text: userData['userFullName']);
        TextEditingController bioController =
            TextEditingController(text: userData['userBio']);
        TextEditingController locationController =
            TextEditingController(text: userData['userLocation']);
        TextEditingController instagramController = TextEditingController(
            text: userData['userSocialLinks']['instagram']);
        TextEditingController facebookController = TextEditingController(
            text: userData['userSocialLinks']['facebook']);
        TextEditingController gmailController =
            TextEditingController(text: userData['userSocialLinks']['gmail']);
        TextEditingController twitterController =
            TextEditingController(text: userData['userSocialLinks']['twitter']);
        String gender = userData['userGender'];
        DateTime selectedDate = DateTime.tryParse(userData['userDOB']) ??
            DateTime(1995, 1, 1); // Default date

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Display the username (disabled)
                  TextField(
                    controller:
                        TextEditingController(text: userData['userName']),
                    decoration: const InputDecoration(labelText: "Username"),
                    enabled: false, // Make the username field read-only
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          userData['userImage']!.startsWith("assets")
                              ? AssetImage(userData['userImage']!)
                              : FileImage(File(userData['userImage']!))
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                      controller: fullNameController,
                      decoration:
                          const InputDecoration(labelText: "Full Name")),
                  const SizedBox(height: 8),
                  TextField(
                      controller: bioController,
                      decoration: const InputDecoration(labelText: "Bio")),
                  const SizedBox(height: 8),
                  TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: "Location")),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("DOB:"),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text("${selectedDate.toLocal()}".split(' ')[0],
                            style: const TextStyle(fontSize: 16)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: const InputDecoration(labelText: "Gender"),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                      controller: instagramController,
                      decoration:
                          const InputDecoration(labelText: "Instagram")),
                  TextField(
                      controller: facebookController,
                      decoration: const InputDecoration(labelText: "Facebook")),
                  TextField(
                      controller: gmailController,
                      decoration: const InputDecoration(labelText: "Gmail")),
                  TextField(
                      controller: twitterController,
                      decoration: const InputDecoration(labelText: "Twitter")),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  Map<String, dynamic> updatedData = {
                    'userName': userData['userName'], // Include username here
                    'userFullName': fullNameController.text,
                    'userBio': bioController.text,
                    'userLocation': locationController.text,
                    'userGender': gender,
                    'userDOB': "${selectedDate.toLocal()}".split(' ')[0],
                    'userSocialLinks': {
                      'instagram': instagramController.text,
                      'facebook': facebookController.text,
                      'gmail': gmailController.text,
                      'twitter': twitterController.text,
                    },
                    'userImage': userData['userImage'],
                  };
                  updateProfileDetails(updatedData); // Update the profile
                  Navigator.pop(context); // Close dialog
                  print(
                      updatedData); // Print the updated data (this will include username)
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: InteractiveViewer(
                            child: Image.asset(userData['userImage']!),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          userData['userImage']!.startsWith('assets')
                              ? AssetImage(userData['userImage']!)
                              : FileImage(File(userData['userImage']!))
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData['userFullName'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("DOB: ${userData['userDOB']}"),
                      const SizedBox(height: 4),
                      Text("Gender: ${userData['userGender']}"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(userData['userBio'],
                  style: const TextStyle(fontSize: 16)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (userData['userSocialLinks']['instagram'] != null)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.purple),
                    onPressed: () => launchUrl(
                        Uri.parse(userData['userSocialLinks']['instagram']!)),
                  ),
                if (userData['userSocialLinks']['facebook'] != null)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook,
                        color: Colors.blue),
                    onPressed: () => launchUrl(
                        Uri.parse(userData['userSocialLinks']['facebook']!)),
                  ),
                if (userData['userSocialLinks']['gmail'] != null)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google,
                        color: Colors.red),
                    onPressed: () => launchUrl(Uri.parse(
                        "mailto:${userData['userSocialLinks']['gmail']}")),
                  ),
                if (userData['userSocialLinks']['twitter'] != null)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.x, color: Colors.blue),
                    onPressed: () => launchUrl(
                        Uri.parse(userData['userSocialLinks']['twitter']!)),
                  ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: editProfile,
                child: const Text("Edit Profile"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Post button with underline effect
                  Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showPosts = true;
                          });
                        },
                        icon: const Icon(Icons.grid_on),
                        label: const Text('Posts'),
                      ),
                      // Underline when Posts is selected
                      if (showPosts)
                        Container(
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Trip button with underline effect
                  Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showPosts = false;
                          });
                        },
                        icon: const Icon(Icons.photo_album),
                        label: const Text('Trip Images'),
                      ),
                      // Underline when Trip Images is selected
                      if (!showPosts)
                        Container(
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Display Posts or Trip Images
            if (showPosts)
              Column(
                children: [
                  // Show Posts Section
                  if (userPosts.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Larger emoji 🚫
                          Text(
                            '🚫',
                            style: TextStyle(
                              fontSize: 50, // Increase the size of the emoji
                            ),
                          ),
                          // Text below the emoji
                          Text(
                            'No posts available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: userPosts.length,
                      itemBuilder: (context, index) {
                        final post = userPosts[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(
                                  postId: post['postId'],
                                  username: userData['userName'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: (post['tripCompleted'] ?? false)
                                  ? Colors.green[100]
                                  : Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 138, 222, 255)
                                          .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image at the top
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    post['locationImages'][0],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post['tripLocation'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      if (post['tripCompleted'] ?? false)
                                        RatingBar.builder(
                                          initialRating:
                                              post['tripRating'] ?? 0,
                                          minRating: 0,
                                          itemSize: 20,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) =>
                                              const Icon(Icons.star,
                                                  color: Colors.yellow),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                // Three-dot menu for delete option
                                Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        // Call function to delete the post from the UI and DB
                                        deletePost(post['postId'],
                                            userData['userName']);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              )
            else
              // Show Trip Images Section
              Column(
                children: [
                  if (tripPhotos.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '🚫',
                            style: TextStyle(
                              fontSize: 50, // Increase the size of the emoji
                            ),
                          ),
                          Text(
                            'No trip images available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Three images per row
                        crossAxisSpacing: 8, // Horizontal space between items
                        mainAxisSpacing: 8, // Vertical space between items
                      ),
                      itemCount: tripPhotos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Show the image in a dialog when clicked
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          tripPhotos[index],
                                          fit: BoxFit
                                              .contain, // Ensures full image fits without cropping
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              // Here we set BoxFit.cover to zoom the image to fill the grid cell
                              Image.asset(
                                tripPhotos[index],
                                fit: BoxFit
                                    .cover, // Ensures image fills the grid space, zooming if needed
                                width: double
                                    .infinity, // Makes image stretch to fit the container width
                                height: double
                                    .infinity, // Makes image stretch to fit the container height
                              ),
                              // Three-dot menu for delete option
                              Positioned(
                                top: 5,
                                right: 5,
                                child: PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.white),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      // Call function to delete the trip photo from the UI and DB
                                      deleteTripPhoto(tripPhotos[index],
                                          userData['userName']);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: ProfilePage(),
    ));
