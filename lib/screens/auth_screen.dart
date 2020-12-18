// Flutter/Dart dependencies
import 'package:flutter/material.dart';

// Internal dependencies
import '../provider/auth_manager.dart';

//External dependencies
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
  }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // TextEditingController _emailInputController;
  var _isLoading = false;
  Map<String, String> _formData = {
    'email': '',
  };

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final userEmail = _formData['email'];
      await Provider.of<AuthManager>(context, listen: false)
          .sendEmailWithAuthLink(userEmail);
      // navigate user to next screen

    } catch (error) {
      throw error; // handle and display error here 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(), // add logo, etc. here + pin to top of screen
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you a ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                text: 'login url ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'to this email address.',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          height: 60,
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              border: const OutlineInputBorder(),
                            ),
                            // controller: _emailInputController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            enabled: !_isLoading,
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@")) {
                                return 'Invalid Email!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _formData['email'] = value;
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        child: RaisedButton(
                          onPressed: _submitForm,
                          color: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.black,
                                  ),
                                  child: Icon(
                                    Icons.navigate_next_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
