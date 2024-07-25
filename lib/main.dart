import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quiz_random/index.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Ganti dengan warna yang diinginkan jika diperlukan
      ),
      home: ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
        backgroundColor: Color(0xFF39D2DD),
      ),
      backgroundColor: Color(0xFF39D2DD), // Latar belakang warna #39D2DD
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
          child: Text(
            'Go to Quiz Page',
            style: TextStyle(color: Colors.black), // Warna teks hitam
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Warna latar belakang putih
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        child: Text(
          '${_currentTime.hour}:${_currentTime.minute}:${_currentTime.second}',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black, // Warna teks hitam
          ),
        ),
      ),
    );
  }
}
