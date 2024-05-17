import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eipscan_app/Dises.dart';
import 'package:eipscan_app/NotificationPage.dart';
import 'package:eipscan_app/SettingScreen.dart';
import 'package:eipscan_app/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Information Page',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: InformationPage(),
    );
  }
}

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disease Information"),
        backgroundColor: Color.fromARGB(255, 209, 207, 207),
        elevation: 0,
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 28, 27, 27),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 40),
              customButton(context, 'Melanoma'),
              customButton(context, 'Melanocytes'),
              customButton(context, 'Dermatofibroma'),
              customButton(context, 'Actinic keratosis'),
              customButton(context, 'Vascular lesions'),
              customButton(context, 'Basal cell carcinoma'),
              customButton(context, 'Benign keratosis '),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.info, size: 30, color: Colors.white),
          Icon(Icons.alarm, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        animationCurve: Curves.easeInOut,
        color: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          // Handle tap events here
          print('Tapped on item $index');
          // You can navigate to different pages based on the index
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Firstpage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InformationPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
          }
        },
      ),
    );
  }
}

Widget customButton(BuildContext context, String title) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8, // تناسب الشاشة
    height: 60,
    margin: const EdgeInsets.only(bottom: 10),
    child: ElevatedButton(
      onPressed: () {
        if (title == 'Benign keratosis ') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KeratosisisesPage()));
        } else if (title == 'Melanocytes') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'Melanocytes')));
        } else if (title == 'Melanoma') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MelanomaPage()));
        } else if (title == 'Basal cell carcinoma') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BasalCellCarcinomaPage()));
        } else if (title == 'Vascular lesions') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VascularlesionsPage()));
        } else if (title == 'Dermatofibroma') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DermatofibromaPage()));
        } else if (title == 'Actinic keratosis') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ActinicKeratosisPage()));
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // لون الأزرار
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}


