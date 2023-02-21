import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/customer_activites_api/add_promotionapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Promotion%20Check.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/model/camera.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:merchandising/offlinedata/syncsendapi.dart';
import 'package:provider/provider.dart';
import '../../network/NetworkStatusService.dart';
import 'expiry_report.dart';
import 'package:merchandising/utils/background.dart';
import 'package:flutter/material.dart';

import 'outletdetailes.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/api/api_service.dart';
import '../../ConstantMethods.dart';
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'availabitiy.dart';
import 'shareofshelf.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'PlanogramcheckPhase1.dart';
import 'NPD Check.dart';
import 'CompetitionCheckOne.dart';
import 'package:merchandising/api/FMapi/nbl_detailsapi.dart';
import 'Visibility.dart';
import 'OutletSurvey.dart';
import 'Journeyplan.dart';
import 'package:merchandising/model/Location_service.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/checklist.dart';
import 'package:merchandising/api/FMapi/outlet brand mappingapi.dart';
import 'package:merchandising/model/Location_service.dart';
import 'package:merchandising/api/customer_activites_api/Competitioncheckapi.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/checkin.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Journeyplan.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/jpskippedapi.dart';
import 'package:merchandising/api/customer_activites_api/add_competitionapi.dart';
import 'package:merchandising/model/rememberme.dart';

List<bool> CheckList = [];
String from;
List<String> CheckListItems = task.list;

FocusNode focusNode = FocusNode();
String hintText = 'Search by Product Name / ZREP code';
List<String> InputList = defaulflist;

//Visibility values
List<TextEditingController> _filtergareatextfeild = [];
List<TextEditingController> _filtermainaisletextfeild = [];
List<TextEditingController> _filterpoistextfeild = [];

//Share of shelf
GlobalKey<FormState> soskey = GlobalKey<FormState>();
List<String> productlist = ShareData.categoryname;

List<String> target = ShareData.target;
List<String> productdata;

bool isApicallProcess = false;
//loadPlanogramValues
List<String> planolist = PlanoDetails.categoryname;
var _searchview = new TextEditingController();
bool _firstSearch = true;
String _query = "";
List<String> _filterList;
List<int> _filterindex;
bool connection = false;
// loadPromotionValues
List<String> productname = [];
bool isSwitched = false;
var selectedproduct;

class CustomerActivities extends StatefulWidget {
  @override
  _CustomerActivitiesState createState() => _CustomerActivitiesState();
}

