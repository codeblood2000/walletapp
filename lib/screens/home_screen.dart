import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/models/record.dart';
import 'package:wallet_app/screens/form_screen.dart';
import 'package:wallet_app/screens/records_screen.dart';

import '../providers/records_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var wait = true;
  var credit_button = false;
  var debit_button = false;
  @override
  Widget build(BuildContext context) {
    var recordData = Provider.of<RecordsProvider>(context);
    int ccost = 0, dcost = 0;
    if (wait) {
      recordData.fetchAndSetParties().then((_) {
        wait = false;
      });
    }
    recordData.records.sort((a, b) {
      var adate = a.date;
      var bdate = b.date;
      return bdate.compareTo(adate);
    });
    //  if (recordData.records.length != 0) {
    for (int i = 0; i < recordData.records.length; i++) {
      if (recordData.records[i].type == 'credit') {
        ccost += recordData.records[i].amount;
      } else {
        dcost += recordData.records[i].amount;
      }
    }
    print(ccost.toString() + '  ' + dcost.toString());
    //}
    var todayRecords = recordData.records.where((element) {
      var date = DateFormat('d/M/y').format(element.date);
      var now = DateFormat('d/M/y').format(DateTime.now());
      if (now == date) {
        return true;
      }
      return false;
    }).toList();
    var yesterdayRecords = recordData.records.where((element) {
      var date = DateFormat('d/M/y').format(element.date);
      var now = DateFormat('d/M/y')
          .format(DateTime.now().subtract(Duration(days: 1)));
      if (now == date) {
        return true;
      }
      return false;
    }).toList();

    var credit_today_records =
        todayRecords.where((element) => element.type == 'credit').toList();
    var credit_yesterday_records =
        yesterdayRecords.where((element) => element.type == 'credit').toList();
    var debit_today_records =
        todayRecords.where((element) => element.type == 'debit').toList();
    var debit_yesterday_records =
        yesterdayRecords.where((element) => element.type == 'debit').toList();

    Widget _container(String text) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500]),
        ),
      );
    }

    Widget recordTitle(Record record) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child:
              // if (recordData.records[i].date.day !=
              //     recordData.records[i + 1].date.day)
              // _dateToBeDisplayed(recordData.records[i].date),

              Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.date_range,
                  color: Colors.lightBlue[900],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900]),
                    ),
                    Text(
                      record.remark,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  record.type == 'credit'
                      ? Text(
                          '+\u20B9${record.amount.toString()}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.lightGreen),
                        )
                      : Text(
                          '-\u20B9${record.amount.toString()}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                  Text(
                    DateFormat('d MMM').format(record.date),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ));
    }

    // Widget _dateToBeDisplayed(DateTime date) {
    //   if (DateTime.now().month == date.month &&
    //       DateTime.now().year == date.year &&
    //       DateTime.now().day - 7 <= date.day) {
    //     if (DateTime.now().day == date.day) {
    //       return _container('Today');
    //     } else if (DateTime.now().day - 1 == date.day) {
    //       return _container('Yestaday');
    //     } else {
    //       return _container('${DateFormat('E')}');
    //     }
    //   } else {
    //     return _container('No recent transaction');
    //   }
    // }
    Widget _cdbuttons(String title, Icon icon) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromRGBO(243, 245, 248, 1),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: IconButton(
              icon: icon,
              color: Colors.blue[900],
              iconSize: 40,
              onPressed: () {
                title.toLowerCase() == 'report'
                    ? Navigator.of(context).pushNamed(RecordsScreen.routeName)
                    : Navigator.of(context)
                        .pushNamed(FormScreen.routeName, arguments: title);
              },
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.lightBlue[100],
            ),
          ),
        ],
      );
    }

    Widget _button(String title, Color color) {
      return GestureDetector(
        onTap: () {
          if (title.toLowerCase() == 'credit') {
            setState(() {
              credit_button = true;
              debit_button = false;
              print(credit_button);
            });
          } else {
            setState(() {
              credit_button = false;
              debit_button = true;
              print(credit_button);
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: color,
              ),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.grey[900]),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 10,
                  spreadRadius: 4.5,
                )
              ]),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\u20B9${(ccost - dcost).toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                        child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.lightBlue[100],
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          radius: 26,
                          child: ClipOval(
                            child:
                                Image.asset('assets/images/blank_profile.png'),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
                Text(
                  'Available Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.lightBlue[100],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _cdbuttons('Credit', Icon(Icons.credit_card)),
                          _cdbuttons('Debit', Icon(Icons.card_membership)),
                          _cdbuttons('Report', Icon(Icons.receipt))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Color.fromRGBO(243, 245, 248, 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RecordsScreen.routeName);
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    //Container for buttons
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                credit_button = false;
                                debit_button = false;
                                print(credit_button);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "All",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.grey[900]),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 10,
                                      spreadRadius: 4.5,
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(width: 16),
                          _button('Credit', Colors.green),
                          SizedBox(width: 16),
                          _button('Debit', Colors.orange),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[500]),
                      ),
                    ),
                    //Container Listview for records
                    // todayRecords.length == 0
                    //     ? Text('NoTransactions'):
                    credit_button
                        ? ListView.builder(
                            itemBuilder: (context, i) =>
                                recordTitle(credit_today_records[i]),
                            itemCount: credit_today_records.length,
                            shrinkWrap: true,
                          )
                        : debit_button
                            ? ListView.builder(
                                itemBuilder: (context, i) =>
                                    recordTitle(debit_today_records[i]),
                                itemCount: debit_today_records.length,
                                shrinkWrap: true,
                              )
                            : ListView.builder(
                                itemBuilder: (context, i) =>
                                    recordTitle(todayRecords[i]),
                                itemCount: todayRecords.length,
                                shrinkWrap: true,
                              ),

                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Yesterday',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[500]),
                      ),
                    ),

                    credit_button
                        ? ListView.builder(
                            itemBuilder: (context, i) =>
                                recordTitle(credit_yesterday_records[i]),
                            itemCount: credit_yesterday_records.length,
                            shrinkWrap: true,
                          )
                        : debit_button
                            ? ListView.builder(
                                itemBuilder: (context, i) =>
                                    recordTitle(debit_yesterday_records[i]),
                                itemCount: debit_yesterday_records.length,
                                shrinkWrap: true,
                              )
                            : ListView.builder(
                                itemBuilder: (context, i) =>
                                    recordTitle(yesterdayRecords[i]),
                                itemCount: yesterdayRecords.length,
                                shrinkWrap: true,
                              ),
                  ],
                ),
                controller: scrollController,
              ),
            ),
          )
        ],
      ),
    );
  }
}
