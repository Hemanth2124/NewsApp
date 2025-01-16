import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'detailscreen.dart';

class savedpage extends StatefulWidget {
  const savedpage({super.key});

  @override
  State<savedpage> createState() => _SavedPageState();
}

class _SavedPageState extends State<savedpage> {
  Future<void> loadSavedData() async {
    final docUser = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await docUser.collection('articles').doc('saved articles').get();

    if (docSnapshot.exists) {
      setState(() {
        saved.savedarticles = List<Map<String, dynamic>>.from(
            docSnapshot.get('articles') ?? []);
      });
    }
  }

  Future<void> deleteArticle(int index) async {
   
    final articleToRemove = saved.savedarticles[index];
    saved.savedarticles.removeAt(index);
    setState(() {});

    
    final docUser = FirebaseFirestore.instance;
    await docUser
        .collection('articles')
        .doc('saved articles')
        .update({'articles': saved.savedarticles}).catchError((error) {
     
      saved.savedarticles.insert(index, articleToRemove);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return saved.savedarticles.isEmpty
      ? Center(
          child: Text(
            'No articles are saved yet',
            style: TextStyle(fontSize: 25, color: Colors.black)
          ),
        )
      : ListView.builder(
      itemCount: saved.savedarticles.length,
      itemBuilder: (context, index) {
        if (saved.savedarticles[index]['author'] == null ||
            saved.savedarticles[index]['source']['name'] == null ||
            saved.savedarticles[index]['title'] == null ||
            saved.savedarticles[index]['description'] == null ||
            saved.savedarticles[index]['url'] == null ||
            saved.savedarticles[index]['urlToImage'] == null ||
            saved.savedarticles[index]['content'] == null ||
            saved.savedarticles[index]['publishedAt'] == null) {
          return SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      detailscreen(article: saved.savedarticles[index]),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
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
                              saved.savedarticles[index]['urlToImage'],
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              (loadingProgress
                                                      .expectedTotalBytes ??
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
                            saved.savedarticles[index]['source']['name'],
                            style: TextStyle(
                              color: const Color.fromARGB(255, 229, 241, 62),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: Text(
                      saved.savedarticles[index]['title'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(saved.savedarticles[index]['author']
                                    .toString()
                                    .length >
                                15
                            ? saved.savedarticles[index]['author']
                                .toString()
                                .substring(0, 15)
                            : saved.savedarticles[index]['author'].toString()),
                        Text(
                          saved.savedarticles[index]['publishedAt']
                              .toString()
                              .substring(0, 10),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            deleteArticle(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
