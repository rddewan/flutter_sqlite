import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/contact.dart';
import 'package:flutter_sqlite/utils/database_helper.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({this.title});

  @override
  _homePage createState() => _homePage(title);
}

class _homePage extends State<StatefulWidget> {
  String _title;

  //generate unique key value for form
  final _formKey = GlobalKey<FormState>();

  //
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _databaseHelper;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  _homePage(this._title);

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
    });
    //refresh the contact / get from db
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          "$_title",
          style: TextStyle(color: Colors.blue[700]),
        )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _form(),
              _list(),
            ],
          ),
        ),
      ),
    );
  }

  _form() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              onSaved: (val) => setState(() => _contact.name = val),
              validator: (val) =>
                  (val.length == 0 ? 'This filed is required' : null),
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextFormField(
              controller: _phoneController,
              onSaved: (val) => setState(() => _contact.mobile = val),
              validator: (val) =>
                  (val.length == 0 ? 'This filed is required' : null),
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextFormField(
              controller: _emailController,
              onSaved: (val) => setState(() => _contact.email = val),
              validator: (val) =>
                  (val.isEmpty ? 'This field is required' : null),
              decoration: InputDecoration(labelText: "Email"),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  _onSubmit();
                },
                child: Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _list() {
    return Expanded(
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (contex, index) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.indigo,
                    size: 32,
                  ),
                  title: Text(
                    _contacts[index].name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_contacts[index].mobile),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: () {
                        _databaseHelper.deleteContact(_contacts[index].id);
                        _resetForm();
                        _refreshContactList();
                      }),
                  onTap: () {
                    setState(() {
                      _contact = _contacts[index];
                      _nameController.text = _contact.name;
                      _phoneController.text = _contact.mobile;
                      _emailController.text = _contact.name;
                    });
                  },
                ),
                Divider(
                  height: 8,
                ),
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ),
    );
  }

  _refreshContactList() async {
    List<Contact> x = await _databaseHelper.getContacts();
    setState(() {
      _contacts = x;
    });
  }

  void _onSubmit() async {
    //get the current sate of the form
    var form = _formKey.currentState;
    if (form.validate()) {
      //Saves every [FormField] that is a descendant of this [Form].
      form.save();
      //
      if (_contact.id == null) {
        //insert to db
        await _databaseHelper.insertContact(_contact);
      } else {
        //update the record
        await _databaseHelper.updateContact(_contact);
      }

      //get the lit from db
      _refreshContactList();
      //
      _resetForm();

      // Resets every [FormField] that is a descendant of this [Form] back to its
      //[FormField.initialValue].
      form.reset();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _contact.id = null;
    });
  }
}
