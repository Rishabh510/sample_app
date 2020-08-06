import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_example/widgets/myText.dart';
import 'package:hive_example/widgets/spinner.dart';
import 'package:http/http.dart' as http;

class PostsView extends StatefulWidget {
  final List<dynamic> posts;
  PostsView({Key key, this.posts}) : super(key: key);

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  bool _isLoading = false;
  static const url = 'https://jsonplaceholder.typicode.com/posts/';
  List<Color> _colorList2 = [
    Colors.green.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.pink.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.purple.withOpacity(0.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading)
          ? spinner(context)
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _colorList2,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.deepOrange,
                      elevation: 16,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: myText('<-'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('NOTE: Tap a post to view post specific details'),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.2),
                            ),
                            child: GestureDetector(
                              onTap: () => _viewComments(widget.posts[i]['id']),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: (widget.posts[i]['userId'] % 2 == 0) ? Colors.blue : Colors.green,
                                  child: Text(
                                    widget.posts[i]['id'].toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                title: Container(
                                  child: Text(widget.posts[i]['title']),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.posts.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _viewComments(int postId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url + '$postId' + '/comments');
      final comments = json.decode(response.body) as List<dynamic>;
      setState(() {
        _isLoading = false;
      });
      _showDialogPosts(context, comments);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      _showDialogError(context, error);
      throw (error);
    }
  }

  _showDialogPosts(BuildContext context, List<dynamic> comments) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        useSafeArea: true,
        builder: (context) {
          return Dialog(
            elevation: 8,
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            child: _showPosts(context, comments),
          );
        });
  }

  Widget _showPosts(BuildContext context, List<dynamic> comments) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: myText('<-'),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comments[i]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(comments[i]['email']),
                      ],
                    ),
                    subtitle: Text(comments[i]['body']),
                  ),
                );
              },
              itemCount: comments.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  _showDialogError(BuildContext context, dynamic error) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        useSafeArea: true,
        builder: (context) {
          return SimpleDialog(
            elevation: 8,
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.black, width: 2),
            ),
            title: Text('ERROR'),
            children: [
              SimpleDialogOption(
                child: Text(error.toString()),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
