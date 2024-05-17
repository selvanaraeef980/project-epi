import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eipscan_app/SettingScreen.dart';
import 'package:eipscan_app/information_page.dart';
import 'package:eipscan_app/main.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Medication {
  String name;
  List<TimeOfDay> times;

  Medication({required this.name, required this.times});
}

String imagePath = 'assets/images/capture.png'; 

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Medication> medications = [];
  String newMedicationName = '';
  List<TimeOfDay> newMedicationTimes = [];
  int notificationId = 0;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    tz.initializeTimeZones();
    Timer.periodic(Duration(minutes: 1), (timer) {
      _scheduleMedications();
    });
  }

  Future<void> _initNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/capture.png',
      [
        NotificationChannel(
          channelKey: 'Basic key',
          channelName: 'test channel',
          channelDescription: 'Medicine Reminder',
          playSound: true,
          channelShowBadge: true,
          importance: NotificationImportance.High,
        )
      ],
    );

    // Check if notification permission is granted
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Request notification permission if not granted
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _scheduleNotification(
      int id, String medicationName, tz.TZDateTime scheduledDate) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'Basic key',
        title: 'Medication Reminder',
        body: 'Time to take your medication: $medicationName',
        bigPicture: imagePath,
        notificationLayout: NotificationLayout.BigPicture,
      ),
      schedule: NotificationCalendar(
        timeZone: scheduledDate.timeZoneName,
        hour: scheduledDate.hour,
        minute: scheduledDate.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  void _addMedication() {
    if (newMedicationName.isNotEmpty && newMedicationTimes.isNotEmpty) {
      final medication = Medication(
          name: newMedicationName, times: List.from(newMedicationTimes));
      setState(() {
        medications.add(medication);
      });
      _scheduleMedications(); // جدولة الإشعارات للأدوية الجديدة
      // إعادة تهيئة الحقول
      newMedicationName = '';
      newMedicationTimes.clear();
    }
  }

  void _scheduleMedications() {
    final now = DateTime.now();
    for (var medication in medications) {
      for (var time in medication.times) {
        var scheduledDate = DateTime(now.year, now.month, now.day, time.hour,
            time.minute).toUtc();
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(Duration(days: 1));
        }
        var delay = scheduledDate.difference(now);
        Timer(delay, () async {
          final tzScheduledDate = tz.TZDateTime.utc(
            scheduledDate.year,
            scheduledDate.month,
            scheduledDate.day,
            scheduledDate.hour,
            scheduledDate.minute,
          );
          await _scheduleNotification(
              notificationId++, medication.name, tzScheduledDate);
        });
      }
    }
  }

  void _addMultipleTimes(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Times'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: newMedicationTimes.length + 1,
              itemBuilder: (context, index) {
                if (index == newMedicationTimes.length) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          newMedicationTimes.add(picked);
                        });
                      }
                    },
                    child: Text('Add Time'),
                  );
                }
                return ListTile(
                  title: Text('${newMedicationTimes[index].format(context)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        newMedicationTimes.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 209, 207, 207),
        title: Text('Medication Reminder'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Medication Name'),
                onChanged: (value) {
                  newMedicationName = value;
                },
              ),
              SizedBox(height: 20),
              ...newMedicationTimes.map((time) => ListTile(
                    title: Text('${time.format(context)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => setState(() {
                        newMedicationTimes.remove(time);
                      }),
                    ),
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: () => _addMultipleTimes(context),
                child: Text(
                  'Add Times for Medication',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: _addMedication,
                child: Text(
                  'Save Medication',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Scheduled Medications:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(medications[index].name),
                    subtitle: Text(
                      'Times: ${medications[index].times.map((time) => time.format(context)).join(', ')}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          medications.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
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
          print('Tapped on item $index');
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
