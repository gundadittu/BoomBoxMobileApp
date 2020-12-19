// Flutter/Dart dependencies
import 'package:flutter/material.dart';

// Internal dependencies
import '../error_manager.dart';
import '../provider/auth_manager.dart';

//External dependencies
import 'package:provider/provider.dart';
import 'package:open_mail_app/open_mail_app.dart';

// TO DO:
// - add proper background + logo + etc.
// - add smoother animation when screen widgets move up on keyboard appearance

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
  }) : super(key: key);

  static final routeName = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

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
      try {
        _showOpenMailAppInstructions();
      } catch (e, stackTrace) {
        // Allows us to keep track of whether users are having issues with the mail app picker
        ErrorManager.reportError(e, stackTrace);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // this error is already reported in AuthManager.sendEmailWithAuthLink
      ErrorManager.showErrorDialog(context, error.toString());
    }
  }

  void _showOpenMailAppInstructions() {
    void _showNoMailAppsDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Open Mail App"),
            content: Text("No mail apps installed"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                RaisedButton(
                  child: Text("Open Mail App"),
                  onPressed: () async {
                    Navigator.pop(context);
                    // Android: Will open mail app or show native picker.
                    // iOS: Will open mail app if single mail app found.
                    var result = await OpenMailApp.openMailApp();

                    // If no mail apps found, show error
                    if (!result.didOpen && !result.canOpen) {
                      _showNoMailAppsDialog(context);

                      // iOS: if multiple mail apps found, show dialog to select.
                      // There is no native intent/default app system in iOS so
                      // you have to do it yourself.
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: bottomPadding,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child:
                        Column(), // add logo, etc. here + pin to top of screen
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
                                  return 'Must enter a valid email';
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
                            horizontal: 20,
                            vertical: 10,
                          ),
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: _isLoading
                                        ? CircularProgressIndicator()
                                        : Icon(
                                            Icons.navigate_next_outlined,
                                            size: 25,
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
      ),
    );
  }
}
