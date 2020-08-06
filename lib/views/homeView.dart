import 'package:flutter/material.dart';
import 'package:hive_example/views/postsView.dart';
import 'package:hive_example/widgets/myText.dart';
import 'package:hive_example/widgets/spinner.dart';
import 'package:http/http.dart' as http;
import 'package:hive_example/models/postModel.dart';
import 'package:hive_example/models/userModel.dart';
import 'package:confetti/confetti.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const url = 'https://jsonplaceholder.typicode.com/posts/';
  PostObject currObject = PostObject(11, 101, '', '');
  final _bodyFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  ConfettiController _controllerCenter;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  InputDecoration decorator(String label, int i) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 20),
      hintText: (i == 2) ? 'Enter post body' : 'Enter title of post',
      border: OutlineInputBorder(
        borderSide: BorderSide(),
        borderRadius: BorderRadius.circular(16),
      ),
      filled: true,
    );
  }

  List<Color> _colorList = [
    Colors.red.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
  ];

  List<Color> _colorList2 = const [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 8,
        title: TypewriterAnimatedTextKit(
          repeatForever: true,
          isRepeatingAnimation: true,
          speed: Duration(seconds: 2),
          onTap: () {},
          text: [
            "Sample Application",
          ],
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center,
        ),
      ),
      body: (_isLoading)
          ? spinner(context)
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _colorList,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  decoration: decorator('Title', 1),
                                  textCapitalization: TextCapitalization.words,
                                  cursorColor: Colors.deepOrange,
                                  cursorWidth: 8,
                                  cursorRadius: Radius.circular(8),
                                  textInputAction: TextInputAction.next,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Please enter atleast one character';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (val) {
                                    _bodyFocus.requestFocus();
                                  },
                                  onSaved: (val) {
                                    currObject = PostObject(
                                      currObject.userId,
                                      currObject.postId,
                                      val,
                                      currObject.postBody,
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    maxLines: 5,
                                    decoration: decorator('Body', 2),
                                    cursorColor: Colors.deepOrange,
                                    cursorWidth: 8,
                                    cursorRadius: Radius.circular(8),
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: _bodyFocus,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'C\'mon. Please enter something.';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      currObject = PostObject(
                                        currObject.userId,
                                        currObject.postId,
                                        currObject.postTitle,
                                        val,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RaisedButton(
                                    onPressed: _post,
                                    color: Colors.deepOrange,
                                    padding: EdgeInsets.all(12),
                                    elevation: 16,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: myText('Post'),
                                  ),
                                ),
                                OutlineButton(
                                  onPressed: _viewPosts,
                                  child: myText('View Posts'),
                                  color: Colors.deepOrange,
                                  padding: EdgeInsets.all(12),
                                  highlightColor: Colors.deepOrange.withOpacity(0.5),
                                  highlightElevation: 16,
                                  borderSide: BorderSide(color: Colors.deepOrange, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Contact->',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              RotateAnimatedTextKit(
                                onTap: () {},
                                repeatForever: true,
                                duration: Duration(seconds: 20),
                                displayFullTextOnTap: true,
                                text: [
                                  "Rishabh Raizada",
                                  "rishabh5102000@gmail.com",
                                  "+91 8860932771",
                                ],
                                textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _controllerCenter,
                      blastDirectionality: BlastDirectionality.explosive,
                      // don't specify a direction, blast randomly
                      shouldLoop: false,
                      // start again as soon as the animation is finished
                      colors: _colorList2,
                      numberOfParticles: 50,
                      gravity: 0.2,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _viewPosts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url);
      final posts = json.decode(response.body) as List<dynamic>;
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => PostsView(posts: posts)));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      _showDialogError(context, error);
      throw (error);
    }
  }

  Future<void> _post() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    await http.post(
      url,
      body: json.encode({
        'userId': currObject.userId,
        'id': currObject.postId,
        'title': currObject.postTitle,
        'body': currObject.postBody,
      }),
    );
    currObject = PostObject(
      (currObject.userId % 10 == 0) ? currObject.userId + 1 : currObject.userId,
      currObject.postId + 1,
      currObject.postTitle,
      currObject.postBody,
    );
    setState(() {
      _isLoading = false;
    });
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      _controllerCenter.play();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: myText('Posted successfully'),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 16,
        backgroundColor: Colors.deepOrange,
      ));
    });
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
