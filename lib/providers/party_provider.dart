import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/party.dart';
import '../helpers/db_helper.dart';

class PartyProvider with ChangeNotifier {
  List<Party> _parties = [
    Party(id: '1', name: 'Akash', address: 'Mumbai', mobile: '9012345678'),
    Party(id: '2', name: 'Yash', address: 'Bangalore', mobile: '9035678950'),
    Party(id: '3', name: 'Khushi', address: 'Bangalore', mobile: '9035674567'),
    Party(id: '4', name: 'Aditi', address: 'Mumbai', mobile: '9035671234'),
    Party(id: '5', name: 'Rani', address: 'Kusumi', mobile: '9035677896'),
  ];

  List<Party> get parties {
    return [..._parties];
  }

  List<String> partyNames = [];

  void addParty(Party newParty) {
    print(newParty.name);
    newParty = Party(
      id: Uuid().v1(),
      mobile: newParty.mobile,
      name: newParty.name,
      address: newParty.address,
    );
    _parties.insert(_parties.length, newParty);
    notifyListeners();
    DBHelper.insert('parties', {
      'id': newParty.id,
      'name': newParty.name,
      'address': newParty.address,
      'mobile': newParty.mobile,
    });
  }

  Future<void> fetchAndSetParties() async {
    final dataList = await DBHelper.getData('parties');
    print(dataList);
    _parties = dataList
        .map((item) => Party(
            id: item['id'],
            mobile: item['mobile'],
            name: item['name'],
            address: item['address']))
        .toList();
    // print(_parties[0].name);
    // print(_parties[1].name);
    // print(_parties[2].name);
    notifyListeners();
  }

  void getTable() {
    if (_parties.length != 0) {
      print('get table');
      partyNames = [];
      _parties.forEach((element) {
        partyNames.add(element.name);
      });
    }
  }
}
