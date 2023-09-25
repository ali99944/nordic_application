import 'package:flutter/material.dart';

import '../models/issue_notification_data.dart';
import '../services/issue_service.dart';

class NotificationsTab extends StatefulWidget {
  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IssueService.getAllNotifications(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.hasError){
          return Center(
            child: Text('Something went wrong'),
          );
        }

        if(snapshot.data != null){
          List<IssueNotificationData> issues = (snapshot.data as List).map((notification){
            return IssueNotificationData(
                title: notification['title'],
                body: notification['body'],
                date: notification['date'],
                type: notification['type']
            );
          }).toList().reversed.toList();

          if(issues.isEmpty){
            return Center(
              child: Text('Ingen varsel ennå',style: TextStyle(
                  fontSize: 20
              ),),
            );
          }

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return ListTile(
                title: Text(issue.title),
                subtitle: Text(issue.body),
                trailing: Text(issue.date),
                leading: Icon(issue.type == 'issue' ? Icons.warning : Icons.notifications,color: issue.type == 'issue'? Colors.amber : Colors.green,size: 30,),
                onTap: () {

                },
              );
            },
          );
        }

        return Container();
      },
    );
  }
}