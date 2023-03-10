import 'package:merchandising/ConstantMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:merchandising/HR/addreport.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:merchandising/api/HRapi/empdetailsapi.dart';
import 'package:merchandising/api/HRapi/empdetailsforreportapi.dart';
import 'package:merchandising/api/FMapi/cdereportapi.dart';
import 'package:merchandising/Fieldmanager/add_rep.dart';
import 'package:merchandising/utils/background.dart';

class  CDEReportScreen extends StatefulWidget {
  @override
  _CDEReportScreenState createState() => _CDEReportScreenState();
}

class _CDEReportScreenState extends State<CDEReportScreen> {
  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  List<dynamic> inputlist;
  List<String> _filterList;
  List<String> _filterList_Mer_Name;
  List<String> _filterList_Mer_SName;
  List<String> _filterList_Cde_Name;
  List<String> _filterList_Cde_SName;
  List<String> _filterreportingList;
  List<String> _filterstartList;
  List<String> _filterendList;

  @override
  void initState() {
    super.initState();
    inputlist = CDEreportdata.merchandisersid;
  }

  _CDEReportScreenState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Text(
            "CDE Reporting",
            style: TextStyle(color: orange),
          ),
        ),
        // drawer: Drawer(
        //   child: Menu(),
        // ),
        body: Stack(
          children: [
            BackGround(),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: new Column(
                children: <Widget>[
                  _createSearchView(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _firstSearch ? _createListView() : _performSearch(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Addreportcdescreen()));
                  },
                  backgroundColor: pink,
                  elevation: 8.0,
                  child: Icon(
                    Icons.add,
                    color: orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSearchView() {
    return new Container(
      padding: EdgeInsets.only(left: 20.0),
      width: double.infinity,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: pink, borderRadius: BorderRadius.circular(25.0)),
      child: new TextField(
        style: TextStyle(color: orange),
        controller: _searchview,
        cursorColor: orange,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          focusColor: orange,
          hintText: 'Search by name',
          hintStyle: TextStyle(color: orange),
          border: InputBorder.none,
          icon: Icon(
            CupertinoIcons.search,
            color: orange,
          ),
          suffixIcon: IconButton(
            onPressed: (){
              _searchview.clear();
            },
            icon: Icon(
              CupertinoIcons.clear_circled_solid,
              color: orange,
            ),
          ),
          isCollapsed: true,
        ),
      ),
    );
  }

  Widget _createListView() {
     return new Flexible(
      child: new ListView.builder(


          itemCount: CDEreportdata.merchandisersid.length,
          itemBuilder: (BuildContext context, int index) {
             return Container(
              height: 130,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          "Merchandiser: ${CDEreportdata.mername[index] + " " + CDEreportdata.mersname[index] + "(" + CDEreportdata.merchandisersid[index] + ")"}",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Reporting CDE:',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          CDEreportdata.cdeempname[index] +
                              " " +
                              CDEreportdata.cdeempsname[index] +
                              "(" +
                              CDEreportdata.cdeempid[index] +
                              ")",
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Start Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(CDEreportdata.startdate[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('End Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${CDEreportdata.enddate[index]}',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterendList = [];
    _filterList_Mer_Name = [];
    _filterList_Mer_SName = [];
    _filterList_Cde_Name = [];
    _filterList_Cde_SName = [];
    _filterstartList = [];
    _filterreportingList = [];
    for (int i = 0; i < CDEreportdata.merchandisersid.length; i++) {
      var item = CDEreportdata.mername[i];
      if (item.trim().toLowerCase().contains(_query.trim().toLowerCase())||CDEreportdata.mersname[i].trim().toString().toLowerCase().contains(_query.trim().toLowerCase())) {
        _filterList.add(CDEreportdata.merchandisersid[i]);
        int index = CDEreportdata.merchandisersid.indexOf(item);
        _filterreportingList.add(CDEreportdata.cdeempid[i]);

        _filterList_Mer_Name.add(CDEreportdata.mername[i]);
        _filterList_Mer_SName.add(CDEreportdata.mersname[i]);

        _filterList_Cde_Name.add(CDEreportdata.cdeempname[i]);
        _filterList_Cde_SName.add(CDEreportdata.cdeempsname[i]);
        _filterstartList.add(CDEreportdata.startdate[i]);
        _filterendList.add(CDEreportdata.enddate[i]);
      }
    }

    // print(_filterList_Cde_Name);

    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 130,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          "Merchandiser: ${_filterList_Mer_Name[index] + " " + _filterList_Mer_SName[index] + "(" + _filterList[index] + ")"}",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Reporting CDE:',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          _filterList_Cde_Name[index] +
                              " " +
                              _filterList_Cde_SName[index] +
                              "(" +
                              _filterreportingList[index] +
                              ")",
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Start Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_filterstartList[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('End Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${_filterendList[index]}',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
