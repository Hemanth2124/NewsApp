import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/detailscreen.dart';
import 'package:my_flutter_app/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  String currentCategory = '';
  List<dynamic> data = []; // Initialize the data list

  Future<void> fetchInfo(String endpoint, String category) async {
    final String url =
        'https://newsapi.org/v2/$endpoint?q=$category&apiKey=3abdc8f43dac40a2a245fd2668686ba9';

   try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          data = json['articles'];
          
        });
      } else {
        setState(() {
          data= [];
          
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  currentCategory = controller.text.trim();
                  if (currentCategory.isNotEmpty) {
                    fetchInfo('everything', currentCategory);
                  }
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Expanded(
          child:data.length == 0 
            ? Center(
                child: Text('No data found'),
              )
            :ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final article = data[index];
              if (article['author'] == null ||
                  article['source']['name'] == null ||
                  article['title'] == null ||
                  article['description'] == null ||
                  article['url'] == null ||
                  article['urlToImage'] == null ||
                  article['content'] == null ||
                  article['publishedAt'] == null ||
                  article['urlToImage'].isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailscreen(article:data[index]),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                article['urlToImage'],
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('lib/images/medium.webp');
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Text(
                                article['source']['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          article['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author: ${article['author']}'),
                            Text('Published at: ${article['publishedAt']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