class _CustomerActivitiesState extends State<CustomerActivities> {
  final GlobalKey<_CustomerActivitiesState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadValue();
    loadAvailabilityValues();
    loadVisibilityValues();
    loadShareOfShelfValues();
    loadPlanogramValues();
    loadPromotionValues();
    loadCompetitionValue();
    loadExpiryReportValues();
    loadUploadLivePhotoValues();
  }

  loadValue() async {
    CreateLog("Navigated to Activities pages", "true");
    await currentpagestatus('2', '${currentoutletid}', '${currenttimesheetid}',
        '${currentoutletindex}');

    if (checkinrequested && checkindatasubmitted) {
      Future.delayed(const Duration(seconds: 1), () {
        Flushbar(
          message: "Checkin Updated",
          duration: Duration(seconds: 5),
        )..show(context);
        checkinrequested = false;
        checkindatasubmitted = false;
      });
    } else if (checkinrequested && !checkindatasubmitted) {
      Future.delayed(const Duration(seconds: 2), () {
        Flushbar(
          message: "Error While Updating Checkin Please Try again.",
          duration: Duration(seconds: 5),
        )..show(context);
      });
      checkinrequested = false;
      checkindatasubmitted = false;
    }
    setState(() {
      isApiCallProcess = true;
    });
    await getNBLdetails();

    setState(() {
      isApiCallProcess = false;
    });
  }

  loadAvailabilityValues() async {
    print("seleccted cat..$Selectedcategory");
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          hintText = '';
        });
      } else {
        setState(() {
          hintText = 'Search by Product Name / ZREP code';
        });
      }
    });

    setState(() {
      ontapavailrefresh = true;
      isApiCallProcess = true;
    });

    await getAvaiablitity();
    setState(() {
      defaulflist = Avaiablity.fullname;
      InputList = defaulflist;
      print("defaulflist lenght...${defaulflist.length}");
      print("InputList lenght...${InputList.length}");
      print("checkValue lenght...${Avaiablity.checkvalue.length}");

      Selectedcategory = null;
      Selectedbrand = null;
      isApiCallProcess = false;
    });
  }

  loadVisibilityValues() async {
    _filtergareatextfeild = [];
    _filtermainaisletextfeild = [];
    _filterpoistextfeild = [];

    gareatextfeild = [];
    mainaisletextfeild = [];
    poistextfeild = [];
    setState(() {
      isApiCallProcess = true;
    });
    await getVisibility();
    checkvaluevisibility = [];
    visibilityreasons = [];
    dropdownreasons = [];
    imagereasons = [];
    for (int i = 0; i < VisibilityData.productname.length; i++) {
      images.add(File('dummy.txt'));
      visibilityreasons.add('');
      dropdownreasons.add('');
      imagereasons.add('');
      checkvaluevisibility.add(1);
    }
    print(images.length);
    setState(() {
      listitems = VisibilityData.categoryname;
    });
    // listitems.sort();
    setState(() {
      isApiCallProcess = false;
    });
  }

  loadShareOfShelfValues() async {
    setState(() {
      isApicallProcess = true;
    });
    actualpercent = [];
    totalshare = [];

    await getShareofshelf();

    setState(() {
      target = ShareData.target;
      productlist = ShareData.categoryname;
      productdata = productlist;
      // productdata.sort();
      isApicallProcess = false;
    });
  }

  loadPlanogramValues() async {
    setState(() {
      isApicallProcess = true;
    });
    await getPlanogram();

    setState(() {
      planolist = PlanoDetails.categoryname;
      productdata = planolist;
      // productdata.sort();
      isApicallProcess = false;
    });
    beforeimages = [];
    afterimages = [];
    beforeimagesencode = [];
    afterimagesencode = [];
    for (int i = 0; i < PlanoDetails.brandname.length; i++) {
      beforeimages.add(File('dummy.txt'));
      afterimages.add(File('dummy.txt'));
      beforeimagesencode.add('dummy.txt');
      afterimagesencode.add('dummy.txt');
    }
    print(
        "before image length..${beforeimages.length}...${PlanoDetails.categoryname.length}");
  }

  loadPromotionValues() async {
    setState(() {
      isApiCallProcess = true;
    });
    isSwitched = false;
    capturedimagepromotion = File('dummy.txt');
    selectedproduct = null;
    if (productname.isNotEmpty) {
      print("its not empty");
      productname.clear();
    }
    print("capturedimagepromotion....$capturedimagepromotion");
    await getPromotionDetails();

    setState(() {
      productname = PromoData.productname.toSet().toList();
      isApiCallProcess = false;
    });
    print("PRODUCT NAME...$productname");
  }

  loadCompetitionValue() async {
    itemname.clear();
    promtdescp.clear();
    mrp.clear();
    sellingprice.clear();
    company.clear();
    category.clear();
    promotiontype.clear();
    promodscrptn.clear();
    capturedimage = File('dummy.txt');
    compcheck = false;
    imagesbytes = null;
    imagesbytes = null;
    await SaveCompetitionData();
  }

  loadExpiryReportValues() {
    UOMValue = "PIECE";
    catName = null;
    var productname = "Select from the above";
    packtype = 'Regular';
    selectedproduct = null;
    showDrop = false;
    ENDdate = tomoroww;
    remarks.clear();
    categoryController.clear();
    productcontroller.clear();
  }

  loadUploadLivePhotoValues() async {
    setState(() {
      CheckList = [];
      // imagescl=[];
      // encodeimagecl=[];
    });

    setState(() {
      isApicallProcess = true;
    });
    await getTaskList();
    print("tasklist lenfth...${task.list.length}");
    imagescl = [];
    encodeimagecl = [];
    for (int i = 0; i < task.list.length; i++) {
      CheckList.add(false);
      print("length....${CheckList[i]}..${CheckList.length}");
      imagescl.add(File('dummy.txt'));
      encodeimagecl.add('dummy.txt');
    }
    setState(() {
      isApicallProcess = false;
    });
  }

  Offset count = Offset(20.0, 20.0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: onlinemode,
        builder: (context, value, child) {
          return WillPopScope(
            onWillPop: () async => false,
            child: ProgressHUD(
              opacity: 0.3,
              color: orange,
              inAsyncCall: isApiCallProcess,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: containerscolor,
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(color: orange),
                  title: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activities',
                            style: TextStyle(color: orange),
                          ),
                          EmpInfo()
                        ],
                      ),
                      Spacer(),
                      /*IconButton(
                          icon: Icon(
                            CupertinoIcons.refresh_circled_solid,
                            color: orange,
                            size: 30,
                          ),
                          onPressed: () async {
                            createlog("Refresh buttom from KPI tapped","true");
                            setState(() {
                              isApiCallProcess = true;
                            });
                            getNBLdetails();
                            getTaskList();
                            getAvaiablitity();
                            getVisibility();
                            getPlanogram();
                            Addedstockdataformerch();
                            getShareofshelf();
                            await getPromotionDetails();
                            setState(() {
                              isApiCallProcess = false;
                            });
                          }),*/
                      checkoutbutton(),
                    ],
                  ),
                ),
                // drawer: Drawer(
                //   child: Menu(),
                // ),
                body: OfflineNotification(
                  body: Stack(
                    children: [
                      BackGround(),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: onlinemode.value ? 0 : 25,
                            ),
                            OutletDetails(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Activities(
                                    /* completedicon: CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: avaliabilitycheck ? Colors.green : pink,*/
                                    icon: CupertinoIcons.chart_bar_alt_fill,
                                    chartext: 'Availability',
                                    tap: () async {
                                      /*print("online mode:${onlinemode.value}");
                                    if(onlinemode.value){
                                    print(Avaiablity.productname);
                                      reasons = [];
                                      outofStockitems = [];
                                    for (int i = 0;
                                        i < Avaiablity.productname.length;
                                        i++) {
                                      reasons.add('');
                                      outofStockitems.add(1);
                                    }*/

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AvailabilityScreen();
                                          },
                                        ),
                                        //  (Route<dynamic> route) => false,
                                      );
                                      /*}
                                    else {
                                      Flushbar(
                                        message: "Make sure you had an active internet\nto access Availability",
                                        duration: Duration(seconds: 3),
                                      );
                                    }*/
                                    }),
                                Activities(
                                  /*completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor:
                                      visibilitycheck ? Colors.green : pink,*/
                                  icon: CupertinoIcons.eye_solid,
                                  chartext: 'Visibility',
                                  tap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return VisibilityOne("customer");
                                        },
                                      ),
                                      // (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Activities(
                                  /*completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor:
                                      shareofshelfcheck ? Colors.green : pink,*/
                                  icon: Icons.table_chart_sharp,
                                  chartext: 'Share of Shelf',
                                  tap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ShareShelf();
                                        },
                                      ),
                                      // (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                                Activities(
                                  /* completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: planocheck ? Colors.green : pink,*/
                                  icon: CupertinoIcons.doc_checkmark_fill,
                                  chartext: 'Planogram',
                                  tap: () {
                                    /*beforeimages = [];
                                      afterimages = [];
                                      beforeimagesencode = [];
                                      afterimagesencode = [];*/

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PlanogramCheckPhase1(
                                              "customer");
                                        },
                                      ),
                                      // (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Activities(
                                  /*completedicon:CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: promocheck ? Colors.green : pink,*/
                                  icon: CupertinoIcons.checkmark_seal_fill,
                                  chartext: 'Promotion Check',
                                  tap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PromotionCheck("customer");
                                        },
                                      ),
                                      //(Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                                Activities(
                                  /* completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: compcheck ? Colors.green : pink,*/
                                  chartext: 'Compitetor info Capture',
                                  icon: CupertinoIcons.info_circle_fill,
                                  tap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CompetitionCheckOne(
                                              "customer");
                                        },
                                      ),
                                      //  (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Activities(
                                  /*completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: expirycheck ? Colors.green : pink,*/
                                  icon: CupertinoIcons.calendar_badge_minus,
                                  chartext: 'Products Expiry Info',
                                  tap: () {
                                    // addedproductname.clear();
                                    // addedexpirydate.clear();
                                    // addedpriceperitem.clear();
                                    // addeditemscount.clear();
                                    // addedexposurequnatity.clear();
                                    // addedproductid.clear();
                                    // addedremarks.clear();
                                    // addedproductlocation.clear();
                                    // addedcustomerstore.clear();
                                    // addeduom.clear();
                                    // addedproductlocation = [];
                                    // addedcustomerstore = [];
                                    // addeduom = [];
                                    // addcatname = [];
                                    getAvaiablitity();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ExpiryReport();
                                        },
                                      ),
                                      //(Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                                Activities(
                                  /* completedicon:
                                      CupertinoIcons.check_mark_circled_solid,
                                  iconcolor: checklist ? Colors.green : pink,*/
                                  icon: CupertinoIcons.text_badge_checkmark,
                                  chartext: 'CheckList',
                                  tap: () {
                                    print(task.list.length);
                                    // if (0 == 0) {
                                    setState(() {
                                      changecheckoutcolor = false;
                                    });
                                    /*CheckList = [];
                                      imagescl = [];
                                      encodeimagecl = [];*/

                                    // for (int i = 0; i < task.list.length; i++) {
                                    //   print("length....$i");
                                    //   CheckList.add(false);
                                    //   imagescl.add(File('dummy.txt'));
                                    //   encodeimagecl.add('dummy.txt');
                                    // }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UploadLivePhoto("customer")));
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      NBlFloatingButton(),
                      /*SafeArea(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: ()async{
                              checkin();
                              var breakends = DateTime.now();
                              print(breakends);
                              splitbreak.citime=checkinoutdata.checkintime;
                              splitbreak.cotime=DateFormat('HH:mm:ss').format(breakends);
                              splitbreak.type="Break";
                              splitbreak.jtimeid="";
                              // splitbreak.jtimeid=jtimeidco;
                              setState(() {
                                isApiCallProcess=true;
                              });
                              await merchbreak();
                              setState(() {
                                isApiCallProcess=false;
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BreakTime(
                                          )));
                            },
                            child: Container(
                                decoration: BoxDecoration(color: pink,
                                    borderRadius: BorderRadius.circular(10.0)),
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(10.0),
                                child: Text("BREAK",style: TextStyle(color: Colors.black),)),
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

bool iseverythingchecked = false;
bool changecheckoutcolor = false;

class Activities extends StatelessWidget {
  Activities(
      {this.icon, this.chartext, this.tap, this.completedicon, this.iconcolor});

  final icon;
  final chartext;
  final tap;
  final completedicon;
  final iconcolor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.15,
        margin: EdgeInsets.only(left: 5, bottom: 10, right: 5),
        padding: EdgeInsets.all(10.0),
        decoration:
            BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(completedicon, color: iconcolor, size: 20.0),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(icon, size: 50.0, color: Color(0xff424B4D)),
                    Text(
                      chartext,
                      style: TextStyle(fontSize: 13),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

bool isApiCallProcess = false;

bool Availability = false;

bool Visibility = false;

bool ShareofShelf = false;

bool Planogram = false;

bool compitetorcheck = false;
bool promotion = false;
bool expiryinfo = false;
bool checklist = false;

class checkoutbutton extends StatefulWidget {
  @override
  _checkoutbuttonState createState() => _checkoutbuttonState();
}

class _checkoutbuttonState extends State<checkoutbutton> {
  @override
  Widget build(BuildContext context) {
    final networkStatus = Provider.of<NetworkStatusService>(context);

    if (networkStatus.online == true) {
      setState(() {
        connection = true;
      });
    } else {
      connection = false;
    }

    return GestureDetector(
      onTap: () async {
        if (connection) {
          print("App online");
          print("checkout Button clicked");
          print("printed");
          print("currentouletid:");
          print("${currentoutletindex}");
          setState(() {
            Availability = false;
            Visibility = false;
            ShareofShelf = false;
            Planogram = false;
            promotion = false;
            compitetorcheck = false;
            expiryinfo = false;
          });

          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(builder: (context, setState) {
                    return ProgressHUD(
                      inAsyncCall: isApiCallProcess,
                      opacity: 0.3,
                      child: AlertDialog(
                        backgroundColor: alertboxcolor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        content: Builder(
                          builder: (context) {
                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppConstants.outlet_survey,
                                  style: TextStyle(color: orange, fontSize: 20),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Availability == false
                                          ? Availability = true
                                          : Availability = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppConstants.availability,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Availability == true
                                                ? CupertinoIcons
                                                    .check_mark_circled_solid
                                                : CupertinoIcons
                                                    .xmark_circle_fill,
                                            color: Availability == true
                                                ? orange
                                                : Colors.grey,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Visibility == false
                                          ? Visibility = true
                                          : Visibility = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(AppConstants.visibility,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              Visibility == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: Visibility == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ShareofShelf == false
                                          ? ShareofShelf = true
                                          : ShareofShelf = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(AppConstants.share_of_shelf,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              ShareofShelf == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: ShareofShelf == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Planogram == false
                                          ? Planogram = true
                                          : Planogram = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(AppConstants.planogram,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              Planogram == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: Planogram == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      promotion == false
                                          ? promotion = true
                                          : promotion = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(AppConstants.promotion_check,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              promotion == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: promotion == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      compitetorcheck == false
                                          ? compitetorcheck = true
                                          : compitetorcheck = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                              AppConstants
                                                  .compitetor_info_capture,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              compitetorcheck == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: compitetorcheck == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expiryinfo == false
                                          ? expiryinfo = true
                                          : expiryinfo = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(AppConstants.expiry_info,
                                              style: TextStyle(fontSize: 16)),
                                          Spacer(),
                                          Icon(
                                              expiryinfo == true
                                                  ? CupertinoIcons
                                                      .check_mark_circled_solid
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: expiryinfo == true
                                                  ? orange
                                                  : Colors.grey,
                                              size: 30),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isApiCallProcess = true;
                                        });
                                        print(gettodayjp.status);
                                        print("check1");
                                        Availability == true
                                            ? OutletSurveySubmit.availability =
                                                1
                                            : OutletSurveySubmit.availability =
                                                0;
                                        Visibility == true
                                            ? OutletSurveySubmit.visibility = 1
                                            : OutletSurveySubmit.visibility = 0;
                                        ShareofShelf == true
                                            ? OutletSurveySubmit.sos = 1
                                            : OutletSurveySubmit.sos = 0;
                                        Planogram == true
                                            ? OutletSurveySubmit.planogram = 1
                                            : OutletSurveySubmit.planogram = 0;
                                        compitetorcheck == true
                                            ? OutletSurveySubmit.competitor = 1
                                            : OutletSurveySubmit.competitor = 0;
                                        promotion == true
                                            ? OutletSurveySubmit
                                                .promotioncheck = 1
                                            : OutletSurveySubmit
                                                .promotioncheck = 0;
                                        expiryinfo == true
                                            ? OutletSurveySubmit.stockexpiry = 1
                                            : OutletSurveySubmit.stockexpiry =
                                                0;
                                        print("check2");

                                        print("currentoutletindex");
                                        print(currentoutletindex);
                                        if (from == "overall"
                                            ? getoveralljp.status[
                                                    currentoutletindex] ==
                                                "done"
                                            : gettodayjp.status[
                                                    currentoutletindex] ==
                                                "done") {
                                          print("if from checkout");
                                          // if(onlinemode.value){
                                          outletsurvey();
                                          print("check3");
                                          // await getTotalJnyTime();
                                          var timeofsci = DateTime.now();
                                          splitbreak.type = "Split Shift";
                                          // splitbreak.citime = "";
                                          splitbreak.cotime =
                                              DateFormat('HH:mm:ss')
                                                  .format(timeofsci);
                                          // splitbreak.jtimeid = "";
                                          await merchbreak();
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          regularcheckout = true;
                                          createlog(
                                              "Split Shift checked out tapped",
                                              "true");
                                          avaliabilitycheck = false;
                                          visibilitycheck = false;
                                          shareofshelfcheck = false;
                                          planocheck = false;
                                          await RemoveCompetitionData();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          JourneyPlanPage()));
                                          /*}else{
                                        Flushbar(
                                          message:
                                          "Active internet is required",
                                          duration: Duration(
                                              seconds: 3),
                                        )..show(context);
                                      }*/
                                        } else {
                                          print("else from checkout");
                                          outletsurvey();
                                          workingid != null
                                              ? workingid = null
                                              : workingid = workingid;
                                          await SubmitCheckout();
                                          if (onlinemode.value) {
                                            print(
                                                "smtpExampleCheckinCheckout...online");
                                            ////testing 08/11/2022
                                            await smtpExampleCheckinCheckout(
                                                'Check Out details for empid ${DBrequestdata.receivedempid}');
                                          }
                                          from == "overall"
                                              ? getoveralljp
                                                  .status[currentoutletindex]
                                              : gettodayjp.status[
                                                  currentoutletindex] = 'done';
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                          checkedoutlet.checkoutlet = true;
                                          /*print("check10");
                                        todayskipjplist.outletids.removeAt(skippedoutletindex);
                                        todayskipjplist.storenames.removeAt(skippedoutletindex);
                                        todayskipjplist.storecodes.removeAt(skippedoutletindex);
                                        todayskipjplist.outletids.removeAt(skippedoutletindex);
                                        todayskipjplist.outletlat.removeAt(skippedoutletindex);
                                        todayskipjplist.outletlong.removeAt(skippedoutletindex);
                                        todayskipjplist.outletarea.removeAt(skippedoutletindex);
                                        todayskipjplist.outletcity.removeAt(skippedoutletindex);
                                        todayskipjplist.outletcountry.removeAt(skippedoutletindex);
                                        todayskipjplist.id.removeAt(skippedoutletindex);
                                        todayskipjplist.contactnumbers.removeAt(skippedoutletindex);*/
                                          NBLDetData.fileurl = [];
                                          avaliabilitycheck = false;
                                          visibilitycheck = false;
                                          shareofshelfcheck = false;
                                          planocheck = false;
                                          await RemoveCompetitionData();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          JourneyPlanPage()));
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: orange,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                            child: Text(AppConstants.ok,
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CustomerActivities()));
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                            child: Text(AppConstants.Cancel,
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }));
        } else {
          Flushbar(
            message: "Internet Connection Required to Checkout",
            duration: Duration(seconds: 10),
          )..show(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.00),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xffFFDBC1),
          borderRadius: BorderRadius.circular(10.00),
        ),
        child: Text(
          AppConstants.Check_out,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ),
    );
  }
}
