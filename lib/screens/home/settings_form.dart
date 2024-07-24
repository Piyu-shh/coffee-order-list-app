import 'package:auth/model/userId.dart';
import 'package:auth/services/database.dart';
import 'package:auth/shared/constants.dart';
import 'package:auth/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugar = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userid?>(context);
    return StreamBuilder<UserData>(
        stream: user != null ? DatabaseService(uid: user.uid).userData : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData?.name,
                      decoration:
                          textInputDecoration.copyWith(labelText: 'Name: '),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Valid Name' : null,
                      onChanged: (value) =>
                          setState(() => _currentName = value),
                    ),
                    SizedBox(height: 20.0),
                    //doropdow
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Sugar Cubes: '),
                      value: _currentSugars ?? userData?.sugar,
                      items: sugar.map((sugar) {
                        return DropdownMenuItem(
                            value: sugar, child: Text('$sugar sugars'));
                      }).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            if (value != null)
                              _currentSugars = value.toString();
                          },
                        );
                      },
                    ),
                    //slider
                    Row(
                      children: [
                        Text(
                          'Strength :',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 18,
                              // Keep the active part thickness same for consistency
                            ),
                            child: Slider(
                              label: '$_currentStrength',
                              value: (_currentStrength ?? userData!.strength)
                                  .toDouble(),
                              activeColor:
                                  Colors.brown[_currentStrength ?? 100],
                              inactiveColor: Colors
                                  .brown[_currentStrength ?? 100]
                                  ?.withOpacity(
                                      0.5), // Optional: Make inactive color slightly transparent
                              min: 100,
                              max: 900,
                              divisions: 8,
                              onChanged: (value) {
                                setState(() {
                                  _currentStrength = value.round();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 222, 98, 89),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService(uid: user?.uid)
                                .updateUserData(
                                    _currentSugars ?? userData!.sugar,
                                    _currentName ?? userData!.name,
                                    _currentStrength ?? userData!.strength);
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
