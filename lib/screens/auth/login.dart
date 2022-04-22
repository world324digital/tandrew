// ignore_for_file: unused_local_variable

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/screens/verify.dart';
import 'package:Fuligo/utils/common_functions.dart';
import 'package:Fuligo/utils/common_header_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Fuligo/repositories/user_repository.dart';
import 'package:Fuligo/widgets/custom_button.dart';
import 'package:Fuligo/widgets/logo.dart';

import 'package:Fuligo/routes/route_costant.dart';
import 'package:Fuligo/widgets/text_header.dart';

import 'package:Fuligo/utils/localtext.dart';

//import firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../VerifyTracking.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String page = HeaderList.discover;
  String title = '';
  String subtitle = '';
  List<String> headerList = [];
  TextEditingController emailCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  @override
  void initState() {
    super.initState();
    getHeaderData(page);
    _initializeFirebase();
    setState(() {
      emailCtl.text = "";
    });

    // setState(() {});
  }

  void getHeaderData(pageName) async {
    headerList = await getTitle(pageName);
    title = headerList[0];
    subtitle = headerList[1];
    setState(() {});
  }

  Future<void> getUser(User user) async {
    final result = await UserRepository.getUserByID(user.uid);
    String url = "";

    var refId = result["avatar"];

    refId.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (result != null) {
          result["avatar"] = documentSnapshot["app_img"];
          UserModel _userModel = UserModel.fromJson(result);
          AuthProvider.of(context).setUserModel(_userModel);
        }
      }
    });
  }

  Future<void> addNewUser(User user) async {
    print("add User");
    await UserRepository.addUser(user.uid);
    await getUser(user);
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  void login() async {
    String email = emailCtl.text;
    String pwd = "123123";

    bool isValid = EmailValidator.validate(email);
    if (!isValid) {
      SmartDialog.showToast("email invalid");
      return;
    } else {
      SmartDialog.showLoading(
          backDismiss: false, background: Colors.transparent);

      int _result = 0;

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pwd);

        await getUser(userCredential.user!);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: pwd);

          await addNewUser(userCredential.user!);
        }
      }
      SmartDialog.dismiss();
      await enableTracking();
    }
  }

  Future<void> enableTracking() async {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Enable tracking?"),
        content: Text("Are you really?"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancel"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Verify()),
              );
            },
          ),
          BasicDialogAction(
            title: Text("Confirm"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyTracking(permission: "true")),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> toDoResult(int result) async {
    switch (result) {
      case 1:
        SmartDialog.showToast(
          LocalText.LoginSuccess,
        );
        // Navigator.of(context).pushReplacementNamed(RouteName.Verify);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Verify(),
          ),
        );

        break;

      case 2:
        SmartDialog.showToast(
          LocalText.SignupandLogin,
        );
        Navigator.of(context).pushReplacementNamed(RouteName.Verify);
        break;

      case 3:
        SmartDialog.showToast(LocalText.WrongPwd);
        break;
      default:
        SmartDialog.showToast(
          LocalText.NetError,
          alignment: Alignment.topCenter,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/discover.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Logo,
                    PageHeader(context, title, subtitle),
                  ],
                ),
              ),
              Positioned(
                bottom: 80,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 340),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailCtl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      autocorrect: true,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter a email',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white60,
                        ),
                        fillColor: Colors.grey,
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              LoginButton(
                  context,
                  () => {
                        if (_formKey.currentState!.validate()) {login()}
                      },
                  "Next")
            ],
          ),
        ),
      ),
    );
  }
}
