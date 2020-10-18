import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/record.dart';
import '../helpers/db_helper.dart';

class RecordsProvider with ChangeNotifier {
  List<Record> _records = [
    Record(
      id: '1',
      amount: 100,
      name: 'Akash',
      remark: 'Shoes',
      type: 'debit',
      date: DateTime.parse('2020-09-19'),
    ),
    Record(
      id: '1',
      amount: 500,
      name: 'Akash',
      remark: 'Phone Recharge',
      type: 'credit',
      date: DateTime.parse('2020-09-20'),
    ),
    Record(
      id: '1',
      amount: 1000,
      name: 'Akash',
      remark: 'Screen Guard',
      type: 'debit',
      date: DateTime.parse('2020-10-13'),
    ),
    Record(
      id: '1',
      amount: 50,
      name: 'Akash',
      remark: 'just like that',
      type: 'credit',
      date: DateTime.parse('2020-09-03'),
    ),
  ];

  List<Record> get records {
    return _records;
  }

  void addRecord(Record newRecord) {
    newRecord = Record(
      id: Uuid().v1(),
      amount: newRecord.amount,
      name: newRecord.name,
      remark: newRecord.remark,
      type: newRecord.type,
      date: newRecord.date,
    );
    _records.insert(_records.length, newRecord);
    notifyListeners();
    DBHelper.insert('records', {
      'id': newRecord.id,
      'amount': newRecord.amount,
      'name': newRecord.name,
      'remark': newRecord.remark,
      'type': newRecord.type,
      'date': newRecord.date.toIso8601String(),
    });
  }

  Future<void> fetchAndSetParties() async {
    final dataList = await DBHelper.getData('records');
    _records = dataList.map((item) {
      return Record(
        id: item['id'],
        amount: (item['amount']),
        name: item['name'],
        remark: item['remark'],
        type: item['type'],
        date: DateTime.parse(item['date']),
      );
    }).toList();

    _records.forEach((element) {});
    // print(_parties[0].name);
    // print(_parties[1].name);
    // print(_parties[2].name);
    notifyListeners();
  }
}
