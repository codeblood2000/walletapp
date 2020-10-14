import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/records_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var recordData = Provider.of<RecordsProvider>(context);
    recordData.records.sort((a, b) {
      var adate = a.date;
      var bdate = b.date;
      return bdate.compareTo(adate);
    });

    var todayRecords = recordData.records.where((element) {
      var date = DateFormat('d/M/y').format(element.date);
      var now = DateFormat('d/M/y').format(DateTime.now());
      if (now == date) {
        return true;
      }
      return false;
    });
    var yestadayRecords = recordData.records.where((element) {
      var date = DateFormat('d/M/y').format(element.date);
      var now = DateFormat('d/M/y')
          .format(DateTime.now().subtract(Duration(days: 1)));
      if (now == date) {
        return true;
      }
      return false;
    });

    for (int i = 0; i < recordData.records.length; i++) {
      print(recordData.records[i].name);
      print(recordData.records[i].date);
    }

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

    Widget _button(String title, Color color) {
      return Container(
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
                      '\$2765.90',
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
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(243, 245, 248, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.blue[900],
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Credit',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.lightBlue[100],
                            ),
                          ),
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
                          Text(
                            'See All',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.grey,
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
                          Container(
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
                    ListView.builder(
                      itemBuilder: (context, i) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
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
                            )
                          ],
                        ),
                      ),
                      itemCount: recordData.records.length,
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
