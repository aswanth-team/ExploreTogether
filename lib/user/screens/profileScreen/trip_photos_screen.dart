import 'package:flutter/material.dart';

class TripPhotos extends StatelessWidget {
  final List<String> tripPhotos; // List of trip photos
  final String userName; // User name for delete functionality

  const TripPhotos({
    Key? key,
    required this.tripPhotos,
    required this.userName,
  }) : super(key: key);

  void deleteTripPhoto(String photoPath, String userName) {
    // Logic for deleting the photo
    print('Deleted $photoPath for $userName');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (tripPhotos.isEmpty)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Three images per row
              crossAxisSpacing: 8, // Horizontal space between items
              mainAxisSpacing: 8, // Vertical space between items
            ),
            itemCount: tripPhotos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
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
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
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
                    Image.asset(
                      tripPhotos[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'delete') {
                            deleteTripPhoto(tripPhotos[index], userName);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Colors.grey[800],
                        elevation: 8,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
