import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_flutter_app/loggedin.dart';

class detailscreen extends StatefulWidget {
  final Map<String, dynamic> article; // Changed from index
  detailscreen({required this.article});
  @override
  State<detailscreen> createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  // Updated constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 229, 236, 98),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save_alt),
          ),
          IconButton(
            onPressed: () async {
              final docUser = FirebaseFirestore.instance
                  .collection(save.loggedinusername)
                  .doc('saved articles');

              try {
                DocumentSnapshot docSnapshot = await docUser.get();

                if (docSnapshot.exists) {
                  // Check if the article is already saved
                  bool articleExists = false;
                  List existingArticles = docSnapshot.get('articles') ?? [];

                  for (var existingArticle in existingArticles) {
                    if (existingArticle['title'] == widget.article['title']) {
                      articleExists = true;
                      break;
                    }
                  }

                  if (!articleExists) {
                    // Add the new article
                    existingArticles.add(widget.article);
                    await docUser.update({
                      'articles': existingArticles,
                    });

                    // Show success snackbar
                    SnackBar profileSnack =
                        SnackBar(content: Text('Saved successfully'));
                    ScaffoldMessenger.of(context).showSnackBar(profileSnack);
                  } else {
                    // Show "already saved" snackbar
                    SnackBar profileSnack =
                        SnackBar(content: Text('Already saved'));
                    ScaffoldMessenger.of(context).showSnackBar(profileSnack);
                  }
                } else {
                  // Document doesn't exist, create it with the current article
                  await docUser.set({
                    'articles': [widget.article],
                  });

                  SnackBar profileSnack =
                      SnackBar(content: Text('Saved successfully'));
                  ScaffoldMessenger.of(context).showSnackBar(profileSnack);
                }
              } catch (e) {
                // Handle any errors
                SnackBar errorSnack =
                    SnackBar(content: Text('Error saving article: $e'));
                ScaffoldMessenger.of(context).showSnackBar(errorSnack);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
        title: Center(
          child: Text(
            'NewsApp',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 210, 210),
              borderRadius: BorderRadius.circular(10)),
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 200,
                        child: Image.network(
                          widget.article[
                              'urlToImage'], // Use the passed article data
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        widget.article['source']
                            ['name'], // Updated data reference
                        style: TextStyle(
                          color: const Color.fromARGB(255, 229, 241, 62),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Text(
                  widget.article['title'], // Updated
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  'Content:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                child: Text(
                  widget.article['content'], // Updated
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 20),
                child: Text(
                  widget.article['description'], // Updated
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  'Url for more details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 20),
                child: Text(
                  widget.article['url'], // Updated
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.article['author'].toString().length > 15
                          ? widget.article['author'].toString().substring(0, 15)
                          : widget.article['author'].toString(),
                    ),
                    Text(
                      widget.article['publishedAt'].toString().substring(0, 10),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
