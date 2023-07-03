import 'package:assignment/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model.dart';
import 'crud_screen.dart';

class AddScreen extends StatefulWidget {
  final Dataa? dataa;
  final Function? updateNoteList;

  AddScreen({this.dataa, this.updateNoteList});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();
  String _title = '';
  String btnText = 'Add Note';
  String titleText = 'Add Title';

  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();

    if (widget.dataa != null) {
      _title = widget.dataa!.title!;
      _date = widget.dataa!.date!;

      setState(() {
        btnText = 'Update Note';
        titleText = 'Update';
      });
    } else {
      setState(() {
        btnText = 'Add Note';
        titleText = 'Add';
      });
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  // _delete() {
  //   DatabaseHelper.instance.deleteNote(widget.note!.id!);
  //
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(),
  //       ));
  //
  //   widget.updateNoteList!();
  // }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date');

      Dataa dataa = Dataa(title: _title, date: _date);

      if (widget.dataa == null) {
        // dataa.status = 0;
        DatabaseDb.instance.insertDataa(dataa);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CrudScreen(),
            ));
      } else {
        dataa.id = widget.dataa!.id;
        DatabaseDb.instance.updateDataa(dataa);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CrudScreen(),
            ));
      }
      widget.updateNoteList!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 25.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        titleText,
                        style: TextStyle(
                          color: Colors.lightBlueAccent.shade200,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter a title'
                                : null,
                            onSaved: (input) => _title = input!,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10.0),
                        //   child: DropdownButtonFormField(
                        //     isDense: true,
                        //     icon: Icon(Icons.arrow_drop_down_circle_rounded),
                        //     iconSize: 22.0,
                        //     iconEnabledColor: Theme.of(context).primaryColor,
                        //     items: _priorities.map((priority) {
                        //       return DropdownMenuItem(
                        //         value: priority,
                        //         child: Text(
                        //           priority,
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 18.0,
                        //           ),
                        //         ),
                        //       );
                        //     }).toList(),
                        //     style: TextStyle(fontSize: 18.0),
                        //     decoration: InputDecoration(
                        //       labelText: 'Priority',
                        //       labelStyle: TextStyle(fontSize: 18.0),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //     ),
                        //     validator: (input) => _priority == null
                        //         ? 'Please select a priority level'
                        //         : null,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _priority = value.toString();
                        //       });
                        //     },
                        //     value: _priority,
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              btnText.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}