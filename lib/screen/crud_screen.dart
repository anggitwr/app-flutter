import 'package:assignment/database/database.dart';
import 'package:assignment/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_screen.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {

  late Future<List<Dataa>> _dataaList;

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  DatabaseDb _databaseDb = DatabaseDb.instance;

  @override
  void initState() {
    super.initState();
    _updateDataaList();
  }

  _updateDataaList() {
    _dataaList = DatabaseDb.instance.getDataaList();
  }

  _delete(Dataa dataa) {
    DatabaseDb.instance.deleteDataa(dataa.id!);
    _updateDataaList();
    setState((){ });
  }

  Widget _buildDataDesign(Dataa dataa, BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Card(
        elevation: 2.0,
        child: ListTile(
          title: Text(
            dataa.title!,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showConfirmDialog(dataa);
                },
                child: Icon(
                  Icons.delete,
                  size: 25.0,
                  color: Colors.red,
                ),
              ),
              // Checkbox(
              //   onChanged: (value) {
              //     note.status = value! ? 1 : 0;
              //     DatabaseHelper.instance.updateNote(note);
              //     _updateNoteList();
              //     Navigator.pushReplacement(
              //         context, MaterialPageRoute(builder: (_) => HomeScreen()));
              //   },
              //   activeColor: Theme.of(context).primaryColor,
              //   value: note.status == 1 ? true : false,
              // ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddScreen(
                  updateNoteList: _updateDataaList(),
                  dataa: dataa,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddScreen(
                updateNoteList: _updateDataaList,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: _dataaList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }


            // final int completeNoteCount = snapshot.data!
            //     .where((Dataa dataa)  => dataa.status == 1)
            //     .toList()
            //     .length;

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              itemCount: int.parse(snapshot.data.length.toString()) + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CRUD Screen',
                          style: TextStyle(
                            color: Colors.lightBlueAccent.shade200,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  );
                }
                return _buildDataDesign(snapshot.data![index - 1], context);
              },
            );
          }),
    );
  }
  showConfirmDialog(Dataa dataa) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              height: 150.0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Are you sure you want to delete?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14.0),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // foreground
                        ),
                        onPressed: () {
                          _delete(dataa);
                          Navigator.pop(context);
                        },
                        child: const Text('Yes',
                            style:
                            TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // foreground
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No',
                            style:
                            TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
