import 'package:flutter/foundation.dart';

class Party {
  final String id;
  final String name;
  final String mobile;
  final String address;

  Party({
    @required this.id,
    @required this.mobile,
    @required this.name,
    @required this.address,
  });
}
