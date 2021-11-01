import 'package:flutter/material.dart';


class AuthForm extends StatefulWidget {

  final bool isLoading;

  final Function(
    String? userName,
    String? email,
    String? pass,
    bool isLogin,
    BuildContext context,
  ) submitFn;

  AuthForm( this.submitFn, this.isLoading );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();

  String? userName = '';
  String? email = '';
  String password = '';
  String prevValue = '';
  bool hidePass = true;
  //var textController = TextEditingController();
  var counterText = 0;
  var isLogin = true;

  void trySubmit() {
    
    final isValidate = _formKey.currentState!.validate();

    //to remove soft keyboard after submitting
    FocusScope.of( context ).unfocus();
    
    if (isValidate) {
      _formKey.currentState!.save();
      widget.submitFn(
        userName!.trim(),
        email!.trim(),
        password.trim(),
        isLogin,
        context,
      );
    }
  }

  Widget counter(
    BuildContext context, {
    int? currentLength,
    int? maxLength,
    required bool isFocused,
  }) {
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(
        color: Colors.grey,
      ),
      semanticsLabel: 'character count',
    );
  }

  @override
  Widget build(BuildContext context) {

    //Compruebo que el String que recibo cumple el patrón de un email
    String? pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    //Expresión regular
    RegExp regExp = new RegExp( pattern );


    return Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: ( value ) {
                      if ( regExp.hasMatch( value! ) ) {
                        return null;
                      } else {
                        return 'invalid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: ( newValue ) {
                      email = newValue;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      onChanged: (value) {
                        if (prevValue.length > value.length) {
                          setState(() {
                            counterText--;
                          });
                        } else {
                          setState(() {
                            counterText++;
                          });
                        }
                        prevValue = value;
                      },
                      validator: ( value ) {
                        if ( value!.length > 3 ) {
                          return null;
                        } else {
                          return 'username must be atleast 4 characters';
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '$counterText/20',
                        labelText: 'Username',
                      ),
                      onSaved: ( newValue ) {
                        userName = newValue;
                      },
                      maxLength: 20,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: ( value ) {
                      if ( value!.length > 7) {
                        return null;
                      } else {
                        return 'password must be atleast 8 characters';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        onPressed: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        },
                      ),
                    ),
                    obscureText: hidePass,
                    onSaved: ( newValue ) {
                      password = newValue!;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: isLogin ? Text('Login') : Text('Sign up'),
                      onPressed: trySubmit,
                    ),
                  if( !widget.isLoading )
                    ElevatedButton(
                      style:  ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        //elevation: 0,
                        //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //shape: RoundedRectangleBorder(
                        //borderRadius: BorderRadius.zero,
                        //),
                      ),
                      child: isLogin
                        ? Text('Create account')
                        : Text('I already have an account'),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
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
