import 'package:flutter_catat_order/auth/auth.dart';
// import 'package:flutter_catat_order/profil_page.dart';
import 'package:flutter_catat_order/auth/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/auth/sign_in.dart';
import 'package:flutter_catat_order/auth/first_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); //membuat key
  TextEditingController emailController =
      TextEditingController(); //membuat controller
  TextEditingController passwordController = TextEditingController();
  var authHandler = new Auth(); //membuat authHandler

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  _showLogin(),
                  _formLogin(),
                  _loginButton(),
                  _textOr(),
                  _signInButton(),
                ]),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Don’t have account ?",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          "Register here",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLogin() {
    return Padding(
      padding: EdgeInsets.only(top: 60, bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 36, letterSpacing: 5),
          ),
        ],
      ),
    );
  }

//membuat form untuk login
  Widget _formLogin() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.yellow[200],
          ),
          //membuuat form email
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.grey[850]),
              hintText: "Email",
              border: InputBorder.none,
            ),
            validator: (value) {
              //kondisi ketika memasukkan email
              if (value.isEmpty) {
                return 'Enter an Email Address';
              } else if (!value.contains('@')) {
                return 'Please enter a valid email address'; //email harus menggunakan @
              }
              return null;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.yellow[200],
          ),
          //membuat form password
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              border: InputBorder.none,
              icon: Icon(
                Icons.vpn_key,
                color: Colors.grey[850],
              ),
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                //kondisi ketika input password
                return 'Enter Password';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters!'; //password min 6 karakter
              }
              return null;
            },
          ),
        ),
      ]),
    );
  }

//memastikan inputan email
  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: TextFormField(
        // onSaved: (val) => _email = val,
        validator: (val) => !val.contains("@") ? "Invalid Email" : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Enter Valid Email",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
      ),
    );
  }

//memastikan inputan password
  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: TextFormField(
        // onSaved: (val) => _password = val,
        validator: (val) => val.length < 6 ? "Password Is Too Short" : null,
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "Enter Valid Password",
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
      ),
    );
  }

//membuat button untuk login
  Widget _loginButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        onPressed: () {
          authHandler //auth pada auth.dart
              .handleSignInEmail(emailController.text, passwordController.text)
              .then((User user) {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new FirstScreen()));
          }).catchError((e) => print(e));
        },
        child: Text(
          "Login",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        color: Colors.yellow,
        elevation: 0,
      ),
    );
  }

//menampilkan teks or
  Widget _textOr() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
        SizedBox(width: 20),
        Text(
          "OR",
          // style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Divider(
            //menampilkan garis
            thickness: 1,
          ),
        ),
      ],
    );
  }

//membuat button sign in
  Widget _signInButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        color: Colors.yellow,
        onPressed: () {
          signInWithGoogle().then((result) {
            if (result != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FirstScreen();
                  },
                ),
              );
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: NetworkImage(//menampilkan gambar google
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png'),
                height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Login with Google',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}