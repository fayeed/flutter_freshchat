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

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _countryCode = "";
  String _phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Update User Info"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'xyz', labelText: 'Enter Firstname'),
                onSaved: (value) {
                  this._firstName = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'xyz', labelText: 'Enter Lastname'),
                onSaved: (value) {
                  this._lastName = value;
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '+91', labelText: 'Country Code'),
                      onSaved: (value) {
                        this._countryCode = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter some text";
                        } else if (value.length < 2) {
                          return "Please enter 3 characters";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '0123456789', labelText: 'Phone Number'),
                      onSaved: (value) {
                        this._phone = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter some text";
                        }
                      },
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    await storage.setItem('uid', this._email);

                    User user = User.initail();
                    user.email = _email;
                    user.firstName = _firstName;
                    user.lastName = _lastName;
                    user.phoneCountryCode = _countryCode;
                    user.phone = _phone;

                    await FlutterFreshchat.updateUserInfo(user: user);

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
