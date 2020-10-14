import 'package:flutter/foundation.dart';

class Record {
  final String id;
  final String name;
  final int amount;
  final String remark;
  final String type;
  final DateTime date;

  Record({
    @required this.id,
    @required this.amount,
    @required this.name,
    @required this.remark,
    @required this.type,
    @required this.date,
  });
}
