import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_freshchat/flutter_freshchat.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print(await FlutterFreshchat.init(
        appID: "c55cfd7e-b3d1-4496-a85e-bbb477bf12b4",
        appKey: "4d17dc37-4aca-4c6f-bd5d-8ae660d9cf33"));
    await FlutterFreshchat.updateUserInfo(
        firstName: "fayeed", email: "fayeed@live.com");
    print(await FlutterFreshchat.identifyUser(externalID: "fayeed@live.com"));
    await FlutterFreshchat.showConversations();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
