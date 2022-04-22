import 'package:Fuligo/utils/common_functions.dart';
import 'package:Fuligo/utils/common_header_list.dart';
import 'package:flutter/material.dart';
import 'package:Fuligo/screens/auth/login.dart';
import 'package:Fuligo/widgets/custom_button.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:Fuligo/widgets/logo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String pageName = HeaderList.explorer;
  String? title = EXPLORER["title"];
  String? subtitle = EXPLORER["subtitle"];
  List<String> headerList = [];
  @override
  void initState() {
    super.initState();
    getHeaderData(pageName);
  }

  void getHeaderData(pageName) async {
    headerList = await getTitle(pageName);
    title = headerList[0];
    subtitle = headerList[1];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/explore.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Logo,
                  PageHeader(context, title!, subtitle!),
                ],
              ),
            ),
            PrimaryButton(context, const Login(), "Next")
          ],
        ),
      ),
    );
  }
}
