import 'package:Fuligo/utils/common_colors.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_button.dart';

class SettingTest extends StatefulWidget {
  const SettingTest({Key? key}) : super(key: key);

  @override
  SettingTestState createState() => SettingTestState();
}

enum lang { de_CH, en_GB, nl_NL }
const List = ["English", "Germany", "Detch"];

/// Main example page
class SettingTestState extends State<SettingTest> //__
{
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  String currentLang = "";

  void initState() {
    getLang();
  }

  lang? _mitem;
  Future<void> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('lang') ?? "en_GB";
    setState(() {
      currentLang = language;
    });
    switch (language) {
      case "en_GB":
        _mitem = lang.en_GB;
        break;
      case "de_CH":
        _mitem = lang.de_CH;
        break;
      case "nl_NL":
        _mitem = lang.nl_NL;
        break;
      default:
        _mitem = lang.en_GB;
    }
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Accordion(
          paddingListTop: 0,
          maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          children: [
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.settings, color: Colors.white),
              headerBackgroundColor: Colors.black,
              headerBackgroundColorOpened: Colors.red,
              header: Text('Language', style: _headerStyle),

              content: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(color: whiteColor),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      minVerticalPadding: 0,
                      title: const Text(
                        'Germany',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Radio<lang>(
                        activeColor: Colors.black,
                        value: lang.de_CH,
                        groupValue: _mitem,
                        onChanged: (lang? value) {
                          saveLang(value);
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
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Radio<lang>(
                        value: lang.en_GB,
                        activeColor: Colors.black,
                        groupValue: _mitem,
                        onChanged: (lang? value) {
                          saveLang(value);
                          setState(() {
                            _mitem = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        'Detch',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Radio<lang>(
                        activeColor: Colors.black,
                        value: lang.nl_NL,
                        groupValue: _mitem,
                        onChanged: (lang? value) {
                          saveLang(value);
                          setState(() {
                            _mitem = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              // sectionClosingHapticFeedback: SectionHapticFeedback.vibrate,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.compare_rounded, color: Colors.white),
              header: Text('About Us', style: _headerStyle),
              contentBorderColor: const Color(0xffffffff),
              headerBackgroundColorOpened: Colors.amber,
              content: Row(
                children: [
                  const Icon(Icons.compare_rounded,
                      size: 120, color: Colors.orangeAccent),
                  Flexible(
                      flex: 1, child: Text(_loremIpsum, style: _contentStyle)),
                ],
              ),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.food_bank, color: Colors.white),
              header: Text('Company Info', style: _headerStyle),
              content: DataTable(
                sortAscending: true,
                sortColumnIndex: 1,
                dataRowHeight: 40,
                showBottomBorder: false,
                columns: [
                  DataColumn(
                      label: Text('ID', style: _contentStyleHeader),
                      numeric: true),
                  DataColumn(
                      label: Text('Description', style: _contentStyleHeader)),
                  DataColumn(
                      label: Text('Price', style: _contentStyleHeader),
                      numeric: true),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('1',
                          style: _contentStyle, textAlign: TextAlign.right)),
                      DataCell(Text('Fancy Product', style: _contentStyle)),
                      DataCell(Text(r'$ 199.99',
                          style: _contentStyle, textAlign: TextAlign.right))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('2',
                          style: _contentStyle, textAlign: TextAlign.right)),
                      DataCell(Text('Another Product', style: _contentStyle)),
                      DataCell(Text(r'$ 79.00',
                          style: _contentStyle, textAlign: TextAlign.right))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('3',
                          style: _contentStyle, textAlign: TextAlign.right)),
                      DataCell(Text('Really Cool Stuff', style: _contentStyle)),
                      DataCell(Text(r'$ 9.99',
                          style: _contentStyle, textAlign: TextAlign.right))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('4',
                          style: _contentStyle, textAlign: TextAlign.right)),
                      DataCell(
                          Text('Last Product goes here', style: _contentStyle)),
                      DataCell(Text(r'$ 19.99',
                          style: _contentStyle, textAlign: TextAlign.right))
                    ],
                  ),
                ],
              ),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.computer, color: Colors.white),
              header: Text('Jobs', style: _headerStyle),
              content: const Icon(Icons.computer,
                  size: 200, color: Color(0xff999999)),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.movie, color: Colors.white),
              header: Text('Culture', style: _headerStyle),
              content:
                  const Icon(Icons.movie, size: 200, color: Color(0xff999999)),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.people, color: Colors.white),
              header: Text('Community', style: _headerStyle),
              content:
                  const Icon(Icons.people, size: 200, color: Color(0xff999999)),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.map, color: Colors.white),
              header: Text('Map', style: _headerStyle),
              content:
                  const Icon(Icons.map, size: 200, color: Color(0xff999999)),
            ),
          ],
        ),
        CrossButton(context),
      ],
    );
  }

  @override
//   build(context) => Scaffold(
//         backgroundColor: Colors.blueGrey[100],
//         appBar: AppBar(
//           title: const Text('Settings'),
//         ),
//         body: Accordion(
//           maxOpenSections: 1,
//           headerBackgroundColorOpened: Colors.black54,
//           headerPadding:
//               const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
//           children: [
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.settings, color: Colors.white),
//               headerBackgroundColor: Colors.black,
//               headerBackgroundColorOpened: Colors.red,
//               header: Text('Language', style: _headerStyle),

