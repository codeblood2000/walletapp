import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/models/record.dart';
import 'package:wallet_app/providers/party_provider.dart';

import '../providers/records_provider.dart';

enum FilterOption {
  All,
  Filter,
}

class RecordsScreen extends StatefulWidget {
  static const routeName = '/records';

  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<Record> records;
  var _selectedValue = false;
  var wait = false;
  String _selectedParty;
  List<String> _partyNames;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<RecordsProvider>(context, listen: false).fetchAndSetParties();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var recordsData = Provider.of<RecordsProvider>(context);
    var _partyData = Provider.of<PartyProvider>(context, listen: false);
    if (_selectedParty == null) {
      if (_partyData.parties.length == 0) {
        _partyData.fetchAndSetParties().then((_) {
          _partyData.getTable();
          _partyNames = _partyData.partyNames;
          _selectedParty = _partyNames.first;
        });
      } else {
        _partyNames = _partyData.partyNames;
        _selectedParty = _partyNames.first;
      }
    }
    if (!_selectedValue) {
      records = recordsData.records;
      _selectedValue = true;
    }

    Widget _titleText(String text) {
      return Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(243, 245, 248, 1)),
      );
    }

    Widget _desText(String text) {
      return Text(
        text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(243, 245, 248, 1)),
      );
    }

    Future _showDilog() async {
      return showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Party Filter',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(38, 81, 158, 1),
                      decoration: TextDecoration.underline),
                ),
                SizedBox(height: 30),
                Text(
                  'Select the Party',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue,
                    ),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    value: _selectedParty,
                    items: _partyNames.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedParty = newValue;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        elevation: 0,
        title: Text('Records'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption value) {
              if (value == FilterOption.All) {
                setState(() {
                  records = recordsData.records;
                  _selectedValue = true;
                });
              } else {
                _showDilog().then((_) {
                  setState(() {
                    records = recordsData.records
                        .where((element) => element.name == _selectedParty)
                        .toList();

                    _selectedValue = true;
                  });
                });
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('All Records'),
                value: FilterOption.All,
              ),
              PopupMenuItem(
                child: Text('Filter'),
                value: FilterOption.Filter,
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: _titleText('Date'),
            ),
            DataColumn(
              label: _titleText('Name'),
            ),
            DataColumn(
              label: _titleText('Debt Amt'),
            ),
            DataColumn(
              label: _titleText('Credit Amt'),
            ),
            DataColumn(
              label: _titleText('Remark'),
            ),
          ],
          rows: records.map<DataRow>(
            (record) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    _desText(DateFormat('d MMM').format(record.date)),
                  ),
                  DataCell(
                    _desText(record.name),
                  ),
                  DataCell(
                    record.type == 'debit'
                        ? _desText(record.amount.toString())
                        : _desText('-'),
                  ),
                  DataCell(
                    record.type == 'credit'
                        ? _desText(record.amount.toString())
                        : _desText('-'),
                  ),
                  DataCell(
                    _desText(record.remark),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
