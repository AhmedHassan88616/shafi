import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<Language> _languages;
  List<DropdownMenuItem<Language>> _dropDownMenuItems;
  Language _selectedLanguage;

  @override
  void initState() {
    _languages = Language.getLanguages();
    _dropDownMenuItems = buildDropDownMenuItems(_languages);
    _selectedLanguage = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ExpansionTile(
                title: Row(

                  children: [
                    Icon(Icons.public),
                    SizedBox(width: 10.0,),
                    Text('اللغة'),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton(
                        isExpanded:true,
                        items: _dropDownMenuItems,
                        value: _selectedLanguage,
                        onChanged: onChangeDropDownItem,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<Language>> buildDropDownMenuItems(
      List<Language> languages) {
    List<DropdownMenuItem<Language>> items = List();
    for (Language language in _languages) {
      items.add(DropdownMenuItem(
        value: language,
        child: Text(language.name),
      ));
    }
    return items;
  }

  void onChangeDropDownItem(Language value) {
    setState(() {
      _selectedLanguage = value;
    });
  }
}

class Language {
  final int id;
  final String name;

  Language(this.id, this.name);

  static List<Language> getLanguages() {
    return <Language>[Language(1, 'العربية'), Language(2, 'English')];
  }
}