//               content: Container(
//                 padding: EdgeInsets.all(0),
//                 decoration: BoxDecoration(color: whiteColor),
//                 child: Column(
//                   children: <Widget>[
//                     ListTile(
//                       minVerticalPadding: 0,
//                       title: const Text(
//                         'Germany',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       trailing: Radio<lang>(
//                         activeColor: Colors.black,
//                         value: lang.de_CH,
//                         groupValue: _mitem,
//                         onChanged: (lang? value) {
//                           print("Germany");
//                           saveLang(value);
//                           setState(() {
//                             _mitem = value;
//                           });
//                         },
//                       ),
//                     ),
//                     // const Divider(
//                     //   thickness: 2,
//                     //   color: Colors.grey,
//                     // ),
//                     ListTile(
//                       title: const Text(
//                         'English',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       trailing: Radio<lang>(
//                         value: lang.en_GB,
//                         activeColor: Colors.black,
//                         groupValue: _mitem,
//                         onChanged: (lang? value) {
//                           saveLang(value);
//                           setState(() {
//                             _mitem = value;
//                           });
//                         },
//                       ),
//                     ),

//                     ListTile(
//                       title: const Text(
//                         'Detch',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       trailing: Radio<lang>(
//                         activeColor: Colors.black,
//                         value: lang.nl_NL,
//                         groupValue: _mitem,
//                         onChanged: (lang? value) {
//                           saveLang(value);
//                           setState(() {
//                             _mitem = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
//               // sectionClosingHapticFeedback: SectionHapticFeedback.vibrate,
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.compare_rounded, color: Colors.white),
//               header: Text('About Us', style: _headerStyle),
//               contentBorderColor: const Color(0xffffffff),
//               headerBackgroundColorOpened: Colors.amber,
//               content: Row(
//                 children: [
//                   const Icon(Icons.compare_rounded,
//                       size: 120, color: Colors.orangeAccent),
//                   Flexible(
//                       flex: 1, child: Text(_loremIpsum, style: _contentStyle)),
//                 ],
//               ),
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.food_bank, color: Colors.white),
//               header: Text('Company Info', style: _headerStyle),
//               content: DataTable(
//                 sortAscending: true,
//                 sortColumnIndex: 1,
//                 dataRowHeight: 40,
//                 showBottomBorder: false,
//                 columns: [
//                   DataColumn(
//                       label: Text('ID', style: _contentStyleHeader),
//                       numeric: true),
//                   DataColumn(
//                       label: Text('Description', style: _contentStyleHeader)),
//                   DataColumn(
//                       label: Text('Price', style: _contentStyleHeader),
//                       numeric: true),
//                 ],
//                 rows: [
//                   DataRow(
//                     cells: [
//                       DataCell(Text('1',
//                           style: _contentStyle, textAlign: TextAlign.right)),
//                       DataCell(Text('Fancy Product', style: _contentStyle)),
//                       DataCell(Text(r'$ 199.99',
//                           style: _contentStyle, textAlign: TextAlign.right))
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text('2',
//                           style: _contentStyle, textAlign: TextAlign.right)),
//                       DataCell(Text('Another Product', style: _contentStyle)),
//                       DataCell(Text(r'$ 79.00',
//                           style: _contentStyle, textAlign: TextAlign.right))
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text('3',
//                           style: _contentStyle, textAlign: TextAlign.right)),
//                       DataCell(Text('Really Cool Stuff', style: _contentStyle)),
//                       DataCell(Text(r'$ 9.99',
//                           style: _contentStyle, textAlign: TextAlign.right))
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text('4',
//                           style: _contentStyle, textAlign: TextAlign.right)),
//                       DataCell(
//                           Text('Last Product goes here', style: _contentStyle)),
//                       DataCell(Text(r'$ 19.99',
//                           style: _contentStyle, textAlign: TextAlign.right))
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.computer, color: Colors.white),
//               header: Text('Jobs', style: _headerStyle),
//               content: const Icon(Icons.computer,
//                   size: 200, color: Color(0xff999999)),
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.movie, color: Colors.white),
//               header: Text('Culture', style: _headerStyle),
//               content:
//                   const Icon(Icons.movie, size: 200, color: Color(0xff999999)),
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.people, color: Colors.white),
//               header: Text('Community', style: _headerStyle),
//               content:
//                   const Icon(Icons.people, size: 200, color: Color(0xff999999)),
//             ),
//             AccordionSection(
//               isOpen: false,
//               leftIcon: const Icon(Icons.map, color: Colors.white),
//               header: Text('Map', style: _headerStyle),
//               content:
//                   const Icon(Icons.map, size: 200, color: Color(0xff999999)),
//             ),
//           ],
//         ),
//       );
// } //__

  Future<void> saveLang(value) async {
    switch (value) {
      case lang.en_GB:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "en_GB");

        break;
      case lang.de_CH:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lang', "de_CH");
        break;

      case lang.nl_NL:
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
