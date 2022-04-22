import 'package:Fuligo/utils/common_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupWidget extends StatefulWidget {
  const PopupWidget({Key? key}) : super(key: key);

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

enum lang { de_CH, en_GB, nl_NL }

class _PopupWidgetState extends State<PopupWidget> {
  void initState() {
    getLang();
  }

  Future<void> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang') ?? "en_GB";
    print("CURRENT RANG");
    print(lang);
  }

  lang? _mitem = lang.en_GB;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Select Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    )),
              ),
            ],
          ),
          ListTile(
            minVerticalPadding: 0,
            title: const Text(
              'Germany',
              style: TextStyle(color: whiteColor),
            ),
            trailing: Radio<lang>(
              activeColor: whiteColor,
              value: lang.de_CH,
              groupValue: _mitem,
              onChanged: (lang? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),
          // const Divider(
          //   thickness: 2,
          //   color: Colors.grey,
          // ),
          ListTile(
            title: const Text(
              'English',
              style: TextStyle(color: whiteColor),
            ),
            trailing: Radio<lang>(
              value: lang.en_GB,
              activeColor: whiteColor,
              groupValue: _mitem,
              onChanged: (lang? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),

          ListTile(
            title: const Text(
              'Detch',
              style: TextStyle(color: whiteColor),
            ),
            trailing: Radio<lang>(
              activeColor: whiteColor,
              value: lang.nl_NL,
              groupValue: _mitem,
              onChanged: (lang? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  saveLang(_mitem);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: const Center(
                    child: Text('APPLY',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1.2)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: const Center(
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1.2)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveLang(lang) async {
    print(lang);
    switch (lang.toString()) {
      case "lang.en_GB":
        print(lang);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "en_GB");
        break;
      case "lang.de_CH":
        print(lang);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "de_CH");
        break;

      case "lang.nl_NL":
        print(lang);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "nl_NL");
        break;

      default:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "en_GB");
    }
    SmartDialog.showToast("changed language");
  }
}
