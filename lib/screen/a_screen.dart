import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AaScreen extends StatefulWidget {
  const AaScreen({super.key});

  @override
  State<AaScreen> createState() => _AaScreenState();
}

class _AaScreenState extends State<AaScreen> {
  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.now();
    String datetime = DateFormat.Hms().format(dateTime);
    print(datetime);

    String datetime2 = DateFormat.MMMMEEEEd().format(dateTime);
    print(datetime2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman A"),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(datetime),

            Text(datetime2),
          ],
        ),
      ),
    );
  }
}
