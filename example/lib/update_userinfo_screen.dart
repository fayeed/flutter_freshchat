import 'package:flutter/material.dart';
import 'package:flutter_freshchat/flutter_freshchat.dart';
import 'package:localstorage/localstorage.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateUserInfoState();
  }
}

class UpdateUserInfoState extends State<UpdateUserInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('example_storage');

  String _fullName = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Update User Info"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: 300,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'xyz', labelText: 'Enter Fullname'),
                onSaved: (value) {
                  this._fullName = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'xyz@test.com',
                    labelText: 'Eenter Email address'),
                onSaved: (value) {
                  print(value);
                  this._email = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                },
              ),
              RaisedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    print(this._fullName);
                    await storage.setItem('uid', this._email);

                    await FlutterFreshchat.updateUserInfo(
                        firstName: this._fullName, email: this._email);

                    scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("Clicked")));
                  }
                },
                child: Text("submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
