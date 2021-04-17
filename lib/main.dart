import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Apps',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Multi-Select Checkbox with Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _selecteCategorys = List();
  String pilihTopping = "";

  Map<String, dynamic> _categories = {
    "responseCode": "1",
    "responseText": "List categories.",
    "responseBody": [
      {"category_id": "1", "category_name": "Boba"},
      {"category_id": "2", "category_name": "Ceres"},
      {"category_id": "3", "category_name": "Jelly"},
      {"category_id": "4", "category_name": "Keju"}
    ],
    "responseTotalResult":
        3 // Total result is 3 here becasue we have 3 categories in responseBody.
  };

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
      });
    }
  }

  void _mulaiPilih() async {
    Timer(Duration(seconds: 2), () {
      setState(() {
        dialogHasil(pilihTopping);
      });
      _btnController.success();
      _btnController.reset();
    });
  }

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  Widget _buttonPilih(BuildContext context) {
    return RoundedLoadingButton(
      child: Text('PILIH TOPPING', style: TextStyle(color: Colors.white)),
      controller: _btnController,
      onPressed: _mulaiPilih,
      width: 200,
    );
  }

  SliverChildBuilderDelegate _buildSliverChildBuilderDelegate() {
    return SliverChildBuilderDelegate((context, index) {
      switch (index) {
        case 0:
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                  child: Row(children: <Widget>[
                Expanded(
                    child: SizedBox(
                        height: 240.0,
                        child: new ListView.builder(
                            itemCount: _categories['responseTotalResult'],
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                value: _selecteCategorys.contains(
                                    _categories['responseBody'][index]
                                        ['category_id']),
                                onChanged: (bool selected) {
                                  _onCategorySelected(
                                      selected,
                                      _categories['responseBody'][index]
                                          ['category_id']);
                                  pilihTopping = _selecteCategorys.toString();
                                },
                                title: Text(_categories['responseBody'][index]
                                    ['category_name']),
                              );
                            })))
              ])));
        case 1:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buttonPilih(context),
          );
      }
      return null;
    });
  }

  //Pop Up
  dialogHasil(String txtHasil) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Kamu Memilih Topping: \n " + txtHasil,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 15.0),
          color: Color.fromRGBO(255, 255, 255, 1),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.only(top: 1),
                sliver: SliverList(
                  delegate: _buildSliverChildBuilderDelegate(),
                ),
              )
            ],
          ),
        ));
  }
}
