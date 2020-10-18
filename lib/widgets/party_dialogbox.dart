import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/party.dart';
import '../providers/party_provider.dart';

class PartyDialogBox extends StatefulWidget {
  @override
  _PartyDialogBoxState createState() => _PartyDialogBoxState();
}

class _PartyDialogBoxState extends State<PartyDialogBox> {
  var _newParty = Party(id: '', mobile: '', name: '', address: '');
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var partyData = Provider.of<PartyProvider>(context, listen: false);

    void _saveform() {
      if (!_formKey.currentState.validate()) {
        return;
      } else {
        _formKey.currentState.save();

        partyData.addParty(_newParty);
      }
    }

    return Dialog(
      child: Container(
        height: 350,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Party',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the name';
                    }
                    //else if (partyData.parties
                    //     .any((element) => element.name == value)) {
                    //   print(partyData.parties);
                    //   return 'Name already exists';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    _newParty = Party(
                        id: '',
                        mobile: _newParty.mobile,
                        name: value,
                        address: _newParty.address);
                  },
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Mobile no.'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Mobile number';
                      }
                      if (double.tryParse(value) == null ||
                          value.length != 10) {
                        return 'Please enter a vaild number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newParty = Party(
                          id: '',
                          mobile: value,
                          name: _newParty.name,
                          address: _newParty.address);
                    }),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a vaild address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newParty = Party(
                        id: '',
                        mobile: _newParty.mobile,
                        name: _newParty.name,
                        address: value);
                  },
                ),
                RaisedButton(
                    onPressed: () {
                      _saveform();
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Done'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
