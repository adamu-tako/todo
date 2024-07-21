import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Authform extends StatefulWidget {
  const Authform({super.key});

  @override
  State<Authform> createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool _isLogin = true;

  startAuthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (_isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 200.0, horizontal: 0.0),
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                            key: const ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email address',
                                labelStyle: GoogleFonts.roboto(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          if (!_isLogin)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Your username must be at least 7 characters';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _username = newValue!;
                                },
                                key: const ValueKey('username'),
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Enter your username',
                                    labelStyle: GoogleFonts.roboto(),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Your password must be at least 7 characters';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _password = newValue!;
                              },
                              key: const ValueKey('password'),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  labelStyle: GoogleFonts.roboto(),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  startAuthentication();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  backgroundColor: Colors.greenAccent,
                                ),
                                child: Text(_isLogin ? 'Login' : 'Signup',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontSize: 18.0,
                                    )),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                  _isLogin
                                      ? 'Create new account'
                                      : 'I already have an account',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                  )))
                        ]))),
          ],
        ),
      ),
    );
  }
}
