import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class detailscreen extends StatefulWidget {
  final Map<String, dynamic> article; 
  detailscreen({required this.article});
  @override
  State<detailscreen> createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
   Future savetofirestore() async {
    try {
      CollectionReference articles = FirebaseFirestore.instance.collection('articles');
      
      
      DocumentReference savedArticlesDoc = articles.doc('saved articles');

      
      DocumentSnapshot snapshot = await savedArticlesDoc.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> savedArticles = data['articles'] ?? [];

        
        bool isArticleSaved = savedArticles.any((article) => article['title'] == widget.article['title']);
        if (isArticleSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Already Saved')),
          );
          return;
        }
      }

      // Save the article
      await savedArticlesDoc.set({
        'articles': FieldValue.arrayUnion([widget.article]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }
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
            onPressed: () async {
              await savetofirestore();
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
                              'urlToImage'], 
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
                            ['name'],
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
                  widget.article['title'], 
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
                  widget.article['content'], 
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
                  widget.article['url'], 
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