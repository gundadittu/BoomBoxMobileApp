// Flutter/Dart dependencies
import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
//External dependencies
import 'package:open_mail_app/open_mail_app.dart';

import 'auth_screen_model.dart';

import '../../error_manager.dart';

// TO DO:
// - add proper background + logo + etc.
// - add smoother animation when screen widgets move up on keyboard appearance

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
  }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthScreenModel screenModel;

  Map<String, String> _formData = {
    'email': '',
  };

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    final userEmail = _formData['email'];

    screenModel.sendEmailWithAuthLink(userEmail);
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

  buildContent(AuthScreenModel screenModel) {
    this.screenModel = screenModel;

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
                              enabled:
                                  !(screenModel.sendEmailWithAuthLinkStatus ==
                                      SendEmailWithAuthLinkStatus.loading),
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
                            onPressed:
                                (screenModel.sendEmailWithAuthLinkStatus ==
                                        SendEmailWithAuthLinkStatus.loading)
                                    ? null
                                    : _submitForm,
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
                                    child: screenModel
                                                .sendEmailWithAuthLinkStatus ==
                                            SendEmailWithAuthLinkStatus.loading
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthScreenModel>(
      converter: (store) => AuthScreenModel.fromStore(store),
      builder: (_, screenModel) => buildContent(screenModel),
      onDidChange: (screenModel) {
        if (screenModel.sendEmailWithAuthLinkStatus ==
            SendEmailWithAuthLinkStatus.success) {
          _showOpenMailAppInstructions();
        } else if (screenModel.sendEmailWithAuthLinkStatus ==
            SendEmailWithAuthLinkStatus.failureInvalidEmail) {
          // TODO: SHOW ERROR DIALOG
          ErrorManager.showErrorDialog(
              context, "The provided email was invalid.");
        } else if (screenModel.sendEmailWithAuthLinkStatus ==
            SendEmailWithAuthLinkStatus.failureUnknown) {
          ErrorManager.showErrorDialog(context,
              "Something went wrong. We couldn't send you a log in link. We've been notified.");
        } else if (screenModel.verifyEmailAuthLinkStatus ==
            VerifyEmailAuthLinkStatus.failureInvalidExpiredLink) {
          ErrorManager.showErrorDialog(context,
              "Looks like you used an expired link to sign in. Please try again with a valid link.");
        } else if (screenModel.verifyEmailAuthLinkStatus ==
            VerifyEmailAuthLinkStatus.failureUserDisabled) {
          ErrorManager.showErrorDialog(
              context, "This user's account has been disabled.");
        } else if (screenModel.verifyEmailAuthLinkStatus ==
            VerifyEmailAuthLinkStatus.failureUnknown) {
          ErrorManager.showErrorDialog(context,
              "Something went wrong. We couldn't sign you in. We've been notified.");
        }
      },
    );
  }
}
