import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/records_provider.dart';
import './providers/party_provider.dart';
import './screens/home_screen.dart';
import './screens/form_screen.dart';
import './screens/records_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PartyProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RecordsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WalletApp(),
        routes: {
          FormScreen.routeName: (ctx) => FormScreen(),
          RecordsScreen.routeName: (ctx) => RecordsScreen(),
        },
      ),
    );
  }
}

class WalletApp extends StatefulWidget {
  @override
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  @override
  Widget build(BuildContext context) {
    var screens = [
      HomeScreen(),
      RecordsScreen(),
    ];

    var selectedTab = 0;
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                icon: Icon(Icons.receipt),
                onPressed: () {
                  Navigator.of(context).pushNamed(RecordsScreen.routeName);
                }),
            title: Text('Records'),
          )
        ],
        onTap: (index) {
          setState(() {
            selectedTab = index;
            print(index);
          });
        },
        showUnselectedLabels: true,
        iconSize: 30,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        color: Color.fromRGBO(38, 81, 158, 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        onPressed: () {
                          Navigator.of(context).pushNamed(FormScreen.routeName,
                              arguments: 'credit');
                        },
                        child: Text(
                          'Credit',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      RaisedButton(
                        color: Color.fromRGBO(38, 81, 158, 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        onPressed: () {
                          Navigator.of(context).pushNamed(FormScreen.routeName,
                              arguments: 'debit');
                        },
                        child: Text(
                          'Debit',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        elevation: 0,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[selectedTab],
    );
  }
}
