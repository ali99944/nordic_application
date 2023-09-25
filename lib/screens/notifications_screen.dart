import 'package:car_app/services/notification_service.dart';
import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: NotificationService.getAllNotifications(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Noe gikk galt'),
                );
              }

              if (snapshot.data != null) {
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.length, // Replace with your desired number of items
                  itemBuilder: (context, index) {
                    final notification = (snapshot.data as List).reversed.toList()[index];
                    return _buildNotification(
                      title: notification['title'],
                      message: notification['body'],
                      time: notification['date'],
                    );
                  },
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildNotification({
  required String title,
  required String message,
  required String time,
}) {
  return Card(
    elevation: 5.0,
    color: ThemeHelper.buttonPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 48.0,
            color: Colors.white,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Align(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
