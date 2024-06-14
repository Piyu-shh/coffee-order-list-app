import 'package:auth/services/auth.dart';
import 'package:auth/shared/constants.dart';
import 'package:auth/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign In Bro'),
              actions: [
                ElevatedButton.icon(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: Text("Sign In"),
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email'),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter an Email' : null,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Password'),
                          validator: (value) => value!.length < 6 ? '6+' : null,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[400]),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                if (mounted) {
                                  setState(() {
                                    error = 'please supply a valid error';
                                    loading = false;
                                  });
                                }
                              } else {}
                            }
                          },
                        ),
                      ],
                    ))),
          );
  }
}
