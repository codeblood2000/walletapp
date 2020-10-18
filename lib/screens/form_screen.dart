import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/record.dart';
import '../providers/party_provider.dart';
import '../providers/records_provider.dart';
import '../widgets/party_dialogbox.dart';

class FormScreen extends StatefulWidget {
  static const routeName = '/form_screen';

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var selectedDate = DateTime.now();
  var newRecord = Record(
      id: '', amount: 0, name: '', remark: '', type: '', date: DateTime.now());
  var init = true;
  var wait = true;
  var _formKey = GlobalKey<FormState>();
  String partyName = ' ';

  @override
  void didChangeDependencies() {
    if (init) {
      final partyData = Provider.of<PartyProvider>(context);
      partyData.fetchAndSetParties().then((_) {
        partyData.getTable();

        if (partyName == ' ') {
          partyName = partyData.partyNames.length != 0
              ? partyData.partyNames.first
              : ' ';
        }
      });
      wait = false;
      // init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    final partyData = Provider.of<PartyProvider>(context);
    //partyData.getTable();

    final recordsData = Provider.of<RecordsProvider>(context);

    void _saveForm() {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      newRecord = Record(
        id: newRecord.id,
        amount: newRecord.amount,
        name: partyName,
        remark: newRecord.remark,
        type: title.toLowerCase(),
        date: selectedDate,
      );
      recordsData.addRecord(newRecord);
      Navigator.of(context).pop();
    }

    void _selectedDate() async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: selectedDate,
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    void _showDilogBox() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => PartyDialogBox(),
      );
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(32, 38, 32, 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(243, 245, 248, 1),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Detalis',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                              )),
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newRecord = Record(
                              id: newRecord.id,
                              amount: int.parse(value),
                              name: newRecord.name,
                              remark: newRecord.remark,
                              type: newRecord.type,
                              date: newRecord.date,
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        Row(children: [
                          Text(
                            'Party',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 50),
                          DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            value: partyName,
                            items: partyData.partyNames.length == 0 ||
                                    partyData.partyNames == null
                                ? [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Add Party',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      value: partyName,
                                    )
                                  ]
                                : partyData.partyNames
                                    .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                partyName = newValue;
                              });
                            },
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.blue[800],
                              ),
                              onPressed: _showDilogBox)
                        ]),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 35),
                            FlatButton(
                              onPressed: _selectedDate,
                              child: Text(
                                DateFormat('d/M/y').format(selectedDate),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.date_range,
                                size: 40,
                                color: Colors.blue[800],
                              ),
                              onPressed: _selectedDate,
                            )
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Remark',
                              labelStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              )),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          minLines: 2,
                          maxLines: 15,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter remark';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newRecord = Record(
                              id: newRecord.id,
                              amount: newRecord.amount,
                              name: newRecord.name,
                              remark: value,
                              type: newRecord.type,
                              date: newRecord.date,
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            color: Colors.blue[800],
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            onPressed: _saveForm,
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(title),
    //   ),
    //   body: wait
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : Form(
    //           key: _formKey,
    //           child: Container(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               children: [
    //                 Row(children: [
    //                   Text('Party'),
    //                   SizedBox(width: 20),
    //                   DropdownButton<String>(
    //                     value: partyName,
    //                     items: partyData.partyNames.length == 0
    //                         ? [
    //                             DropdownMenuItem(
    //                               child: Text(partyName),
    //                               value: partyName,
    //                             )
    //                           ]
    //                         : partyData.partyNames
    //                             .map<DropdownMenuItem<String>>((value) {
    //                             return DropdownMenuItem(
    //                               child: Text(value),
    //                               value: value,
    //                             );
    //                           }).toList(),
    //                     onChanged: (newValue) {
    //                       setState(() {
    //                         partyName = newValue;
    //                       });
    //                     },
    //                   ),
    //                   Spacer(),
    //                   IconButton(
    //                       icon: Icon(Icons.add), onPressed: _showDilogBox)
    //                 ]),
    //                 SizedBox(height: 10),
    //                 // GestureDetector(
    //                 //   onTap: () => _selectedDate(),
    //                 //   child: Container(
    //                 //     color: Colors.grey,
    //                 //     margin: EdgeInsets.all(10),
    //                 //     padding: EdgeInsets.all(10),
    //                 //     child: Text(
    //                 //       DateFormat.yMd().format(selectedDate),
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 FlatButton(
    //                   onPressed: _selectedDate,
    //                   child: Text(
    //                     DateFormat('d/M/y').format(selectedDate),
    //                   ),
    //                 ),
    //                 SizedBox(height: 10),
    //                 TextFormField(
    //                   decoration: InputDecoration(labelText: 'Amount'),
    //                   validator: (value) {
    //                     if (value.isEmpty) {
    //                       return 'Please enter Amount';
    //                     }
    //                     if (double.tryParse(value) == null) {
    //                       return 'Please enter a valid number.';
    //                     }
    //                     if (double.parse(value) <= 0) {
    //                       return 'Please enter a number greater than zero.';
    //                     }
    //                     return null;
    //                   },
    //                   onSaved: (value) {
    //                     newRecord = Record(
    //                       id: newRecord.id,
    //                       amount: int.parse(value),
    //                       name: newRecord.name,
    //                       remark: newRecord.remark,
    //                       type: newRecord.type,
    //                       date: newRecord.date,
    //                     );
    //                   },
    //                 ),
    //                 TextFormField(
    //                   decoration: InputDecoration(labelText: 'Remark'),
    //                   validator: (value) {
    //                     if (value.isEmpty) {
    //                       return 'Please enter remark';
    //                     }
    //                     return null;
    //                   },
    //                   onSaved: (value) {
    //                     newRecord = Record(
    //                       id: newRecord.id,
    //                       amount: newRecord.amount,
    //                       name: newRecord.name,
    //                       remark: value,
    //                       type: newRecord.type,
    //                       date: newRecord.date,
    //                     );
    //                   },
    //                 ),
    //                 SizedBox(height: 10),
    //                 Align(
    //                   alignment: Alignment.center,
    //                   child: RaisedButton(
    //                     onPressed: _saveForm,
    //                     child: Text('Done'),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    // );
  }
}
