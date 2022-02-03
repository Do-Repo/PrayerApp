import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool value1 = true;
  bool restored = false;
  bool reset = false;
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    var savednotification =
        Provider.of<AdvancedSettingsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification settings"),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                leading: Icon(
                  Icons.info_outline_rounded,
                  size: 30,
                ),
                isThreeLine: true,
                title: Text(
                  "Please note:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "On certain devices notification sounds and background notifications will not work due to the modified Android versions they use like Xiaoumi and Huawei, we are well aware of that and trying to solve the issue.",
                ),
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                title: Text(
                  "Allow notifications for: ",
                ),
                subtitle:
                    Text("Select which prayers you want to get notified for"),
              ),
              ListTile(
                title: Text(
                  "Fajr",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    value: savednotification.savedFajr,
                    onChanged: (value) {
                      if (savednotification.savedFajr) {
                        setState(() {
                          savednotification.savedFajr =
                              !savednotification.savedFajr;
                          NotificationService().deleteNotification(0);
                        });
                      } else {
                        setState(() {
                          savednotification.savedFajr =
                              !savednotification.savedFajr;
                        });
                      }
                    }),
              ),
              ListTile(
                title: Text(
                  "Dhuhr",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    value: savednotification.savedDhuhr,
                    onChanged: (value) {
                      if (savednotification.savedDhuhr) {
                        setState(() {
                          savednotification.savedDhuhr =
                              !savednotification.savedDhuhr;
                          NotificationService().deleteNotification(1);
                        });
                      } else {
                        setState(() {
                          savednotification.savedDhuhr =
                              !savednotification.savedDhuhr;
                        });
                      }
                    }),
              ),
              ListTile(
                title: Text(
                  "Aasr",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    value: savednotification.savedAasr,
                    onChanged: (value) {
                      if (savednotification.savedAasr) {
                        setState(() {
                          savednotification.savedAasr =
                              !savednotification.savedAasr;
                          NotificationService().deleteNotification(2);
                        });
                      } else {
                        setState(() {
                          savednotification.savedAasr =
                              !savednotification.savedAasr;
                        });
                      }
                    }),
              ),
              ListTile(
                title: Text(
                  "Maghrib",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    value: savednotification.savedMaghrib,
                    onChanged: (value) {
                      if (savednotification.savedMaghrib) {
                        setState(() {
                          savednotification.savedMaghrib =
                              !savednotification.savedMaghrib;
                          NotificationService().deleteNotification(3);
                        });
                      } else {
                        setState(() {
                          savednotification.savedMaghrib =
                              !savednotification.savedMaghrib;
                        });
                      }
                    }),
              ),
              ListTile(
                title: Text(
                  "Ishaa",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    value: savednotification.savedIshaa,
                    onChanged: (value) {
                      if (savednotification.savedIshaa) {
                        setState(() {
                          savednotification.savedIshaa =
                              !savednotification.savedIshaa;
                          NotificationService().deleteNotification(4);
                        });
                      } else {
                        setState(() {
                          savednotification.savedIshaa =
                              !savednotification.savedIshaa;
                        });
                      }
                    }),
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                trailing:
                    (reset) ? Icon(Icons.done) : Icon(Icons.preview_outlined),
                title: Text("Test notification"),
                onTap: () {
                  if (!reset) {
                    setState(() {
                      NotificationService().setTestNotification(context);

                      reset = true;
                    });
                  }
                },
                subtitle:
                    Text("Preview of what the notification will look like"),
              ),
              ListTile(
                  tileColor: Theme.of(context).backgroundColor,
                  trailing:
                      Icon((restored) ? Icons.done : Icons.restore_outlined),
                  title: Text("Reset Notification"),
                  onTap: () {
                    if (!restored) {
                      NotificationService().deleteAllNotifications();
                      setState(() {
                        restored = true;
                      });
                    }
                  },
                  subtitle:
                      Text("Only use this when notifications are not working")),
            ],
          ),
        ),
      ),
    );
  }
}
